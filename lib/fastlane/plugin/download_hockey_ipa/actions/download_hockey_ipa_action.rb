require 'faraday'
require 'faraday_middleware'
require 'json'
require 'open-uri'
require 'plist'

module Fastlane
  module Actions
    class DownloadHockeyIpaAction < Action
      HOST_NAME = 'https://rink.hockeyapp.net'

      def self.run(params)

        api_token = params[:api_token]
        build_number = params[:build_number]
        public_identifier = params[:public_identifier]
        ipa_path = params[:ipa_path]

        conn = Faraday.new(:url => HOST_NAME) do |faraday|
          faraday.request  :multipart
          faraday.request  :url_encoded
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
          faraday.headers['X-HockeyAppToken'] = api_token
        end

        versions = conn.get do |req|
          req.url("/api/2/apps/#{public_identifier}/app_versions/")
        end

        versions_json = JSON.parse(versions.body)
        version_id = versions_json['app_versions'].map { |version|
          version['id'].to_s
        }
        .select { |id|
          id == build_number
        }.first

        response = conn.get do |req|
          req.url "/api/2/apps/#{public_identifier}/app_versions/#{version_id}"
        end

        if response.status == 200
          result = Plist::parse_xml(response.body)
          download_url = result['items'][0]['assets'][0]['url']

          File.open(ipa_path, "wb") do |saved_file|
            open(download_url, "rb") do |read_file|
              saved_file.write(read_file.read)
            end
          end
          UI.success "Successfully downloaded ipa."
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

          FastlaneCore::ConfigItem.new(key: :public_identifier,
                                  env_name: "PUBLIC_IDENTIFIER_TO_DOWNLOAD_IPA",
                               description: "Public identifier of the app you want to download",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                    UI.user_error!("No public identifier for Hockey given, pass using `public_identifier: 'public_identifier'`") if value.to_s.length == 0
                                  end),

          FastlaneCore::ConfigItem.new(key: :ipa_path,
                                  env_name: "IPA_DOWNLOAD_PATH",
                               description: "Path to your symbols file",
                                  optional: false,
                                      type: String,
                             default_value: File.expand_path('.')),

          FastlaneCore::ConfigItem.new(key: :build_number,
                                  env_name: "IPA_BUILD_NUMBER",
                               description: "The build number for the ipa you want to download",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :osx].include?(platform)
      end
    end
  end
end
