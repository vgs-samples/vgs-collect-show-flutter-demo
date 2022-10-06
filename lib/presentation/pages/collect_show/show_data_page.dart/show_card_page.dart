import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_show_data.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/show_data_page.dart/show_card_data_controller.dart';
import 'package:vgs_collect_flutter_demo/presentation/widgets/loader_widget.dart';
import 'package:vgs_collect_flutter_demo/presentation/widgets/scrollable_text_widget.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';
import 'package:vgs_collect_flutter_demo/utils/snackbar_utils.dart';
import 'package:vgs_collect_flutter_demo/utils/string_utils.dart';

class ShowCardPage extends StatefulWidget {
  const ShowCardPage({Key? key}) : super(key: key);

  @override
  State<ShowCardPage> createState() => _ShowCardPageState();
}

class _ShowCardPageState extends State<ShowCardPage> {
  late ShowCardDataController _showController;

  bool _isLoading = false;
  bool _isRevealed = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectShowData>(
      builder: (context, cardShowData, child) {
        return Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _cardShowView(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (cardShowData.hasPayload) {
                            sendData(cardShowData.payload);
                          }
                        },
                        child: Text(
                          'REVEAL',
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
                          horizontal: 16, vertical: 8),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isRevealed
                            ? () async {
                                await _showController.copyCardNumber();
                                SnackBarUtils.showSnackBar(
                                  context,
                                  text: 'Card number was copied!',
                                  color: Colors.blue,
                                );
                              }
                            : null,
                        child: Text(
                          'COPY CARD',
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
                child: ScrollableText(
                    text: cardShowData.hasPayload
                        ? prettyJson(cardShowData.payload)
                        : 'No payload to reveal'),
              ),
            ]),
          ),
          _isLoading ? const SemitransparentLoader() : const SizedBox()
        ]);
      },
    );
  }

  Widget _cardShowNativeiOS() {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return Column(
      children: [
        SizedBox(
            height: 215.0,
            child: UiKitView(
              viewType: showCardDataViewType,
              onPlatformViewCreated: _createShowCardController,
              creationParams: creationParams,
              creationParamsCodec: StandardMessageCodec(),
            ))
      ],
    );
  }

  Widget _cardShowNativeAndroid() {
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return SizedBox(
      height: 215.0,
      child: AndroidView(
        viewType: showCardDataViewType,
        onPlatformViewCreated: _createShowCardController,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }

  Widget _cardShowView() {
    if (Platform.isAndroid) {
      return _cardShowNativeAndroid();
    } else if (Platform.isIOS) {
      return _cardShowNativeiOS();
    } else {
      throw Exception('Platform is not supported!');
    }
  }

  void _createShowCardController(int id) {
    print("View id = $id");
    _showController = ShowCardDataController(id);
    _showController.channel.setMethodCallHandler(invokedMethods);
    _showController.configureShow();
  }

  Future<dynamic> invokedMethods(MethodCall methodCall) async {
    var textToDisplay = '';
    final arguments = methodCall.arguments;
    switch (methodCall.method) {
      default:
        break;
    }
  }

  sendData(dynamic payload) async {
    setState(() {
      _isLoading = true;
    });
    final result = await _showController.revealData(
      payload,
      CollectShowConstants.revealPath,
    );
    var resultData = new Map<String, dynamic>.from(result);
    final resultStatus = resultData[EventPayloadNames.status];
    if (resultStatus == EventPayloadNames.success) {
      setState(() {
        _isLoading = false;
        _isRevealed = true;
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
        text: 'Failed to reveal data!',
        color: Colors.red,
      );
    }
  }
}
