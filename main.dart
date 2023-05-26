import 'league/client.dart';
import 'league/config.dart';
import 'league/service.dart';

void main() async {
  var lockfilePath = '/Applications/League of Legends.app/Contents/LoL/lockfile';

  var config = await parseFromFile(lockfilePath);
  if (config == null) {
    return;
  }

  var leagueService = Service(config);

  // await leagueService.rerollAndKeep();

  await leagueService.clearChallengeTokens();
}