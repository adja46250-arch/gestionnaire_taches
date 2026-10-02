class Task {
  const Task({this.id, required this.title, this.done = false});

  final int? id;
  final String title;
  final bool done;

  Task copyWith({int? id, String? title, bool? done}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'done': done ? 1 : 0,
  };

  factory Task.fromMap(Map<String, Object?> map) => Task(
    id: map['id'] as int?,
    title: map['title'] as String,
    done: (map['done'] as int) == 1,
  );
}