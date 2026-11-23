import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';

class _Mem {
  final String tag;
  final String text;
  final String when;
  const _Mem(this.tag, this.text, this.when);
}

/// Memory list. Data is in-memory demo data.
/// TODO: save to the phone (shared_preferences / sqflite) or your backend.
class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  bool _memoryOn = true;
  String _filter = 'Sab';

  final List<_Mem> _items = [
    const _Mem('Routine', 'Subah 7 baje uthna hai, halka gaana pasand hai.', 'Aaj'),
    const _Mem('Pasand', 'Hinglish mein baat karna pasand hai.', '2 din pehle'),
    const _Mem('Goal', 'Roz 1 ghanta padhai karne ka target hai.', 'Pichhle hafte'),
    const _Mem('Pasand', 'Thake hone par chhote aur halke jawab chahiye.', 'Pichhle hafte'),
  ];

  static const _tagColors = {
    'Routine': [Color(0x385B8CFF), Color(0xFFBFD3FF)],
    'Pasand': [Color(0x408B7BFF), Color(0xFFCFC8FF)],
    'Goal': [Color(0x334ADE9A), Color(0xFF9DF0C6)],
  };

  Future<void> _forgetAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151C45),
        title: const Text('Sab kuch bhool jao?'),
        content: const Text('Kavya ki saari yaadein hamesha ke liye hat jayengi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Nahi'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Haan, bhool jao',
                style: TextStyle(color: KColors.coral)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) setState(() => _items.clear());
  }

  @override
  Widget build(BuildContext context) {
    final shown = _items
        .where((m) => _filter == 'Sab' || m.tag == _filter)
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Memory',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Kavya tumhare baare mein jo yaad rakhti hai.',
              style: TextStyle(fontSize: 14, color: KColors.muted)),
          const SizedBox(height: 16),
          GlassCard(
            color: KColors.accent.withAlpha(30),
            borderColor: KColors.accent.withAlpha(90),
            padding: const EdgeInsets.fromLTRB(16, 8, 6, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_memoryOn ? 'Memory chalu hai' : 'Memory band hai',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const Text('Kavya baatein yaad rakhegi',
                          style: TextStyle(fontSize: 12, color: KColors.muted)),
                    ],
                  ),
                ),
                KSwitch(
                  value: _memoryOn,
                  onChanged: (v) => setState(() => _memoryOn = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in const ['Sab', 'Routine', 'Goal', 'Pasand']) ...[
                  FilterPill(
                    label: f,
                    selected: _filter == f,
                    onTap: () => setState(() => _filter = f),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: [
                for (final m in shown)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlassCard(
                      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 22,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: _tagColors[m.tag]![0],
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Text(m.tag,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: _tagColors[m.tag]![1])),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(m.when,
                                        style: const TextStyle(
                                            fontSize: 12, color: KColors.muted)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(m.text,
                                    style: const TextStyle(
                                        fontSize: 14, height: 1.45)),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Ye yaad hatao',
                            onPressed: () => setState(() => _items.remove(m)),
                            icon: const Icon(Icons.close, size: 18),
                            color: KColors.muted,
                            style: IconButton.styleFrom(
                                fixedSize: const Size(44, 44)),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (shown.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text('Abhi kuch yaad nahi.',
                          style: TextStyle(color: KColors.muted)),
                    ),
                  ),
                OutlinedButton(
                  onPressed: _items.isEmpty ? null : _forgetAll,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: const Color(0xFFFF9DB2),
                    side: const BorderSide(color: Color(0x73FF6B8B)),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Sab kuch bhool jao'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
