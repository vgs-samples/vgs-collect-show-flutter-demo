import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';

const customCardDataCollectViewType = 'card-collect-form-view';

class CustomCardDataController {
  CustomCardDataController(int id)
      : channel = MethodChannel('$customCardDataCollectViewType/$id');

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

  Future<Map<dynamic, dynamic>> presentMicroBlink() async {
    var licenceKey = '';
    if (Platform.isIOS) {
      licenceKey = CollectShowConstants.microBlinkiOSLicenceKey;
    } else if (Platform.isAndroid) {
      licenceKey = CollectShowConstants.microBlinkAndroidLicenceKey;
    }
    return await channel.invokeMethod(MethodNames.presentMicroBlink, {
      'licenceKey': licenceKey,
    });
  }

  Future<void> showKeyboard() async {
    return await channel.invokeMethod(MethodNames.showKeyboard);
  }

  Future<void> hideKeyboard() async {
    return await channel.invokeMethod(MethodNames.hideKeyboard);
  }

  Future<Map<dynamic, dynamic>> sendData(Map<String, String> map) async {
    return await channel.invokeMethod(MethodNames.redactCard, map);
  }
}
