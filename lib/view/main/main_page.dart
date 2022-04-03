import 'dart:async';

import 'package:command/logic/logic.dart';
import 'package:command/models/field.dart';
import 'package:command/utils/map_utils.dart';
import 'package:command/view/history/history_page.dart';
import 'package:command/view/main/dialogs/dialogs.dart';
import 'package:command/view/main/main_fields_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ValueNotifier<bool> showLoader = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 60;
    final FieldModel fieldModel = Provider.of<FieldModel>(context);
    Timer(const Duration(seconds: 1), () {
      OperationsManager().execute(
        GetAllFieldsCommand(fieldModel, onSucces: (fields) {
          fieldModel.setFields(fields.dynamicToString());
          showLoader.value = true;
          showLoader.removeListener(() {});
        }),
      );
    });

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: appBarHeight,
          leading: SizedBox(
            width: appBarHeight,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HistoryPage()));
              },
              splashRadius: 25,
              icon: const Icon(Icons.history),
            ),
          ),
          actions: [
            SizedBox(
              width: appBarHeight,
              child: IconButton(
                onPressed: () {
                  OperationsManager().execute(
                    DeleteAllFieldsCommand(fieldModel),
                  );
                },
                splashRadius: 25,
                icon: const Icon(Icons.delete_rounded),
              ),
            )
          ],
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          alignment: Alignment.center,
          child: ValueListenableBuilder<bool>(
              valueListenable: showLoader,
              builder: (context, snapshot, _) {
                return snapshot
                    ? Consumer<FieldModel>(
                        builder: (context, model, widget) {
                          return FieldsList(
                            onItemTap: (index) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return FieldInfoDialog(
                                    field: model.fields[index],
                                  );
                                },
                              );
                            },
                            items: model.fields
                                .map((e) => FieldsListItem(e.key, e.value))
                                .toList(),
                          );
                        },
                      )
                    : const CircularProgressIndicator();
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const CreateFieldDialog();
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
