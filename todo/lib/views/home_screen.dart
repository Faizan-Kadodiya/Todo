import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/constants/color_constant.dart';
import 'package:todo/constants/space_constant.dart';
import 'package:todo/controllers/home_controller.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/views/todo_detail_screen.dart';
import 'package:todo/widgets/common_textfield_widget.dart';
import 'package:todo/widgets/main_body_padding.dart';
import 'package:todo/utils/global.dart' as global;

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          bottom: TabBar(
            controller: homeController.tabController,
            onTap: (value) {
              if (homeController.tabController.index == 0) {
                homeController.getAllTodoList();
              } else if (homeController.tabController.index == 1) {
                homeController.getCreatedTodoList();
              } else if (homeController.tabController.index == 2) {
                homeController.getInProgressTodoList();
              } else if (homeController.tabController.index == 3) {
                homeController.getCompletedTodoList();
              }
            },
            tabs: [
              Tab(text: "All"),
              Tab(text: "Created"),
              Tab(text: "Inprogress"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: MainBodyPadding(
          child: Column(
            children: [
              AppTextFormField(
                hintText: "Search",
                controller: homeController.searchController,
                onChanged: (value) {
                  homeController.searchTodoList();
                  homeController.update();
                },
              ),
              height20,
              Expanded(
                child: GetBuilder<HomeController>(
                  builder: (context) {
                    return TabBarView(
                      controller: homeController.tabController,
                      children: [
                        allTodo(homeController.todoListModel.allTodoList ?? []),

                        createdTodo(
                          homeController.todoListModel.createdTodoList ?? [],
                        ),
                        inProgressTodo(
                          homeController.todoListModel.inProgressTodoList ?? [],
                        ),
                        completedTodo(
                          homeController.todoListModel.completedTodoList ?? [],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            homeController.clearFormValue();
            homeController.todoAddEditModalBottomSheet(context, 1);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget allTodo(List<TodoModel> todoList) {
    return todoListWidget(todoList);
  }

  Widget createdTodo(List<TodoModel> todoList) {
    return todoListWidget(todoList);
  }

  Widget inProgressTodo(List<TodoModel> todoList) {
    return todoListWidget(todoList);
  }

  Widget completedTodo(List<TodoModel> todoList) {
    return todoListWidget(todoList);
  }

  Widget todoListWidget(List<TodoModel> todoList) {
    return ListView.separated(
      itemCount: todoList.length,
      separatorBuilder: (context, index) => height20,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => global.navigateTo(
            TodoDetailScreen(index: index, todoList: todoList),
          ),
          child: Stack(
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: todoList[index].status == "inprogress"
                          ? Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "${(todoList[index].minute ?? 0).toString().padLeft(2, '0')}:${(todoList[index].second ?? 0).toString().padLeft(2, '0')}",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          : const SizedBox(),
                      title: Text(todoList[index].title ?? "-"),
                      subtitle: Text(
                        todoList[index].description ?? "-",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: todoList[index].status == "completed"
                          ? Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 15),
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.greenColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                todoList[index].status!.toUpperCase(),
                                style: TextStyle(color: AppColor.greenColor),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => homeController.editTodo(
                                      todoList,
                                      index,
                                      context,
                                    ),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () => global.commonDialog(
                                      context,
                                      titleText: "Delete Todo",
                                      contentText:
                                          "Are you sure you want to delete this todo?",
                                      leftActionButtonText: "Cancel",
                                      rightActionButtonText: "Delete",
                                      leftActionButtonOnPressed: () {
                                        Get.back();
                                      },
                                      rightActionButtonOnPressed: () {
                                        homeController.deleteTodo(
                                          todoList,
                                          index,
                                        );
                                        Get.back();
                                      },
                                    ),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    todoList[index].status == "created"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 10,
                            ),
                            child: ElevatedButton.icon(
                              iconAlignment: IconAlignment.end,
                              onPressed: () => homeController
                                  .inProgressButtonDialog(todoList, index),
                              label: Text("In Progress"),
                              icon: Icon(Icons.arrow_forward_rounded, size: 22),
                            ),
                          )
                        : todoList[index].status == "inprogress"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 10,
                            ),
                            child: ElevatedButton.icon(
                              iconAlignment: IconAlignment.end,
                              onPressed: () => homeController
                                  .completedButtonDialog(todoList, index),
                              label: Text("Completed"),
                              icon: Icon(Icons.arrow_forward_rounded, size: 22),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              todoList[index].status == "completed"
                  ? const SizedBox()
                  : Positioned(
                      right: 20,
                      top: 15,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: todoList[index].status == "created"
                                ? AppColor.greyColor
                                : AppColor.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          todoList[index].status == "created"
                              ? "Created"
                              : "In-Progress",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: todoList[index].status == "created"
                                    ? AppColor.greyColor
                                    : AppColor.primaryColor,
                                fontSize: 12,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
