# Common Wiki App

This is a common wiki app. It can be used on any sites based on MediaWiki (A software developed by Wikimedia Foundation), theoretically. The only thing you need to do is to set some parameters in the file /lib/settings/local_settings.dart, including
- wgSiteName
- wgScriptPath
- wgServer
- wgPreURL
- wgMainPageName
- wgTalkPageName
- wgResourceBasePath

These parameters you might find in `LocalSettings.php`.

But we strongly recommend you to modify the content below:

- app/src/main/AndroidManifest.xml:28 "wikiapp"
- ios/Runner/Info.plist:55 "wikiapp"
- "Map<String, String>? Function(dynamic) customStyleBuilder()" in local_settings.dart

If you want to make this app abled to login, you still need to set:

- Set up the MediaWiki OAuth2 App. The redirect URL is `wikiapp://OAuth`
- identifier, which means your OAuth2 consumer key

## TODOs
1. Test OAuth2
2. Fix the edit issue (Always prompt 301 on the site I test)
3. Muti-language Support (zh-Hans-only right now)
4. Support uploading files.

## One more thing

This is the very first app I created, so... Please more issues and prs <3