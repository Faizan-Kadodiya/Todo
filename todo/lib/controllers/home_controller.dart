import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:todo/constants/color_constant.dart';
import 'package:todo/constants/space_constant.dart';
import 'package:todo/models/todo_list_model.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/services/api_helper.dart';
import 'package:todo/utils/global.dart' as global;
import 'package:todo/widgets/common_textfield_widget.dart';
import 'package:todo/widgets/main_body_padding.dart';

class HomeController extends FullLifeCycleController
    with FullLifeCycleMixin, GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late TabController tabController;

  RxInt minute = 3.obs;
  RxInt second = 0.obs;

  // Maps to store independent timers for each todo
  Map<int, Timer> todoTimers = {};
  Map<int, int> remainingSeconds = {};

  TodoModel? editingTodo;

  TodoListModel todoListModel = TodoListModel(
    allTodoList: [],
    createdTodoList: [],
    inProgressTodoList: [],
    completedTodoList: [],
  );

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    //get all todo list from local database and assign to todoList variable
    fetchTodos();
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    descriptionController.dispose();
    searchController.dispose();
  }

  @override
  void onResumed() {
    log("App Comes From Background to Foreground");
    //Resume Timer if it was running before going to background
  }

  @override
  void onPaused() {
    // Cancel all running timers when app goes to background
    for (var timer in todoTimers.values) {
      timer.cancel();
    }
    log("App Goes to Background");
  }

  @override
  void onDetached() {
    // Cancel all running timers when app is killed
    for (var timer in todoTimers.values) {
      timer.cancel();
    }
    log("App has been killed");
  }

  @override
  void onInactive() {
    // Cancel all running timers when app is inactive
    for (var timer in todoTimers.values) {
      timer.cancel();
    }
    log(
      "App is temporarily inactive, not receiving user input, and not running in the foreground",
    );
  }

  @override
  void onHidden() {
    // Cancel all running timers when app is hidden
    for (var timer in todoTimers.values) {
      timer.cancel();
    }
    log("App is in background but not killed");
  }

  Future<void> fetchTodos() async {
    try {
      final result = await APIHelper.instance.getAllTodos();
      if (result.status == "success") {
        final list = result.recordList ?? [];
        todoListModel.allTodoList = list;
        todoListModel.createdTodoList = list
            .where((t) => t.status == "created")
            .toList();
        todoListModel.inProgressTodoList = list
            .where((t) => t.status == "inprogress")
            .toList();
        todoListModel.completedTodoList = list
            .where((t) => t.status == "completed")
            .toList();
      } else {
        if (result.isDisplayMessage == true) {
          global.showSnackBar(
            "Error",
            result.message ?? "Unable to load todos",
          );
        }
      }
      update();
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "fetchTodos",
        e: e,
      );
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      final res = await APIHelper.instance.insertTodo(todo);
      if (res.status == "success") {
        await fetchTodos();
      } else {
        if (res.isDisplayMessage == true) {
          global.showSnackBar("Error", res.message ?? "Failed to add todo");
        }
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "addTodo",
        e: e,
      );
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      final res = await APIHelper.instance.updateTodo(todo);
      if (res.status == "success") {
        await fetchTodos();
      } else {
        if (res.isDisplayMessage == true) {
          global.showSnackBar("Error", res.message ?? "Failed to update todo");
        }
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "updateTodo",
        e: e,
      );
    }
  }

  void deleteTodo(List<TodoModel> todoList, int index) async {
    try {
      final id = todoList[index].id;
      if (id != null) {
        final res = await APIHelper.instance.deleteTodo(id);
        if (res.status == "success") {
          await fetchTodos();
        } else if (res.isDisplayMessage == true) {
          global.showSnackBar("Error", res.message ?? "Delete failed");
        }
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "deleteTodo",
        e: e,
      );
    }
  }

  void updateTodoStatus(
    List<TodoModel> todoList,
    int index,
    String newStatus,
  ) async {
    try {
      final todo = todoList[index];
      todo.status = newStatus;
      todo.updatedAt = DateTime.now();
      final res = await APIHelper.instance.updateTodo(todo);
      if (res.status == "success") {
        await fetchTodos();
      } else if (res.isDisplayMessage == true) {
        global.showSnackBar("Error", res.message ?? "Status update failed");
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "updateTodoStatus",
        e: e,
      );
    }
  }

  void clearFormValue() {
    try {
      titleController.clear();
      descriptionController.clear();
      minute.value = 3;
      second.value = 0;
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "clearFormValue",
        e: e,
      );
    }
  }

  void onTapSaveButton(int screenId) {
    try {
      if (formKey.currentState!.validate()) {
        // ✅ Form is valid
        log("Title: ${titleController.text}");
        log("Description: ${descriptionController.text}");
        log("Time: ${minute.value} : ${second.value}");
        if (minute.value == 0 && second.value == 0) {
          global.showSnackBar("Validation", "Please select a valid timer");
          return;
        }
        if (screenId == 1) {
          //Add Todo Item
          TodoModel tempTodo = TodoModel(
            title: titleController.text,
            description: descriptionController.text,
            minute: minute.value,
            second: second.value,
            status: "created",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          addTodo(tempTodo);
        } else {
          //Edit Todo Item
          if (editingTodo != null) {
            editingTodo!.title = titleController.text;
            editingTodo!.description = descriptionController.text;
            editingTodo!.minute = minute.value;
            editingTodo!.second = second.value;
            editingTodo!.updatedAt = DateTime.now();
            updateTodo(editingTodo!);
          }
        }

        if (tabController.index == 0) {
          getAllTodoList();
        } else if (tabController.index == 1) {
          getCreatedTodoList();
        } else if (tabController.index == 2) {
          getInProgressTodoList();
        } else {
          getCompletedTodoList();
        }
        Navigator.pop(Get.context!);
      } else {
        // ❌ Form is invalid
        log("Form is invalid");
      }
      clearFormValue();
      editingTodo = null;
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "onTapSaveButton",
        e: e,
      );
    }
  }

  void editTodo(List<TodoModel> todoList, int index, BuildContext context) {
    try {
      editingTodo = todoList[index];
      titleController.text = editingTodo!.title ?? "";
      descriptionController.text = editingTodo!.description ?? "";
      minute.value = editingTodo!.minute ?? 3;
      second.value = editingTodo!.second ?? 0;
      todoAddEditModalBottomSheet(context, 2);
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "editTodo",
        e: e,
      );
    }
  }

  Future<dynamic> todoAddEditModalBottomSheet(
    BuildContext context,
    int screenId,
  ) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => todoBottomSheet(screenId),
    );
  }

  Widget todoBottomSheet(int screenId) {
    return MainBodyPadding(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  screenId == 1 ? "Add Todo" : "Edit Todo",
                  style: Theme.of(Get.context!).textTheme.titleLarge,
                ),
              ),
              height20,
              Text("Title", style: Theme.of(Get.context!).textTheme.bodyMedium),
              height4,
              AppTextFormField(
                hintText: "Title",
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter title";
                  }
                  return null;
                },
              ),
              height20,
              Text(
                "Description",
                style: Theme.of(Get.context!).textTheme.bodyMedium,
              ),
              height4,
              AppTextFormField(
                hintText: "Description",
                maxLines: 4,
                controller: descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter description";
                  }
                  return null;
                },
              ),
              height20,
              Text("Time", style: Theme.of(Get.context!).textTheme.bodyMedium),
              height4,
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.borderSideColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Minutes"),
                          Obx(
                            () => NumberPicker(
                              value: minute.value,
                              minValue: 1,
                              maxValue: 5,
                              itemHeight: 40,
                              itemWidth: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              selectedTextStyle: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColor.primaryColor),
                              onChanged: (value) {
                                minute.value = value;
                                update();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    width10,
                    Expanded(
                      child: Column(
                        children: [
                          Text("Seconds"),
                          Obx(
                            () => NumberPicker(
                              value: second.value,
                              minValue: 0,
                              maxValue: 60,
                              itemHeight: 40,
                              itemWidth: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              selectedTextStyle: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColor.primaryColor),
                              onChanged: (value) {
                                second.value = value;
                                update();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                  width10,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onTapSaveButton(screenId),
                      child: Text("Save"),
                    ),
                  ),
                ],
              ),
              height20,
            ],
          ),
        ),
      ),
    );
  }

  dynamic inProgressButtonDialog(List<TodoModel> todoList, int index) async {
    return global.commonDialog(
      Get.context!,
      titleText: "Move to In Progress",
      contentText: "Are you sure you want to move this todo to In Progress?",
      leftActionButtonText: "Cancel",
      rightActionButtonText: "Move",
      leftActionButtonOnPressed: () {
        Get.back();
      },
      rightActionButtonOnPressed: () {
        updateTodoStatus(todoList, index, "inprogress");
        Get.back();
      },
    );
  }

  dynamic completedButtonDialog(List<TodoModel> todoList, int index) async {
    return global.commonDialog(
      Get.context!,
      titleText: "Move to completed",
      contentText: "Are you sure you want to move this todo to completed?",
      leftActionButtonText: "Cancel",
      rightActionButtonText: "Move",
      leftActionButtonOnPressed: () {
        Get.back();
      },
      rightActionButtonOnPressed: () {
        updateTodoStatus(todoList, index, "completed");

        Get.back();
      },
    );
  }

  /// Converts minutes and seconds to total seconds
  int convertToSeconds(int minute, int second) {
    return (minute * 60) + second;
  }

  Future<void> startTimer(TodoModel todo) async {
    try {
      if (todo.id == null) {
        return;
      }

      final int todoId = todo.id!;

      if (todoTimers.containsKey(todoId)) {
        return;
      }

      if (!remainingSeconds.containsKey(todoId)) {
        remainingSeconds[todoId] = convertToSeconds(
          todo.minute ?? 0,
          todo.second ?? 0,
        );
      }

      if (remainingSeconds[todoId]! <= 0) {
        return;
      }

      // if the todo is still marked created, update it to inprogress now
      if (todo.status == "created") {
        todo.status = "inprogress";
        todo.updatedAt = DateTime.now();
        await updateTodo(todo);
      }

      // Create and store the timer for this specific todo
      todoTimers[todoId] = Timer.periodic(const Duration(seconds: 1), (
        timer,
      ) async {
        remainingSeconds[todoId] = remainingSeconds[todoId]! - 1;

        // Update the todo model
        final minutes = remainingSeconds[todoId]! ~/ 60;
        final seconds = remainingSeconds[todoId]! % 60;
        todo.minute = minutes;
        todo.second = seconds;

        update();

        // When timer reaches zero, mark as completed
        if (remainingSeconds[todoId]! <= 0) {
          timer.cancel();
          todoTimers.remove(todoId);
          remainingSeconds.remove(todoId);

          // directly update the todo status instead of using the list helper
          todo.status = "completed";
          todo.updatedAt = DateTime.now();
          await updateTodo(todo);
        }
      });

      update();
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "startTimer",
        e: e,
      );
    }
  }

  Future<void> pauseTimer(int todoId) async {
    try {
      if (todoTimers.containsKey(todoId)) {
        todoTimers[todoId]?.cancel();
        todoTimers.remove(todoId);
        update();
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "pauseTimer",
        e: e,
      );
    }
  }

  /// Check if a todo timer is currently running
  bool isTimerRunning(int todoId) {
    return todoTimers.containsKey(todoId);
  }

  void searchTodoList() {
    try {
      final query = searchController.text.trim().toLowerCase();
      if (query.isEmpty) {
        if (tabController.index == 0) {
          getAllTodoList();
        } else if (tabController.index == 1) {
          getCreatedTodoList();
        } else if (tabController.index == 2) {
          getInProgressTodoList();
        } else {
          getCompletedTodoList();
        }
        return;
      }

      List<TodoModel>? tempTodoList;
      switch (tabController.index) {
        case 1:
          tempTodoList = todoListModel.createdTodoList;
          break;
        case 2:
          tempTodoList = todoListModel.inProgressTodoList;
          break;
        case 3:
          tempTodoList = todoListModel.completedTodoList;
          break;
        default:
          tempTodoList = todoListModel.allTodoList;
      }
      if (tempTodoList != null) {
        final filtered = tempTodoList.where((t) {
          final title = t.title?.toLowerCase() ?? "";
          final desc = t.description?.toLowerCase() ?? "";
          return title.contains(query) || desc.contains(query);
        }).toList();
        switch (tabController.index) {
          case 1:
            todoListModel.createdTodoList = filtered;
            break;
          case 2:
            todoListModel.inProgressTodoList = filtered;
            break;
          case 3:
            todoListModel.completedTodoList = filtered;
            break;
          default:
            todoListModel.allTodoList = filtered;
        }
        update();
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "searchTodoList",
        e: e,
      );
    }
  }

  void getAllTodoList() async {
    try {
      await fetchTodos();
      if (searchController.text.trim().isNotEmpty) {
        searchTodoList();
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "getAllTodoList",
        e: e,
      );
    }
  }

  void getCreatedTodoList() async {
    try {
      await fetchTodos();
      if (searchController.text.trim().isNotEmpty) {
        searchTodoList();
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "getCreatedTodoList",
        e: e,
      );
    }
  }

  void getInProgressTodoList() async {
    try {
      await fetchTodos();
      if (searchController.text.trim().isNotEmpty) {
        searchTodoList();
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "getInProgressTodoList",
        e: e,
      );
    }
  }

  void getCompletedTodoList() async {
    try {
      await fetchTodos();
      if (searchController.text.trim().isNotEmpty) {
        searchTodoList();
      }
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "home_controller.dart",
        functionNameWithoutBraces: "getCompletedTodoList",
        e: e,
      );
    }
  }
}
