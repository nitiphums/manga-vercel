import 'package:flutter/material.dart';
import '../models/manga.dart';
import '../services/manga_service.dart';

class MangaDetailPage extends StatefulWidget {
  final Manga manga;

  const MangaDetailPage({super.key, required this.manga});

  @override
  State<MangaDetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  final service = MangaService();

  late int volume;

  @override
  void initState() {
    super.initState();
    volume = widget.manga.currentVolume;
  }

  void _save() {
    widget.manga.currentVolume = volume;
    widget.manga.ownedVolumes =
        List.generate(volume, (i) => i + 1);

    service.update(widget.manga);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.manga.title),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [
          const SizedBox(height: 40),

          // 🔥 ตัวเลขกลางจอ
          Text(
            "$volume",
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "เล่มล่าสุดที่มี",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 40),

          // 🔥 ปุ่ม + -
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircleButton(
                icon: Icons.remove,
                onTap: () {
                  if (volume > 1) {
                    setState(() => volume--);
                  }
                },
              ),
              const SizedBox(width: 40),
              _buildCircleButton(
                icon: Icons.add,
                onTap: () {
                  setState(() => volume++);
                },
              ),
            ],
          ),

          const Spacer(),

          // 🔥 ปุ่ม Save ด้านล่าง
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "บันทึก",
                  style: TextStyle(fontSize: 18 , color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            )
          ],
        ),
        child: Icon(icon, size: 30),
      ),
    );
  }
  
}