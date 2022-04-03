import 'package:flutter/material.dart';

class FieldsListItem {
  final String key;
  final String value;

  FieldsListItem(this.key, this.value);
}

class FieldsList extends StatelessWidget {
  const FieldsList({
    Key? key,
    required this.items,
    required this.onItemTap,
  }) : super(key: key);

  final List<FieldsListItem> items;
  final Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          minLeadingWidth: 15,
          leading: Text(item.key),
          title: Text(item.value),
          onTap: () {
            onItemTap(index);
          },
        );
      },
      itemCount: items.length,
    );
  }
}
