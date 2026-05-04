import 'package:hive/hive.dart';
import '../models/manga.dart';

class MangaService {
  final box = Hive.box<Manga>('mangaBox');

  List<Manga> getAll() => box.values.toList();

  void add(Manga manga) => box.put(manga.id, manga);

  void update(Manga manga) => manga.save();

  void delete(String id) => box.delete(id);
}