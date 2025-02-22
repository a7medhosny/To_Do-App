
class TaskModel {
  final String title;
  final String startTime;
  final String endTime;
  final String note;
  final bool isCompleted;
  final int color;

  TaskModel(
      {required this.title,
      required this.startTime,
      required this.endTime,
      required this.note,
      required this.isCompleted,
      required this.color});

}
