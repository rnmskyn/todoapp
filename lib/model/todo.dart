
class Todo {
  final String id;
  final String text;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.text,
    this.isCompleted = false,
  });

  // Create a copy with modified properties
  Todo copyWith({
    String? id,
    String? text,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'text': text, 'isCompleted': isCompleted ? 1 : 0 };
  }
}
