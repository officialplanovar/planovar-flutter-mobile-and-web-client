import 'package:equatable/equatable.dart';

class TodoAssignment extends Equatable {
  final String id;
  final String userId;
  final bool isDone;
  final DateTime? doneAt;

  const TodoAssignment({
    required this.id,
    required this.userId,
    required this.isDone,
    this.doneAt,
  });

  factory TodoAssignment.fromJson(Map<String, dynamic> j) => TodoAssignment(
        id: j['id'] as String,
        userId: j['userId'] as String,
        isDone: j['isDone'] as bool? ?? false,
        doneAt: j['doneAt'] != null ? DateTime.tryParse(j['doneAt'] as String) : null,
      );

  @override
  List<Object?> get props => [id, userId, isDone];
}

/// A group-chat to-do; each assignee ticks off their own task.
class TodoModel extends Equatable {
  final String id;
  final String createdBy;
  final String title;
  final String? description;
  final DateTime? dueAt;
  final List<TodoAssignment> assignments;

  const TodoModel({
    required this.id,
    required this.createdBy,
    required this.title,
    this.description,
    this.dueAt,
    required this.assignments,
  });

  int get doneCount => assignments.where((a) => a.isDone).length;
  int get totalCount => assignments.length;

  /// This user's own assignment, if any.
  TodoAssignment? mine(String userId) {
    for (final a in assignments) {
      if (a.userId == userId) return a;
    }
    return null;
  }

  factory TodoModel.fromJson(Map<String, dynamic> j) => TodoModel(
        id: j['id'] as String,
        createdBy: j['createdBy'] as String? ?? '',
        title: j['title'] as String? ?? '',
        description: j['description'] as String?,
        dueAt: j['dueAt'] != null ? DateTime.tryParse(j['dueAt'] as String) : null,
        assignments: ((j['assignments'] as List?) ?? const [])
            .map((e) => TodoAssignment.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );

  @override
  List<Object?> get props => [id, title, assignments];
}
