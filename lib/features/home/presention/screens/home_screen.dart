import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/DI/get_it.dart';
import 'package:todo_app/core/database/sqflite_helper/sqflite_helper.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/core/utils/app_assets.dart';
import 'package:todo_app/core/utils/app_colors.dart';
import 'package:todo_app/core/utils/app_strings.dart';
import 'package:todo_app/core/widgets/custom_button.dart';
import 'package:todo_app/features/home/data/models/task_model.dart';
import 'package:todo_app/features/home/logic/cubit/task_cubit.dart';
import 'package:todo_app/features/home/logic/cubit/task_state.dart';

// ignore: must_be_immutable
class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  final dbHelper = getIt<SqfLiteHelper>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              List<TaskModel> tasks = BlocProvider.of<TaskCubit>(context).tasks;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        //current date and theme icon
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 24),
                      ),
                      IconButton(
                          onPressed: () {
                            BlocProvider.of<TaskCubit>(context).changeTheme();
                          },
                          icon: Icon(
                            Icons.nightlight_round,
                            color: BlocProvider.of<TaskCubit>(context).isDark
                                ? AppColors.white
                                : AppColors.background,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //today text
                  Text(
                    AppStrings.today,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 24),
                  ),
                  // Data Picker
                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: AppColors.primary,
                    selectedTextColor: AppColors.white,
                    dateTextStyle: Theme.of(context).textTheme.displayMedium!,
                    dayTextStyle: Theme.of(context).textTheme.displayMedium!,
                    monthTextStyle: Theme.of(context).textTheme.displayMedium!,
                    onDateChange:
                        BlocProvider.of<TaskCubit>(context).changeSelectedDate,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  // tasks list
                  state is GetTasksLoading
                      ? Center(child: CircularProgressIndicator())
                      : (tasks.isNotEmpty
                          ? _tasksList(context, tasks)
                          : _noTasksWidget(context)),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addTaskScreen);
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
    );
  }
}

_noTasksWidget(context) {
  return Center(
    child: Column(
      children: [
        Image.asset(AppAssets.noTasks),
        Text(
          AppStrings.noTaskTitle,
          style:
              Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 16),
        ),
        Text(
          AppStrings.noTaskSubTitle,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ],
    ),
  );
}

_tasksList(context, List<TaskModel> tasks) {
  return Expanded(
    child: ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            _buildBottomSheet(context, tasks[index]);
          },
          child: _buildTaskComponent(
            context,
            tasks[index],
          ),
        );
      },
      itemCount: tasks.length,
    ),
  );
}

void _buildBottomSheet(buildContext, TaskModel task) {
  showModalBottomSheet(
    context: buildContext,
    builder: (context) {
      return Container(
        height: 240,
        width: double.infinity,
        padding: EdgeInsets.all(24),
        color: AppColors.deepGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            task.isCompleted == 0
                ? SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomButton(
                        text: AppStrings.taskCompleted,
                        onPressed: () {
                          BlocProvider.of<TaskCubit>(buildContext).updateTask(
                              task.id!,
                              BlocProvider.of<TaskCubit>(buildContext)
                                  .selectedDate);
                          Navigator.pop(context);
                        }),
                  )
                : Container(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                text: AppStrings.deleteTask,
                onPressed: () {
                  BlocProvider.of<TaskCubit>(buildContext).deleteTask(task.id!,
                      BlocProvider.of<TaskCubit>(buildContext).selectedDate);
                  Navigator.pop(context);
                },
                backgroundColor: AppColors.red,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                  text: AppStrings.cancel,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      );
    },
  );
}

_buildTaskComponent(BuildContext context, TaskModel taskModel) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    padding: EdgeInsets.all(12),
    height: 140,
    decoration: BoxDecoration(
      color: BlocProvider.of<TaskCubit>(context).taskColors[taskModel.color],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        // النصوص داخل Expanded لتجنب التجاوز
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskModel.title,
                style: Theme.of(context).textTheme.displayLarge,
                overflow: TextOverflow.ellipsis, // لمنع تجاوز النص
                maxLines: 1, // تحديد عدد الأسطر المسموح بها
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.timer),
                  const SizedBox(width: 4), // تباعد صغير بين الأيقونة والنص
                  Text(
                    '${taskModel.startTime} - ${taskModel.endTime}',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                taskModel.note,
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // تحديد عدد الأسطر
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),

        SizedBox(width: 12),

        // Divider
        Container(
          width: 2,
          height: 75,
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 12),
        ),

        // نص "TODO" أو "Completed"
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            taskModel.isCompleted == 1 ? AppStrings.completed : AppStrings.toDo,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ],
    ),
  );
}
