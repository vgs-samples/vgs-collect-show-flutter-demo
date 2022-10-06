import 'package:flutter/material.dart';

class CollectShowData extends ChangeNotifier {
  dynamic _payload;

  dynamic get payload => _payload;

  dynamic get hasPayload => payload != null;

  updatePayload(dynamic newPayload) {
    _payload = newPayload;
    notifyListeners();
  }

  clearPayload() {
    _payload = null;
    notifyListeners();
  }
}
