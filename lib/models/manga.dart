import 'package:hive/hive.dart';

part 'manga.g.dart';

@HiveType(typeId: 0)
class Manga extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String publisher;

  @HiveField(3)
  int startVolume;

  @HiveField(4)
  int currentVolume;

  @HiveField(5)
  List<int> ownedVolumes;

  @HiveField(6)
  String imagePath;

  @HiveField(7)
  String note;

  Manga({
    required this.id,
    required this.title,
    required this.publisher,
    required this.startVolume,
    required this.currentVolume,
    required this.ownedVolumes,
    required this.imagePath,
    required this.note,
  });
}