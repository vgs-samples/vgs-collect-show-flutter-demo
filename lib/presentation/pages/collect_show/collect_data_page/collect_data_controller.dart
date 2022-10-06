import 'package:flutter/services.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';

const collectDataViewType = 'card-collect-for-show-form-view';

class CardDataController {
  CardDataController(int id)
      : channel = MethodChannel('$collectDataViewType/$id');

  final MethodChannel channel;

  Future<void> configureCollect() async {
    return await channel.invokeMethod(MethodNames.configureCollect, {
      'vault_id': CollectShowConstants.vaultID,
      'environment': CollectShowConstants.environment
    });
  }

  Future<bool> validateForm() async {
    return await channel.invokeMethod(MethodNames.isFormValid);
  }

  Future<void> showKeyboard() async {
    return await channel.invokeMethod(MethodNames.showKeyboard);
  }

  Future<void> hideKeyboard() async {
    return await channel.invokeMethod(MethodNames.hideKeyboard);
  }

  Future<Map<dynamic, dynamic>> sendData() async {
    return await channel.invokeMethod(MethodNames.redactCard);
  }
}
