import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_data_page/collect_data_controller.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_show_data.dart';
import 'package:vgs_collect_flutter_demo/presentation/widgets/loader_widget.dart';
import 'package:vgs_collect_flutter_demo/presentation/widgets/scrollable_text_widget.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';
import 'package:vgs_collect_flutter_demo/utils/snackbar_utils.dart';
import 'package:vgs_collect_flutter_demo/utils/string_utils.dart';

class CollectCardPage extends StatefulWidget {
  const CollectCardPage({Key? key}) : super(key: key);

  @override
  State<CollectCardPage> createState() => _CollectCardPageState();
}

class _CollectCardPageState extends State<CollectCardPage> {
  late CardDataController _collectController;

  String _outputText = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            _collectController.hideKeyboard();
          },
          child: Column(children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _cardCollectView(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValid = await _collectController.validateForm();
                        if (isValid == false) {
                          SnackBarUtils.showSnackBar(
                            context,
                            text: 'Form is invalid!',
                            color: Colors.red,
                          );
                        } else {
                          SnackBarUtils.showSnackBar(
                            context,
                            text: 'Form is is valid. Send data...',
                          );

                          await sendData();
                        }
                      },
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ScrollableText(text: _outputText),
            ),
          ]),
        ),
      ),
      _isLoading ? const SemitransparentLoader() : const SizedBox()
    ]);
  }

  Widget _cardCollectNativeiOS() {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return Column(children: [
      SizedBox(
          height: 215.0,
          child: UiKitView(
              viewType: collectDataViewType,
              onPlatformViewCreated: _createCardCollectController,
              creationParams: creationParams,
              creationParamsCodec: StandardMessageCodec()))
    ]);
  }

  void _createCardCollectController(int id) {
    _collectController = CardDataController(id);
    _collectController.channel.setMethodCallHandler(invokedMethods);
    _collectController.configureCollect();
    _collectController.showKeyboard();
  }

  Widget _cardCollectNativeAndroid() {
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return SizedBox(
      height: 215.0,
      child: AndroidView(
        viewType: collectDataViewType,
        onPlatformViewCreated: _createCardCollectController,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }

  Widget _cardCollectView() {
    if (Platform.isAndroid) {
      return _cardCollectNativeAndroid();
    } else if (Platform.isIOS) {
      return _cardCollectNativeiOS();
    } else {
      throw Exception('Platform is not supported!');
    }
  }

  Future<dynamic> invokedMethods(MethodCall methodCall) async {
    var textToDisplay = '';
    final arguments = methodCall.arguments;
    switch (methodCall.method) {
      case MethodNames.stateDidChange:
        if (arguments != null && arguments is Map<dynamic, dynamic>) {
          var eventData = new Map<String, dynamic>.from(arguments);
          final description =
              eventData[EventPayloadNames.stateDescription] as String;
          textToDisplay = description;
        }
        break;
      default:
        break;
    }

    setState(() {
      _outputText = textToDisplay;
    });
  }

  sendData() async {
    setState(() {
      _isLoading = true;
    });
    final result = await _collectController.sendData();
    var resultData = new Map<String, dynamic>.from(result);
    final resultStatus = resultData[EventPayloadNames.status];
    if (resultStatus == EventPayloadNames.success) {
      final data = resultData[EventPayloadNames.data] as Map<dynamic, dynamic>;
      final json = new Map<String, dynamic>.from(data);
      print('custom config json: ${json}');

      final payload = jsonDecode(json['data']);

      final payloadToReveal = {
        'payment_card_holder_name': payload['cardHolderName'],
        'payment_card_number': payload['cardNumber'],
        'payment_card_expiration_date': payload['expDate']
      };

      Provider.of<CollectShowData>(context, listen: false)
          .updatePayload(payloadToReveal);

      setState(() {
        _isLoading = false;
        _outputText = prettyJson(payload);
      });
      SnackBarUtils.showSnackBar(
        context,
        text: 'SUCCESS!',
        color: Colors.lightGreen,
      );
    } else if (resultStatus == EventPayloadNames.failed) {
      setState(() {
        _isLoading = false;
      });
      SnackBarUtils.showSnackBar(
        context,
        text: 'Failed!',
        color: Colors.red,
      );
    }
  }
}
