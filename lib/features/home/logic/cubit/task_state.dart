
sealed class TaskState {}

final class TaskInitial extends TaskState {}
final class ChangeDateLoading extends TaskState {}
final class ChangeDateSuccess extends TaskState {}
final class ChangeDateFailed extends TaskState {}
//Start time states
final class ChangeStartTimeLoading extends TaskState {}
final class ChangeStartTimeSuccess extends TaskState {}
final class ChangeStartTimeFailed extends TaskState {}
//endTimeStates
final class ChangeEndTimeLoading extends TaskState {}
final class ChangeEndTimeSuccess extends TaskState {}
final class ChangeEndTimeFailed extends TaskState {}

final class ChangeColorSuccess extends TaskState {}

final class AddTaskSuccess extends TaskState {}


