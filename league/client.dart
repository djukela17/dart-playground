import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

import 'config.dart';
import 'package:http/http.dart' as http;

class Client {
  Config config;
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

  Client(this.config);

  Future<void> getCurrentSummoner() async {
    var uri = _formatUri('lol-summoner/v1/current-summoner');

    http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${_auth()}',
      },
    );

    var req = await httpClient.getUrl(uri);
    req.headers.contentType = ContentType.json;
    req.headers.set('Authorization', 'Basic ${_auth()}');

    print(req.headers);

    var res = await req.close();

    if (res.statusCode < 200 || res.statusCode > 299) {
      print('bad response');
      print(res.statusCode);
    }

    await for (var contents in res.transform(Utf8Decoder())) {
      print(contents);
    }
  }

  Future<int?> getCurrentChampionId() async {
    var uri = _formatUri('lol-champ-select/v1/current-champion');

    var req = await httpClient.getUrl(uri);
    req.headers.contentType = ContentType.json;
    req.headers.set('Authorization', 'Basic: ${_auth()}');

    var res = await req.close();

    if (res.statusCode < 200 || res.statusCode > 299) {
      return null;
    }

    int? champtionid;

    await for (var contents in res.transform(Utf8Decoder())) {
      print(contents);

      champtionid = int.tryParse(contents);
    }

    return Future(() => champtionid);
  }

  Future<void> rerollCurrentChampion() async {
    var req =
        await _createRequest('lol-champ-select/v1/session/my-selection/reroll');

    var res = await req.close();

    if (res.statusCode < 200 || res.statusCode > 299) {
      print('bad response');
      return;
    }
  }

  Future<void> benchSwap(int championId) async {
    var req = await _createRequest(
        'lol-champ-select/v1/session/bench/swap/$championId');

    var res = await req.close();

    if (res.statusCode < 200 || res.statusCode > 299) {
      print('bad response');

      return;
    }
  }

  Future<void> setChallengeTokens() async {
    var body = '{"challengeIds":[]}';
    // var req = await _createPostRequest(
    //     'lol-challenges/v1/update-player-preferences/', body);
    //
    // var res = await req.close();

    var c = IOClient(httpClient);

    var r = await c.post(
        Uri(
          scheme: config.scheme,
          host: config.host,
          port: config.port,
          path: 'lol-challenges/v1/update-player-preferences/',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${_auth()}',
        },
        body: utf8.encode(body));

    print(r.statusCode);
    print(r.body);

    //
    // if (res.statusCode < 200 || res.statusCode > 299) {
    //   print('bad response');
    //   print(res.statusCode);
    //
    //   var body = await res.transform(Utf8Decoder()).join();
    //   print(body);
    //
    //   // await for (var contents in res.transform(Utf8Decoder())) {
    //   //   print('foo');
    //   //
    //   //   print(contents);
    //   // }
    //
    //   print('here');
    //
    //   return;
    // }
    //
    // print("set challenge tokens success");
  }

  void close() {
    httpClient.close();
  }

  Future<HttpClientRequest> _createRequest(String path) async {
    var uri = _formatUri(path);

    var req = await httpClient.getUrl(uri);
    req.headers.set('Authorization', 'Basic: ${_auth()}');
    req.headers.contentType = ContentType.json;

    return Future(() => req);
  }

  Future<HttpClientRequest> _createPostRequest(String path, String body) async {
    var uri = _formatUri(path);

    var req = await httpClient.postUrl(uri);
    req.headers.set('Authorization', 'Basic: ${_auth()}');
    req.headers.contentType = ContentType.json;
    req.headers.contentLength = body.length;

    req.write(body);

    return Future(() => req);
  }

  Uri _formatUri(String path) {
    return Uri(
      scheme: config.scheme,
      host: config.host,
      port: config.port,
      path: path,
    );
  }

  String _auth() {
    return base64Encode(utf8.encode('${config.username}:${config.password}'));
  }
}

class Champion {
  String name;
  int id;

  Champion(this.name, this.id);
}
