import 'package:flutter/services.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';

const showCardDataViewType = 'show-card-form-view';

class ShowCardDataController {
  ShowCardDataController(int id)
      : channel = MethodChannel('$showCardDataViewType/$id');

  final MethodChannel channel;

  Future<void> configureShow() async {
    return await channel.invokeMethod(MethodNames.configureShow, {
      'vault_id': CollectShowConstants.vaultID,
      'environment': CollectShowConstants.environment
    });
  }

  Future<Map<dynamic, dynamic>> revealData(dynamic payload, String path) async {
    return await channel.invokeMethod(
        MethodNames.revealCard, {'payload': payload, 'path': path});
  }

  Future<void> copyCardNumber() async {
    return await channel.invokeMethod(MethodNames.copyCard);
  }
}
