import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  Note({
    required this.title,

    required this.contentJson,

    required this.dateCreated,

    required this.dateModified,

    this.tags,
  });

  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String contentJson;

  @HiveField(2)
  final DateTime dateCreated;

  @HiveField(3)
  final DateTime dateModified;

  @HiveField(4)
  final List<String>? tags;
}
