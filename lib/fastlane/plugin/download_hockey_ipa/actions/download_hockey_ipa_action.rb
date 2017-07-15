require 'faraday'
require 'faraday_middleware'
require 'json'

module Fastlane
  module Actions
    class DownloadHockeyIpaAction < Action
      HOST_NAME = 'https://rink.hockeyapp.net'

      def self.run(params)

        api_token = params[:api_token]
        app_id = params[:app_id]
        app_build_id = params[:app_build_id]
        ipa_file_path = params[:ipa_file_path]

        conn = Faraday.new(:url => HOST_NAME) do |faraday|
          faraday.request  :multipart
          faraday.request  :url_encoded
          logger = Logger.new(STDOUT)
          logger.level = Logger::INFO
          faraday.response :logger, logger
          faraday.adapter  Faraday.default_adapter
          faraday.headers['X-HockeyAppToken'] = api_token
        end

        versions = conn.get do |req|
          req.url("/api/2/apps/#{app_id}/app_versions/")
        end

        versions_json = JSON.parse(versions.body)
        version_id = versions_json['app_versions']
        .map { |version|
          version['id'].to_s
        }
        .select { |id|
          id == app_build_id
        }.first

        response = conn.get do |req|
          req.url "/api/2/apps/#{app_id}/app_versions/#{version_id}"
        end

        if response.status == 200
          result = Plist::parse_xml(response.body)
          download_url = result['items'][0]['assets'][0]['url']

          File.open(ipa_file_path, "wb") do |saved_file|
            open(download_url, "rb") do |read_file|
              saved_file.write(read_file.read)
            end
          end
          UI.success "Successfully downloaded ipa 🍺"
        else
          UI.error "Something went wrong with API request. Status code is #{response.status}"
        end
      end

      def self.description
        "A fastlane plugin that helps downloading .ipa from HockeyApp"
      end

      def self.authors
        ["horimislime"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                  env_name: "HOCKEY_API_TOKEN",
                               description: "API Token for Hockey Access",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                    UI.user_error!("No API token for Hockey given, pass using `api_token: 'token'`") if value.to_s.length == 0
                                  end),

          FastlaneCore::ConfigItem.new(key: :app_id,
                                  env_name: "HOCKEY_IPA_DOWNLOAD_APP_ID",
                               description: "Application identifier of the app you want to download",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                    UI.user_error!("No app_id is given, pass using `app_id: 'id'`") if value.to_s.length == 0
                                  end),

          FastlaneCore::ConfigItem.new(key: :app_build_id,
                                  env_name: "HOCKEY_IPA_APP_BUILD_ID",
                               description: "The unique id of the specified app, which can be found in the app's URL (e.g. rink.hockeyapp.net/manage/apps/[app_id]/app_versions/[app_build_id])",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :ipa_file_path,
                                  env_name: "HOCKEY_IPA_DOWNLOAD_PATH",
                               description: "Path to your symbols file",
                                  optional: false,
                                      type: String,
                             default_value: File.expand_path('.'))
        ]
      end

      def self.is_supported?(platform)
        [:ios, :osx].include?(platform)
      end
    end
  end
end
