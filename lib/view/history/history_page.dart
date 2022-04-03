import 'package:command/logic/logic.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> items = OperationsManager().history;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          reverse: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }
}
