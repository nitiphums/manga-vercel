import 'package:flutter/material.dart';
import '../models/manga.dart';

class MangaCard extends StatelessWidget {
  final Manga manga;
  final VoidCallback onTap;
  final Function(String) onMenuTap;

  const MangaCard({
    super.key,
    required this.manga,
    required this.onTap,
    required this.onMenuTap,
  });

  List<int> getMissing() {
    List<int> missing = [];
    for (int i = manga.startVolume; i <= manga.currentVolume; i++) {
      if (!manga.ownedVolumes.contains(i)) {
        missing.add(i);
      }
    }
    return missing;
  }

  @override
  Widget build(BuildContext context) {
    final missing = getMissing();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(18),
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.menu_book, size: 40),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        manga.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("มีถึงเล่ม ${manga.currentVolume}"),

                      const SizedBox(height: 6),

                      if (missing.isNotEmpty)
                        Text(
                          "❗ ขาด ${missing.join(', ')}",
                          style: const TextStyle(color: Colors.red),
                        )
                      else if (manga.note.isNotEmpty)
                        Text(
                          manga.note,
                          style: const TextStyle(color: Colors.blue),
                        ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  onSelected: (value) {
                    onMenuTap(value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'note',
                      child: Text('เพิ่ม/แก้ไข Note'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('ลบ'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}