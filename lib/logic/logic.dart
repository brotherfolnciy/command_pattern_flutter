import 'package:command/models/field.dart';

import 'database.dart';

abstract class Reciever {
  Set<String> get actions;
}

abstract class Command {
  String name = '';

  Command();

  @override
  String toString() => name;

  void execute();
}

abstract class FieldModelCommand extends Command {
  FieldModelCommand(this.fieldModel);

  FieldModel fieldModel;
}

abstract class Invoker {
  List<String> history = [];
  void execute(Command command) {
    command.execute();
    history.add(command.toString());
  }

  @override
  String toString() => history.fold("", (events, event) => "$events$event\r\n");
}

class OperationsManager extends Invoker {
  static final OperationsManager _instance = OperationsManager._internal();

  factory OperationsManager() {
    return _instance;
  }

  OperationsManager._internal();
}

class DatabaseOperationsReciever implements Reciever {
  static void updateFieldsInFieldModel(FieldModel fieldModel) {
    getAllFields(onSucces: (data) {
      fieldModel.setFields(data);
    });
  }

  static void createField(
    String key,
    String value,
    FieldModel fieldModel, {
    Function()? onSucces,
    Function(String error)? onError,
  }) {
    Database.createField(
        key, value, onError != null ? onError('Key missed') : () {});
    onSucces != null ? onSucces() : () {};
    updateFieldsInFieldModel(fieldModel);
  }

  static void readField(
    String key,
    FieldModel fieldModel, {
    Function(String)? onSucces,
    Function(String error)? onError,
  }) {
    var value = Database.readField(key);
    if (value == null) {
      onError != null ? onError('Key missed') : () {};
    } else {
      onSucces != null ? onSucces(value) : () {};
    }
    updateFieldsInFieldModel(fieldModel);
  }

  static void updateField(
    String key,
    String value,
    FieldModel fieldModel, {
    Function()? onSucces,
    Function(String error)? onError,
  }) {
    Database.updateField(
        key, value, onError != null ? onError('Key missed') : () {});
    onSucces != null ? onSucces() : () {};
    updateFieldsInFieldModel(fieldModel);
  }

  static void deleteField(
    String key,
    FieldModel fieldModel, {
    Function()? onSucces,
    Function(String error)? onError,
  }) {
    Database.deleteField(key, onError != null ? onError('Key missed') : () {});
    onSucces != null ? onSucces() : () {};
    updateFieldsInFieldModel(fieldModel);
  }

  static void getAllFields({
    Function(Map<String, String>)? onSucces,
    Function(String error)? onError,
  }) {
    onSucces != null ? onSucces(Database.getAllFields()) : () {};
  }

  static void deleteAllField(
    FieldModel fieldModel, {
    Function()? onSucces,
    Function(String error)? onError,
  }) {
    Database.deleteAllFields();
    onSucces != null ? onSucces() : () {};
    updateFieldsInFieldModel(fieldModel);
  }

  static void containsKey(
    String key, {
    Function()? onSucces,
    Function(String error)? onError,
  }) {
    if (Database.containsKey(key)) {
      onSucces != null ? onSucces() : () {};
    } else {
      onError != null ? onError('Key missed') : () {};
    }
  }

  @override
  Set<String> get actions =>
      {"create field", "read field", "update field", "delete field"};
}

class CreateFieldCommand extends FieldModelCommand {
  @override
  String name = 'create field';
  String key;
  String value;
  Function()? onSucces;
  Function(String error)? onError;

  CreateFieldCommand(
    this.key,
    this.value,
    FieldModel fieldModel, {
    this.onSucces,
    this.onError,
  }) : super(fieldModel);
  @override
  void execute() {
    DatabaseOperationsReciever.createField(key, value, fieldModel,
        onSucces: onSucces, onError: onError);
  }
}

class ReadFieldCommand extends FieldModelCommand {
  @override
  String name = 'read field';
  String key;
  Function(String value)? onSucces;
  Function(String error)? onError;

  ReadFieldCommand(
    this.key,
    FieldModel fieldModel, {
    this.onSucces,
    this.onError,
  }) : super(fieldModel);
  @override
  void execute() {
    DatabaseOperationsReciever.readField(key, fieldModel,
        onSucces: onSucces, onError: onError);
  }
}

class UpdateFieldCommand extends FieldModelCommand {
  @override
  String name = 'update field';
  String key;
  String value;
  Function()? onSucces;
  Function(String error)? onError;

  UpdateFieldCommand(
    this.key,
    this.value,
    FieldModel fieldModel, {
    this.onSucces,
    this.onError,
  }) : super(fieldModel);
  @override
  void execute() {
    DatabaseOperationsReciever.updateField(key, value, fieldModel,
        onSucces: onSucces, onError: onError);
  }
}

class DeleteFieldCommand extends FieldModelCommand {
  @override
  String name = 'delete field';
  String key;
  Function()? onSucces;
  Function(String error)? onError;

  DeleteFieldCommand(
    this.key,
    FieldModel fieldModel, {
    this.onSucces,
    this.onError,
  }) : super(
          fieldModel,
        );
  @override
  void execute() {
    DatabaseOperationsReciever.deleteField(key, fieldModel,
        onSucces: onSucces, onError: onError);
  }
}

class GetAllFieldsCommand extends FieldModelCommand {
  @override
  String name = 'get all fields';
  Function(Map<dynamic, dynamic> error)? onSucces;
  Function(String error)? onError;

  GetAllFieldsCommand(
    FieldModel fieldModel, {
    this.onSucces,
    this.onError,
  }) : super(
          fieldModel,
        );
  @override
  void execute() {
    DatabaseOperationsReciever.getAllFields(
        onSucces: onSucces, onError: onError);
  }
}

class DeleteAllFieldsCommand extends FieldModelCommand {
  @override
  String name = 'delete all fields';
  Function()? onSucces;
  Function(String error)? onError;

  DeleteAllFieldsCommand(
    FieldModel fieldModel, {
    this.onSucces,
    this.onError,
  }) : super(
          fieldModel,
        );
  @override
  void execute() {
    DatabaseOperationsReciever.deleteAllField(fieldModel,
        onSucces: onSucces, onError: onError);
  }
}

class ContainsKeyCommand extends FieldModelCommand {
  @override
  String name = 'contains key';
  String key;
  Function()? onSucces;
  Function(String error)? onError;

  ContainsKeyCommand(
    FieldModel fieldModel,
    this.key, {
    this.onSucces,
    this.onError,
  }) : super(
          fieldModel,
        );
  @override
  void execute() {
    DatabaseOperationsReciever.containsKey(key,
        onSucces: onSucces, onError: onError);
  }
}
