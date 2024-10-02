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
  static const String startCardScanner = 'startCardScanner';
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
  static const vaultID = 'tnthu5yiznd';
  static const environment = 'sandbox';
  static const revealPath = 'post';
  static const microBlinkiOSLicenceKey = 'ios_licence_key';
  static const microBlinkAndroidLicenceKey = 'sRwCAC1jb20udmVyeWdvb2RzZWN1cml0eS52Z3NfY29sbGVjdF9mbHV0dGVyX2RlbW8AbGV5SkRjbVZoZEdWa1QyNGlPakUzTWpjNE9EUTNOVEUyTkRrc0lrTnlaV0YwWldSR2IzSWlPaUl6TUdRMk5qTmtNaTA1WVROaExUUTNZalV0WW1VeE55MHdORFU1TURnMk5URmtOMlFpZlE9PY4uBK1pKGt56C/vrjJ+z2CEUjaE1tbw4n8N4BgSxo55AyE6oSxSmtvVhXKLhVCcPHuoQJG1843VSw3IsxKQGHjTfu6nVo8hEKgZg2QC45+SOSezfq9T0xxJTIMDBQ==';

  static bool hasMicroBlinkLicenceKey() {
    if (Platform.isIOS) {
      return true;
    } else if (Platform.isAndroid) {
      return microBlinkAndroidLicenceKey != 'android_licence_key';
    } else {
      throw Exception('Platform is not supported!');
    }
  }
}
