// ignore_for_file: prefer_null_aware_operators

import 'package:todo/utils/global.dart' as global;

class TodoModel {
  int? id;
  int? minute;
  int? second;
  String? title;
  String? description;
  String? status;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  TodoModel({
    this.id,
    required this.minute,
    required this.second,
    required this.title,
    required this.description,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  ////!SECTION fromJson  Function: get Response From Backend side
  TodoModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      minute = json["minute"];
      second = json["second"];
      title = json["title"];
      description = json["description"];
      status = json["status"];
      createdAt = json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now();
      updatedAt = json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now();
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "todo_model.dart",
        functionNameWithoutBraces: "TodoModel.fromJson",
        e: e,
      );
    }
  }

  ////!SECTION toJson Function: send Response from App side to Backend
  Map<String, dynamic> toJson() => {
    "id": id,
    "minute": minute,
    "second": second,
    "title": title,
    "description": description,
    "status": status,
    "createdAt": createdAt != null ? createdAt!.toIso8601String() : DateTime.now(),
    "updatedAt": updatedAt != null ? updatedAt!.toIso8601String() : DateTime.now(),
  };
}
