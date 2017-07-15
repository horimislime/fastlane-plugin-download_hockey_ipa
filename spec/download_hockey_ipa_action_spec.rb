describe Fastlane::Actions::DownloadHockeyIpaAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The download_hockey_ipa plugin is working!")

      Fastlane::Actions::DownloadHockeyIpaAction.run(nil)
    end
  end
end
