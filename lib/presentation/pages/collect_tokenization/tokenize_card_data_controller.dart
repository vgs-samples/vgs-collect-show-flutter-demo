import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';

const tokenizeCardDataCollectViewType = 'tokenize-card-collect-form-view';

class TokenizeCardDataController {
  TokenizeCardDataController(int id)
      : channel = MethodChannel('$tokenizeCardDataCollectViewType/$id');

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

  Future<void> startCardScanner() async {
    var licenceKey = '';
    if (Platform.isIOS) {
      licenceKey = CollectShowConstants.microBlinkiOSLicenceKey;
    } else if (Platform.isAndroid) {
      licenceKey = CollectShowConstants.microBlinkAndroidLicenceKey;
    }
    return await channel.invokeMethod(MethodNames.startCardScanner, {
      'licenceKey': licenceKey,
    });
  }

  Future<void> showKeyboard() async {
    return await channel.invokeMethod(MethodNames.showKeyboard);
  }

  Future<void> hideKeyboard() async {
    return await channel.invokeMethod(MethodNames.hideKeyboard);
  }

  Future<Map<dynamic, dynamic>> tokenizeData() async {
    return await channel.invokeMethod(MethodNames.tokenizeCard);
  }
}
