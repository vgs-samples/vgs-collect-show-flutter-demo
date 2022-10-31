import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_show_tab_page.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_show_data.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_tokenization/collect_tokenization_page.dart';

import 'package:vgs_collect_flutter_demo/presentation/pages/collect_use_cases_list.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/custom_card_data/custom_card_data.dart';
import 'package:vgs_collect_flutter_demo/utils/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CollectShowData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CollectUseCasesList(),
      routes: {
        RouteNames.customCardData: (context) => CustomCardDataPage(),
        RouteNames.collectShowCardData: (context) => CollectShowTabPage(),
        RouteNames.tokenizeCardData: ((context) => CollectTokenizeCardPage())
      },
    );
  }
}
