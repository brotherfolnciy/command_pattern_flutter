import 'package:command/logic/database.dart';
import 'package:command/models/field.dart';
import 'package:command/utils/path_provider.dart';
import 'package:command/view/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  final FieldModel fieldModel = FieldModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Path().getPath(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<void>(
            future: Database.init(snapshot.data!),
            builder: (context, snapshot) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(
                    value: fieldModel,
                  ),
                ],
                child: const MaterialApp(
                  home: MainPage(),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
