import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/custom_card_data/custom_card_data_controller.dart';
import 'package:vgs_collect_flutter_demo/presentation/widgets/loader_widget.dart';
import 'package:vgs_collect_flutter_demo/presentation/widgets/scrollable_text_widget.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';
import 'package:vgs_collect_flutter_demo/utils/snackbar_utils.dart';
import 'package:vgs_collect_flutter_demo/utils/string_utils.dart';

class CustomCardDataPage extends StatefulWidget {
  const CustomCardDataPage({Key? key}) : super(key: key);

  @override
  State<CustomCardDataPage> createState() => _CustomCardDataPageState();
}

class _CustomCardDataPageState extends State<CustomCardDataPage> {
  late CustomCardDataController _collectController;

  String _outputText = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Custom card data',
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                _collectController.hideKeyboard();
              },
              child: Column(children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _cardCollectView(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final isValid =
                                await _collectController.validateForm();
                            if (isValid == false) {
                              SnackBarUtils.showSnackBar(
                                context,
                                text: 'Formis invalid!',
                                color: Colors.red,
                              );
                            } else {
                              SnackBarUtils.showSnackBar(
                                context,
                                text: 'Formis is valid. Send data...',
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
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (CollectShowConstants
                                .hasMicroBlinkLicenceKey()) {
                              // MicroBlink initializer can produce errors.
                              var result =
                                  await _collectController.presentMicroBlink();
                              var resultData =
                                  new Map<String, dynamic>.from(result);
                              if (resultData[
                                      EventPayloadNames.microBlinkErrorCode] !=
                                  null) {
                                print('MicroBlink error!');
                                print(resultData[
                                    EventPayloadNames.microBlinkErrorCode]);

                                SnackBarUtils.showSnackBar(
                                  context,
                                  text:
                                      'Cannot init MicroBlink with ${resultData[EventPayloadNames.microBlinkErrorCode]} error',
                                  color: Colors.red,
                                );
                              }
                            } else {
                              SnackBarUtils.showSnackBar(
                                context,
                                text:
                                    'Please set MicroBlink licence key to constants.dart',
                                color: Colors.red,
                              );
                            }
                          },
                          icon: Icon(Icons.photo_camera),
                          label: Text(
                            'MicroBlink',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ScrollableText(text: _outputText),
                ),
              ]),
            ),
          ),
          _isLoading ? const SemitransparentLoader() : const SizedBox()
        ]),
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

  Widget _cardCollectNativeiOS() {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return Column(children: [
      SizedBox(
          height: 290.0,
          child: UiKitView(
              viewType: customCardDataCollectViewType,
              onPlatformViewCreated: _createCardCollectController,
              creationParams: creationParams,
              creationParamsCodec: StandardMessageCodec()))
    ]);
  }

  Widget _cardCollectNativeAndroid() {
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return SizedBox(
      height: 300,
      child: AndroidView(
        viewType: customCardDataCollectViewType,
        onPlatformViewCreated: _createCardCollectController,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }

  void _createCardCollectController(int id) {
    _collectController = CustomCardDataController(id);
    _collectController.channel.setMethodCallHandler(invokedMethods);
    _collectController.configureCollect();
    _collectController.showKeyboard();
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
      case MethodNames.userDidCancelScan:
        textToDisplay = 'User did cancel scan';
        SnackBarUtils.showSnackBar(
          context,
          text: textToDisplay,
        );
        break;
      case MethodNames.userDidFinishScan:
        textToDisplay = 'User did finish scan';
        SnackBarUtils.showSnackBar(
          context,
          text: textToDisplay,
          color: Colors.lightGreen,
        );
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
    final result = await _collectController.sendData({
      'custom_header': "header",
    });
    var resultData = new Map<String, dynamic>.from(result);
    final resultStatus = resultData[EventPayloadNames.status];
    if (resultStatus == EventPayloadNames.success) {
      final data = resultData[EventPayloadNames.data] as Map<dynamic, dynamic>;
      final json = new Map<String, dynamic>.from(data);
      print('custom config json: ${json}');

      setState(() {
        _isLoading = false;
        _outputText = prettyJson(json);
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
