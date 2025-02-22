import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/utils/app_colors.dart';
import 'package:todo_app/core/utils/app_strings.dart';
import 'package:todo_app/core/widgets/custom_button.dart';
import 'package:todo_app/features/home/data/models/task_model.dart';
import 'package:todo_app/features/home/logic/cubit/task_cubit.dart';
import 'package:todo_app/features/home/logic/cubit/task_state.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            final taskCubit = context.read<TaskCubit>();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _addTaskField(
                      titleController, AppStrings.tilteHint, AppStrings.tilte),
                  SizedBox(height: 24),
                  _addTaskField(
                      noteController, AppStrings.notehint, AppStrings.note),
                  SizedBox(height: 24),
                  _addTaskField(
                    dateController,
                    DateFormat.yMd().format(taskCubit.currentDate),
                    AppStrings.date,
                    suffixIcon: _buildDatePickerButton(taskCubit),
                    readOnly: true,
                  ),
                  SizedBox(height: 24),
                  _buildTimeRow(taskCubit),
                  SizedBox(height: 24),
                  _buildColorList(taskCubit),
                  SizedBox(height: 24),
                  _buildCreateTaskButton(taskCubit)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.white),
      ),
      title: Text(AppStrings.addTask,
          style: Theme.of(context).textTheme.displayLarge),
    );
  }

  Widget _addTaskField(
      TextEditingController controller, String hintText, String title,
      {IconButton? suffixIcon, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.displayMedium),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            fillColor: AppColors.deepGrey,
            filled: true,
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
          readOnly: readOnly,
        ),
      ],
    );
  }

  IconButton _buildDatePickerButton(TaskCubit taskCubit) {
    return IconButton(
      onPressed: () => taskCubit.changeDate(context),
      icon: Icon(Icons.calendar_month_rounded, color: AppColors.white),
    );
  }

  Widget _buildTimeRow(TaskCubit taskCubit) {
    return Row(
      children: [
        Expanded(
          child: _buildTimePicker(
            taskCubit.startTime,
            AppStrings.startTime,
            () => taskCubit.changeStartTime(context),
          ),
        ),
        SizedBox(width: 26),
        Expanded(
          child: _buildTimePicker(
            taskCubit.endTime,
            AppStrings.endTime,
            () => taskCubit.changeEndTime(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String hintText, String title, VoidCallback onTap) {
    return _addTaskField(
      TextEditingController(),
      hintText,
      title,
      suffixIcon: IconButton(
        onPressed: onTap,
        icon: Icon(Icons.timer_outlined, color: AppColors.white),
      ),
      readOnly: true,
    );
  }

  Widget _buildColorList(TaskCubit taskCubit) {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.color,
              style: Theme.of(context).textTheme.displayMedium),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: taskCubit.taskColors.length,
              itemBuilder: (context, index) =>
                  _buildColorOption(taskCubit, index),
              separatorBuilder: (_, __) => SizedBox(width: 8),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildColorOption(TaskCubit taskCubit, int index) {
    return GestureDetector(
      onTap: () => taskCubit.changeColor(index),
      child: CircleAvatar(
        backgroundColor: taskCubit.taskColors[index],
        child: taskCubit.selectedColorIndex == index
            ? Icon(Icons.check, color: AppColors.white)
            : Container(),
      ),
    );
  }

  Widget _buildCreateTaskButton(TaskCubit taskCubit) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
        text: AppStrings.createTask,
        onPressed: () {
          taskCubit.addTask(
            TaskModel(
                title: titleController.text,
                startTime: taskCubit.startTime,
                endTime: taskCubit.endTime,
                note: noteController.text,
                isCompleted: false,
                color: taskCubit.selectedColorIndex),
          );
        },
      ),
    );
  }
}
