# download_hockey_ipa plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-download_hockey_ipa)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-download_hockey_ipa`, add it to your project by running:

```bash
fastlane add_plugin download_hockey_ipa
```

## About download_hockey_ipa

This plugin helps downloading yourapp.ipa from HockeyApp.  
Prepare your API token before using this plugin (see [API: Basics and Authentication / Public API / Knowledge Base - HockeyApp Support](https://support.hockeyapp.net/kb/api/api-basics-and-authentication#authentication)).

## Example

Assuming that the URL of application that you want download is rink.hockeyapp.net/manage/apps/1234abcd/app_versions/8899,

you can download ipa file of the app by passing parameters like below.

```
download_hockey_ipa(
  api_token: your_api_token,
  app_id: "1234abcd",
  app_build_id: "8899",
  ipa_file_path: "/Users/yourname/Desktop/yourapp.ipa"
)
```

The ipa file is saved to specified location.

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
