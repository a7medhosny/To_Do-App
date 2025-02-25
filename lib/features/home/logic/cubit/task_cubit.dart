import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/DI/get_it.dart';
import 'package:todo_app/core/database/cache/cache_helper.dart';
import 'package:todo_app/core/database/sqflite_helper/sqflite_helper.dart';
import 'package:todo_app/core/utils/app_colors.dart';
import 'package:todo_app/features/home/data/models/task_model.dart';
import 'package:todo_app/features/home/logic/cubit/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
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
  final dbHelper = getIt<SqfLiteHelper>();

  List<TaskModel> tasks = [];
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

  void changeSelectedDate(date) {
    selectedDate = date;
    emit(ChangeSelectedDateSuccess());
    getTasks(date);
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

  addTask(TaskModel task, DateTime date) async {
    emit(AddTaskLoading());
    try {
      await dbHelper.insertToDB(task);
      emit(AddTaskSuccess());
      getTasks(date);
    } catch (e) {
      print("Error in add task $e");
      emit(AddTaskFalied());
    }
  }

  getTasks(date) {
    emit(GetTasksLoading());
    try {
      print("date : $date");
      dbHelper.getFromDB().then((taskList) {
        tasks = taskList
            .map((task) => TaskModel.fromJson(task))
            .toList()
            .where((task) {
          print("task.date ${task.date}");
          print("selected : ${DateFormat.yMd().format(date)}");
          return task.date == (DateFormat.yMd().format(date));
        }).toList();
        emit(GetTasksSuccess());
      });
    } catch (e) {
      print("Error in get tasks $e");
      emit(GetTasksFalied());
    }
  }

  updateTask(int id, DateTime date) {
    try {
      dbHelper.updatedDB(id);
      getTasks(date);
    } catch (e) {
      print("Error in update task $e");
    }
  }

  deleteTask(int id, DateTime date) async {
    try {
      await dbHelper.deleteFromDB(id);
      getTasks(date);
    } catch (e) {
      print("Error in delete task $e");
    }
  }

  bool isDark = false;
  changeTheme() async {
    isDark = !isDark;
    await getIt<CacheHelper>().saveData(key: 'isDark', value: isDark);
    getTheme();
  }

  getTheme() {
    isDark = getIt<CacheHelper>().getData(key: 'isDark') ?? false;
    emit(GetThemeState());
  }
}
