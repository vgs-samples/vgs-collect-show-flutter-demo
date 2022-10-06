import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_data_page/collect_card_page.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/collect_show_data.dart';
import 'package:vgs_collect_flutter_demo/presentation/pages/collect_show/show_data_page.dart/show_card_page.dart';

class CollectShowTabPage extends StatefulWidget {
  const CollectShowTabPage({Key? key}) : super(key: key);

  @override
  State<CollectShowTabPage> createState() => _CollectShowTabPageState();
}

class _CollectShowTabPageState extends State<CollectShowTabPage> {
  final _pages = [ShowCardPage(), CollectCardPage()];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CollectShowData>(context, listen: false).clearPayload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VGSShow & VGSCollect')),
      body: _pages.elementAt(_selectedIndex), //New
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.credit_card,
            ),
            label: 'Show',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.save,
            ),
            label: 'Collect',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
