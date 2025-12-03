// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Todo _$TodoFromJson(Map<String, dynamic> json) => _Todo(
  id: json['id'] as String,
  text: json['text'] as String,
  isCompleted: json['isCompleted'] == null
      ? false
      : const BoolIntConverter().fromJson((json['isCompleted'] as num).toInt()),
);

Map<String, dynamic> _$TodoToJson(_Todo instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'isCompleted': const BoolIntConverter().toJson(instance.isCompleted),
};
