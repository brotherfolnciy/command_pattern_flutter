import 'package:command/logic/logic.dart';
import 'package:command/models/field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateFieldDialog extends StatefulWidget {
  const CreateFieldDialog({Key? key}) : super(key: key);

  @override
  State<CreateFieldDialog> createState() => _CreateFieldDialogState();
}

class _CreateFieldDialogState extends State<CreateFieldDialog> {
  String errorText = '';
  String keyInput = '';
  String valueInput = '';

  FieldModel? fieldModel;

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
            validation = false;
            errorText = 'Key already exist';
          },
          onError: (error) {
            validation = true;
          },
        ),
      );
    } else {
      setState(() {
        errorText = 'Fill all fields';
      });
    }
    return validation;
  }

  void createField(BuildContext context) {
    OperationsManager().execute(
      CreateFieldCommand(
        keyInput,
        valueInput,
        fieldModel!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          onChanged: (value) {
                            keyInput = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Field name',
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
                          onChanged: (value) {
                            valueInput = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Field value',
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
                            createField(context);
                            Navigator.pop(context);
                          }
                        },
                        color: Colors.blue,
                        child: const Text(
                          'Create field',
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
