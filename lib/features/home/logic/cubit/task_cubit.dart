import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/utils/app_colors.dart';
import 'package:todo_app/features/home/data/models/task_model.dart';
import 'package:todo_app/features/home/logic/cubit/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  DateTime currentDate = DateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now());
  String endTime = DateFormat('hh:mm a').format(
    DateTime.now().add(
      Duration(minutes: 45),
    ),
  );
  List<Color> taskColors = [
    AppColors.red,
    AppColors.green,
    AppColors.blue,
    AppColors.blueGrey,
    AppColors.orange,
    AppColors.purple,
  ];
  List<TaskModel> tasks = [
    TaskModel(
        title: 'Flutter',
        startTime: "9:33 pm",
        endTime: "10:00 pm",
        note: "Learn Dart",
        isCompleted: false,
        color: 1),
    TaskModel(
        title: 'Flutter',
        startTime: "10:33 pm",
        endTime: "11:00 pm",
        note: "Learn SQLlite",
        isCompleted: false,
        color: 3)
  ];
  int selectedColorIndex = 0;

  TaskCubit() : super(TaskInitial());
  Future<void> changeDate(context) async {
    emit(ChangeDateLoading());
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );

    if (selectedDate != null) {
      currentDate = selectedDate;
      emit(ChangeDateSuccess());
    }
    emit(ChangeDateFailed());
  }

  Future<void> changeStartTime(context) async {
    emit(ChangeStartTimeLoading());
    TimeOfDay? selectedendTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedendTime != null) {
      startTime = selectedendTime.format(context);
      emit(ChangeStartTimeSuccess());
    }
    emit(ChangeStartTimeFailed());
  }

  Future<void> changeEndTime(context) async {
    emit(ChangeEndTimeLoading());
    TimeOfDay? selectedendTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedendTime != null) {
      endTime = selectedendTime.format(context);
      emit(ChangeEndTimeSuccess());
    }
    emit(ChangeEndTimeFailed());
  }

  changeColor(index) {
    selectedColorIndex = index;
    emit(ChangeColorSuccess());
  }

  addTask(TaskModel task) {
    tasks.add(task);
    print("TaskAddedSuccessflly");
    print(tasks.length);
    emit(AddTaskSuccess());
  }
}
