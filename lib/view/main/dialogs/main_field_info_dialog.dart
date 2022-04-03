import 'package:command/logic/logic.dart';
import 'package:command/models/field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FieldInfoDialog extends StatefulWidget {
  const FieldInfoDialog({Key? key, required this.field}) : super(key: key);

  final Field field;

  @override
  State<FieldInfoDialog> createState() => _FieldInfoDialogState();
}

class _FieldInfoDialogState extends State<FieldInfoDialog> {
  String errorText = '';
  String keyInput = '';
  String valueInput = '';

  FieldModel? fieldModel;

  TextEditingController controller = TextEditingController();

  bool alreadyShow = false;

  @override
  void initState() {
    super.initState();
  }

  bool validation() {
    bool validation = false;
    if (keyInput.isNotEmpty && valueInput.isNotEmpty) {
      OperationsManager().execute(
        ContainsKeyCommand(
          fieldModel!,
          keyInput,
          onSucces: () {
            validation = true;
          },
          onError: (error) {
            validation = false;
          },
        ),
      );
    }
    return validation;
  }

  void saveField(BuildContext context) {
    OperationsManager().execute(
      UpdateFieldCommand(
        keyInput,
        valueInput,
        fieldModel!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!alreadyShow) {
      keyInput = widget.field.key;
      valueInput = widget.field.value;
      controller.text = valueInput;
      controller.notifyListeners();
      alreadyShow = true;
    }
    final Size size = MediaQuery.of(context).size;
    fieldModel ??= Provider.of<FieldModel>(context);
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 250,
          width: size.width * 0.8,
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            enabled: false,
                            labelText: keyInput,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: controller,
                          onChanged: (value) {
                            valueInput = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: Text(
                          errorText,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          if (validation()) {
                            saveField(context);
                            Navigator.pop(context);
                            alreadyShow = false;
                          } else {
                            setState(() {
                              errorText = 'Key is not exist';
                            });
                          }
                        },
                        color: Colors.blue,
                        child: const Text(
                          'Save field',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
