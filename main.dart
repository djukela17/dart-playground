import 'league/config.dart';
import 'league/service.dart';

void main() async {
  var config = await parseFromFile('lockfile');
  if (config == null) {
    return;
  }

  var leagueService = Service(config);

  await leagueService.rerollAndKeep();
}