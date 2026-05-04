import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/manga.dart';
import '../widgets/manga_card.dart';
import 'add_manga_page.dart';
import 'manga_detail_page.dart';

class MangaListPage extends StatefulWidget {
  const MangaListPage({super.key});

  @override
  State<MangaListPage> createState() => _MangaListPageState();
}

class _MangaListPageState extends State<MangaListPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("📚 Manga Tracker"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      // 🔵 ปุ่ม + แบบ Google Drive
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMangaPage()),
          );
        },
      ),

      body: Column(
        children: [
          // 🔍 Search Bar สวยขึ้น
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "ค้นหามังงะ",
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => search = v),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 📚 List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<Manga>('mangaBox').listenable(),
              builder: (context, Box<Manga> box, _) {
                var mangas = box.values.toList();

                // 🔍 filter search
                mangas = mangas.where((m) {
                  return m.title
                      .toLowerCase()
                      .contains(search.toLowerCase());
                }).toList();

                if (mangas.isEmpty) {
                  return const Center(
                    child: Text(
                      "ยังไม่มีข้อมูล",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: mangas.length,
                  itemBuilder: (context, index) {
                    final m = mangas[index];

                    return MangaCard(
                      manga: m,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MangaDetailPage(manga: m),
                          ),
                        );
                      },
                      onMenuTap: (type) {
                        if (type == 'note') {
                          _showNoteDialog(m);
                        } else if (type == 'delete') {
                          _deleteManga(m);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void _showNoteDialog(Manga manga) {
  String note = manga.note;

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("เพิ่มหมายเหตุ"),
        content: TextField(
          controller: TextEditingController(text: note),
          onChanged: (v) => note = v,
          decoration: const InputDecoration(
            hintText: "เช่น ขาดเล่ม 12",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () {
              manga.note = note;
              manga.save();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: const Text("บันทึก"),
          ),
        ],
      );
    },
  );
}
void _deleteManga(Manga manga) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("ยืนยันการลบ"),
      content: Text("ลบ ${manga.title} ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
              foregroundColor: Colors.black,
          ),
          child: const Text("ยกเลิก"),
        ),
        ElevatedButton(
          onPressed: () {
            manga.delete();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
          ),
          child: const Text("ลบ"),
        ),
      ],
    ),
  );
}
}