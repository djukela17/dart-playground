import 'league/client.dart';
import 'league/config.dart';

void main() async {
  var config = await parseFromFile('lockfile');
  if (config == null) {
    return;
  }

  var leagueClient = Client(config);

  await run(leagueClient);

  leagueClient.close();
}

Future<void> run(Client leagueClient) async {
  var championId = await leagueClient.getChampSelectCurrentChampionId();
  if (championId == null) {
    print('not good champion id');

    return;
  }

  print('current champion id: $championId');
}
