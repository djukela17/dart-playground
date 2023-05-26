import 'client.dart';
import 'config.dart';

class Service {
  Client? client;

  Service(Config config) {
    this.client = Client(config);
  }

  void setConfig(Config config) {
    this.client = Client(config);
  }

  Future<void> rerollAndKeep() async {
    if (client == null) {
      print('client is not initialized');

      return;
    }

    var currentChampionId = await client?.getCurrentChampionId();
    if (currentChampionId == null) {
      print('did not get current champion id');

      return;
    }

    await client?.rerollCurrentChampion();

    await client?.benchSwap(currentChampionId);
  }
}
