import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/color_constant.dart';
import 'package:todo/constants/helper.dart';
import 'package:todo/constants/space_constant.dart';
import 'package:todo/controllers/home_controller.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/widgets/common_outline_button.dart';
import 'package:todo/widgets/main_body_padding.dart';

class TodoDetailScreen extends StatelessWidget {
  final int? index;
  final List<TodoModel> todoList;

  TodoDetailScreen({super.key, required this.index, required this.todoList});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: GetBuilder<HomeController>(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
              ),
              title: Text(todoList[index!].title ?? "No Title"),
              actions: [
                todoList[index!].status == "completed"
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () =>
                            homeController.editTodo(todoList, index!, context),
                        icon: Icon(Icons.edit, color: AppColor.whiteColor),
                      ),
              ],
            ),
            body: MainBodyPadding(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Description
                  SizedBox(
                    width: Helper().getDevicewidth(context),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          todoList[index!].description ?? "No Description",
                        ),
                      ),
                    ),
                  ),
                  //Timer
                  todoList[index!].status == "completed"
                      ? const SizedBox()
                      : GetBuilder<HomeController>(
                          init: homeController,
                          builder: (_) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          todoList[index!].minute
                                              .toString()
                                              .padLeft(2, '0'),
                                          style: const TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text("Minutes"),
                                      ],
                                    ),
                                    width20,
                                    const Text(
                                      ":",
                                      style: TextStyle(fontSize: 40),
                                    ),
                                    width20,
                                    Column(
                                      children: [
                                        Text(
                                          todoList[index!].second
                                              .toString()
                                              .padLeft(2, '0'),
                                          style: const TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text("Seconds"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  //Play and Pause Button
                  todoList[index!].status == "completed"
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Card(
                                child: IconButton(
                                  onPressed:
                                      homeController.isTimerRunning(
                                        todoList[index!].id ?? 0,
                                      )
                                      ? null
                                      : () => homeController.startTimer(
                                          todoList[index!],
                                        ),
                                  icon: Column(
                                    children: [
                                      Icon(
                                        Icons.play_circle_outline_rounded,
                                        size: 50,
                                      ),
                                      Text("Play"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            width20,
                            Expanded(
                              child: Card(
                                child: IconButton(
                                  onPressed:
                                      !homeController.isTimerRunning(
                                        todoList[index!].id ?? 0,
                                      )
                                      ? null
                                      : () => homeController.pauseTimer(
                                          todoList[index!].id ?? 0,
                                        ),
                                  icon: Column(
                                    children: [
                                      Icon(
                                        Icons.pause_circle_outline_rounded,
                                        size: 50,
                                      ),
                                      Text("Pause"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            bottomNavigationBar: MainBodyPadding(
              child: CommonOutlineButton(
                onPressed: () {},
                buttonText: todoList[index!].status!.toUpperCase(),
              ),
            ),
          );
        },
      ),
    );
  }
}
