import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';

class _Skill {
  final String name;
  final String desc;
  final IconData icon;
  bool on;
  _Skill(this.name, this.desc, this.icon, this.on);
}

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final List<_Skill> _skills = [
    _Skill('Gaane', 'Mood ke hisaab se music bajao', Icons.music_note, true),
    _Skill('Padhai', 'Notes, quiz aur doubt solve', Icons.menu_book_outlined, true),
    _Skill('Journal', 'Roz ki diary, bolke ya likhke', Icons.edit_outlined, true),
    _Skill('Alarm aur Reminder', 'Samay par yaad dilao', Icons.alarm, true),
    _Skill('Web Search', 'Internet se taaza jawab laao', Icons.search, false),
  ];

  String _filter = 'Sab';
  String _query = '';

  List<_Skill> get _visible => _skills.where((s) {
        if (_filter == 'Active' && !s.on) return false;
        if (_filter == 'Band' && s.on) return false;
        if (_query.isNotEmpty &&
            !s.name.toLowerCase().contains(_query.toLowerCase())) {
          return false;
        }
        return true;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skills',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Kavya jo kaam kar sakti hai, tum on ya off karo.',
              style: TextStyle(fontSize: 14, color: KColors.muted)),
          const SizedBox(height: 16),
          GlassCard(
            radius: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: KColors.muted),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Skill dhoondo...',
                      hintStyle: TextStyle(color: KColors.muted, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final f in const ['Sab', 'Active', 'Band']) ...[
                FilterPill(
                  label: f,
                  selected: _filter == f,
                  onTap: () => setState(() => _filter = f),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: [
                for (final s in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlassCard(
                      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: s.on
                                  ? KColors.accent.withAlpha(51)
                                  : const Color(0x14FFFFFF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              s.icon,
                              size: 22,
                              color: s.on ? const Color(0xFF9FC0FF) : KColors.muted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.name,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                Text(s.desc,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: KColors.muted,
                                        height: 1.4)),
                              ],
                            ),
                          ),
                          KSwitch(
                            value: s.on,
                            onChanged: (v) => setState(() => s.on = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text('Koi skill nahi mili.',
                          style: TextStyle(color: KColors.muted)),
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Naya skill jodo'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    foregroundColor: KColors.accentSoft,
                    side: const BorderSide(color: Color(0x47FFFFFF)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
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
