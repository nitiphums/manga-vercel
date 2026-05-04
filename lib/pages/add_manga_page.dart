import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/manga.dart';
import '../services/manga_service.dart';

class AddMangaPage extends StatefulWidget {
  const AddMangaPage({super.key});

  @override
  State<AddMangaPage> createState() => _AddMangaPageState();
}

class _AddMangaPageState extends State<AddMangaPage> {
  final service = MangaService();

  String title = '';
  int currentVolume = 1;

  void _save() {
    if (title.isEmpty) return;

    final manga = Manga(
      id: const Uuid().v4(),
      title: title,
      publisher: '',
      startVolume: 1,
      currentVolume: currentVolume,
      ownedVolumes: List.generate(currentVolume, (i) => i + 1),
      imagePath: '',
      note: '',
    );

    service.add(manga);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("เพิ่มมังงะ"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(16),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "ชื่อเรื่อง",
                      ),
                      onChanged: (v) => title = v,
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      decoration: const InputDecoration(
                        labelText: "เล่มล่าสุด",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) =>
                          currentVolume = int.tryParse(v) ?? 1,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          // 🔥 ปุ่ม Save ล่างจอ
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "บันทึก",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}