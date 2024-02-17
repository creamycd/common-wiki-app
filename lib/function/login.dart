import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiki/oauth2/oauth2.dart' as oauth2;
import 'package:wiki/settings/local_settings.dart';



Future<void> openInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Uri> listenForRedirect(Uri redirectUrl) async {
  final server = await HttpServer.bind(redirectUrl.host, redirectUrl.port);
  print('Listening for the authorization response on ${server.address}...');

  Completer<Uri> completer = Completer();
  server.listen((HttpRequest request) async {
    final responseUrl = request.requestedUri;
    await server.close();

    completer.complete(responseUrl);
  });

  return completer.future;
}

// Future<oauth2.Client?> createClient() async {
//   var exists = await credentialsFile.exists();
//
//   if (exists) {
//     var credentials =
//     oauth2.Credentials.fromJson(await credentialsFile.readAsString());
//     return oauth2.Client(credentials, identifier: identifier, secret: secret);
//   } else {
//     return null;
//   }
// }

void getToken() async {
  var grant = oauth2.AuthorizationCodeGrant(
      identifier, authorizationEndpoint, tokenEndpoint,
      secret: secret);

  var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

  await openInBrowser(authorizationUrl.toString());

  var responseUrl = await listenForRedirect(redirectUrl);

  // Once the user is redirected to `redirectUrl`, pass the query parameters to
  // the AuthorizationCodeGrant.
  final authResult = await grant.handleAuthorizationResponse(responseUrl.queryParameters);
  // Save the credentials to a file.
  await credentialsFile.writeAsString(authResult.credentials.toString());
}
