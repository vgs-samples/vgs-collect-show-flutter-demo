import 'dart:io' show Platform;

class RouteNames {
  static const String tokenizeCardData = 'collect_tokenize_card_data';
  static const String customCardData = 'collect_custom_card_data';
  static const String collectShowCardData = 'collect_show_custom_card_data';
}

class MethodNames {
  static const String configureCollect = 'configureCollect';
  static const String configureShow = 'configureShow';
  static const String redactCard = 'redactCard';
  static const String revealCard = 'revealCard';
  static const String tokenizeCard = 'tokenizeCard';
  static const String copyCard = 'copyCard';
  static const String isFormValid = 'isFormValid';
  static const String presentCardIO = 'presentCardIO';
  static const String presentMicroBlink = 'presentMicroBlink';
  static const String showKeyboard = 'showKeyboard';
  static const String hideKeyboard = 'hideKeyboard';
  static const String stateDidChange = 'stateDidChange';
  static const String userDidCancelScan = 'userDidCancelScan';
  static const String userDidFinishScan = 'userDidFinishScan';
}

class EventPayloadNames {
  static const String status = 'STATUS';
  static const String success = 'SUCCESS';
  static const String failed = 'FAILED';
  static const String data = 'DATA';
  static const String stateDescription = 'STATE_DESCRIPTION';
  static const String microBlinkErrorCode = 'MicroBlinkErrorCode';
}

class CollectShowConstants {
  static const vaultID = 'vault_id';
  static const environment = 'sandbox';
  static const revealPath = 'post';
  static const microBlinkiOSLicenceKey = 'ios_licence_key';
  static const microBlinkAndroidLicenceKey = 'android_licence_key';

  static bool hasMicroBlinkLicenceKey() {
    if (Platform.isIOS) {
      return microBlinkiOSLicenceKey != 'ios_licence_key';
    } else if (Platform.isAndroid) {
      return microBlinkAndroidLicenceKey != 'android_licence_key';
    } else {
      throw Exception('Platform is not supported!');
    }
  }
}
