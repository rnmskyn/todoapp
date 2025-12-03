import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
//@JsonSerializable()
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String text,
    @BoolIntConverter() @Default(false) bool isCompleted,
  }) = _Todo;

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
}

class BoolIntConverter extends JsonConverter<bool, int> {
  const BoolIntConverter();
  @override
  bool fromJson(int json) => json != 0;
  @override
  int toJson(bool object) => object ? 1 : 0;
}
