import 'dart:io';

class Config {
  String scheme;
  String host = '127.0.0.1';
  int port;
  String username = 'riot';
  String password;

  Config(this.scheme, this.port, this.password);

  String get hostUri => '$scheme::/$host:$port';
}

Future<Config?> parseFromFile(String filepath) async {
  try {
    var contents = await File(filepath).readAsString();

    var parts = contents.split(':');

    if (parts.length != 5) {
      return null;
    }

    var scheme = parts[4];
    var port = int.parse(parts[2]);
    var password = parts[3];

    return Future(() => Config(scheme, port, password));
  } catch (e) {
    print('exception');
    print(e);

    return null;
  }
}
