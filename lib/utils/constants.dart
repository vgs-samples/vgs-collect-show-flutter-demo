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
}

class CollectShowConstants {
  static const vaultID = 'vault_id';
  static const environment = 'sandbox';
  static const customHostname = 'customHostname';
  static const revealPath = 'post';
}
