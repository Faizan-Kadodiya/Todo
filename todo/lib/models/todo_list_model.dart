// ignore_for_file: prefer_null_aware_operators

import 'package:todo/models/todo_model.dart';
import 'package:todo/utils/global.dart' as global;

class TodoListModel {
  List<TodoModel>? allTodoList = [];
  List<TodoModel>? createdTodoList = [];
  List<TodoModel>? inProgressTodoList = [];
  List<TodoModel>? completedTodoList = [];

  TodoListModel({
    required this.allTodoList,
    required this.createdTodoList,
    required this.inProgressTodoList,
    required this.completedTodoList,
  });

  ////!SECTION fromJson  Function: get Response From Backend side
  TodoListModel.fromJson(Map<String, dynamic> json) {
    try {
      allTodoList = json['allTodoList'] != null
          ? List<TodoModel>.from(
              (json['allTodoList']).map((p) => TodoModel.fromJson(p)),
            )
          : [];
      createdTodoList = json['createdTodoList'] != null
          ? List<TodoModel>.from(
              (json['createdTodoList']).map((p) => TodoModel.fromJson(p)),
            )
          : [];
      inProgressTodoList = json['inProgressTodoList'] != null
          ? List<TodoModel>.from(
              (json['inProgressTodoList']).map((p) => TodoModel.fromJson(p)),
            )
          : [];
      completedTodoList = json['completedTodoList'] != null
          ? List<TodoModel>.from(
              (json['completedTodoList']).map((p) => TodoModel.fromJson(p)),
            )
          : [];
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
    "allTodoList": allTodoList != null
        ? allTodoList?.map((e) => e.toJson()).toList()
        : null,
    "createdTodoList": createdTodoList != null
        ? createdTodoList?.map((e) => e.toJson()).toList()
        : null,
    "inProgressTodoList": inProgressTodoList != null
        ? inProgressTodoList?.map((e) => e.toJson()).toList()
        : null,
    "completedTodoList": completedTodoList != null
        ? completedTodoList?.map((e) => e.toJson()).toList()
        : null,
  };
}
