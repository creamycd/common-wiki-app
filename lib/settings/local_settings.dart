import 'dart:io';

const wgSiteName = "";
const wgScriptPath = "/";
const wgServer = "";
const wgPreURL = "";
const wgMainPageName = "";
const wgResourceBasePath = "";
const wgTalkPageName = "";
const identifier = "";
Map<String, String>? Function(dynamic) customStyleBuilder() {
  List displayNone = ['mainpage-top-menu', 'mainpage-header', 'sidebar', 'toc', 'mw-editsection'];
  List sansFont = ['h2', 'h3', 'h4', 'h5', 'h6'];
  return (element) {
      if (displayNone.any(element.classes.contains)) {
        return {'display': 'none'};
      }
      if (element.classes.contains('mw-parser-output')) {
        return {'font-family': 'Noto Serif SC'};
      }
      if (element.classes.contains('hatnote')) {
        return {'margin': '1em', 'border': '1px grey solid', 'padding': '0.5em', 'border-radius': '0.5em'};
      }
      if (sansFont.contains(element.localName)) {
        return {'font-family': 'Noto Sans SC !important'};
      }
      if (element.localName == 'figure') {
        return {'max-width': '92.5%', 'box-sizing': 'border-box', 'border': '0', 'margin': '0 auto', 'background-color': 'transparent'};
      }
      return null;
    };
}

// Please DO NOT midify the content below
var PageName = wgMainPageName;
const fullServerName = "$wgPreURL$wgServer";
const serverScriptPath = "$fullServerName$wgScriptPath/api.php";
articleURLContent(pageName) {
var articleURL = Uri(
    scheme: 'https',
    host: fullServerName,
    path: '${wgScriptPath}api.php',
    queryParameters: {
      'action': 'parse',
      'redirects': 'true',
      'format': 'json',
      'page': pageName,
    });
return articleURL;
}

articleURLWikitext(pageName) {
  var articleURL = Uri(
      scheme: 'https',
      host: fullServerName,
      path: '${wgScriptPath}api.php',
      queryParameters: {
        'action': 'parse',
        'redirects': 'true',
        'format': 'json',
        'prop': 'wikitext',
        'page': pageName,
      });
  return articleURL;
}

final authorizationEndpoint =
Uri.parse('http://www.qiuwenbaike.cn/wiki/Special:OAuth/authorize');
final tokenEndpoint = Uri.parse('$fullServerName$wgResourceBasePath/Special:OAuth/token');
final redirectUrl = Uri.parse('wikiapp://OAuth');
final credentialsFile = File('~/.myapp/credentials.json');

var requestURL = articleURLContent(wgMainPageName);