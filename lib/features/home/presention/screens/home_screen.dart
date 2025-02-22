import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/core/utils/app_assets.dart';
import 'package:todo_app/core/utils/app_colors.dart';
import 'package:todo_app/core/utils/app_strings.dart';
import 'package:todo_app/core/widgets/custom_button.dart';
import 'package:todo_app/features/home/data/models/task_model.dart';
import 'package:todo_app/features/home/logic/cubit/task_cubit.dart';
import 'package:todo_app/features/home/logic/cubit/task_state.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              print("State is $state");
              List<TaskModel> tasks = BlocProvider.of<TaskCubit>(context).tasks;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    AppStrings.today,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 24),
                  ),
                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: AppColors.primary,
                    selectedTextColor: AppColors.white,
                    dateTextStyle: Theme.of(context).textTheme.displayMedium!,
                    dayTextStyle: Theme.of(context).textTheme.displayMedium!,
                    monthTextStyle: Theme.of(context).textTheme.displayMedium!,
                    onDateChange: (date) {
                      // New date selected
                      // setState(() {
                      //   _selectedValue = date;
                      // });
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _tasksList(context, tasks),
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
            _buildBottomSheet(context);
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

void _buildBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 240,
        width: double.infinity,
        padding: EdgeInsets.all(24),
        color: AppColors.deepGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                  text: AppStrings.taskCompleted, onPressed: () {}),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                text: AppStrings.deleteTask,
                onPressed: () {},
                backgroundColor: AppColors.red,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(text: AppStrings.cancel, onPressed: () {}),
            ),
          ],
        ),
      );
    },
  );
}

_buildTaskComponent(context, TaskModel taskModel) {
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
        //column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //text
            Text(
              taskModel.title,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            //row
            Row(
              children: [
                Icon(
                  Icons.timer,
                  color: AppColors.white,
                ),
                Text('${taskModel.startTime} - ${taskModel.endTime}',
                    style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            //text
            Text(
              taskModel.note,
              style: Theme.of(context).textTheme.displayLarge,
            )
          ],
        ),
        Spacer(),
        //divider
        Container(
          width: 2,
          height: 75,
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 20),
        ),
        //todo text
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            taskModel.isCompleted ? AppStrings.completed : AppStrings.toDo,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        )
      ],
    ),
  );
}
