import 'package:flutter/material.dart';

import 'package:vgs_collect_flutter_demo/presentation/widgets/collect_use_case_widget_item.dart';
import '../../utils/constants.dart';

class CollectUseCasesList extends StatelessWidget {
  const CollectUseCasesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('VGS Collect'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.tokenizeCardData);
                },
                child: CollectUseCaseItem(
                  title: 'Tokenize Card Data',
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.customCardData);
                },
                child: CollectUseCaseItem(
                  title: 'Collect custom card data',
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.collectShowCardData);
                },
                child: CollectUseCaseItem(
                  title: 'Reveal card data with VGSShow',
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.tokenizeCardData);
                },
                child: CollectUseCaseItem(
                  title: 'Tokenize Card Data',
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
