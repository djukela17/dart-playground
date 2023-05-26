import 'dart:convert';
import 'dart:io';

import 'config.dart';

class Client {
  Config config;
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

  Client(this.config);

  void getCurrentSummoner() async {
    var uri = _formatUri('lol-summoner/v1/get-current-summoner');

    var req = await httpClient.getUrl(uri);
    req.headers.contentType = ContentType.json;
    req.headers.set('Authorization', 'Basic: ${_auth()}');

    var res = await req.close();

    if (res.statusCode < 200 || res.statusCode > 299) {
      return;
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

    return;
  }

  void close() {
    httpClient.close();
  }

  Future<HttpClientRequest> _createRequest(String path) async {
    var uri = _formatUri(path);

    var req = await httpClient.getUrl(uri);
    req.headers.contentType = ContentType.json;
    req.headers.set('Authorization', 'Basic: ${_auth()}');

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
