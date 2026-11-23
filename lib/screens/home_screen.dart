import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';

const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

class HomeScreen extends StatelessWidget {
  /// Called with a tab index: 1 Chat, 2 Voice, 3 Skills, 4 Memory.
  final ValueChanged<int> onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  String _greeting(int hour) {
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              GlassIconButton(icon: Icons.menu, tooltip: 'Menu'),
              Text(
                'Kavya',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              GlassIconButton(
                icon: Icons.notifications_none,
                tooltip: 'Notifications',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(now.hour),
                    style: const TextStyle(fontSize: 15, color: KColors.muted),
                  ),
                  const Text(
                    'dost',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      CircleAvatar(radius: 4, backgroundColor: KColors.green),
                      SizedBox(width: 6),
                      Text(
                        'Sun rahi hai...',
                        style: TextStyle(fontSize: 12, color: KColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
              GlassCard(
                radius: 20,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: const [
                    Icon(Icons.bolt, size: 16, color: KColors.amber),
                    SizedBox(width: 8),
                    Text('5',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    SizedBox(width: 6),
                    Text('Energy',
                        style: TextStyle(fontSize: 11, color: KColors.muted)),
                  ],
                ),
              ),
            ],
          ),
          const Expanded(
            child: Center(child: FittedBox(child: Orb())),
          ),
          Row(
            children: [
              _QuickChip(
                  icon: Icons.music_note, label: 'Gaane', onTap: () => onNavigate(3)),
              const SizedBox(width: 10),
              _QuickChip(
                  icon: Icons.menu_book_outlined,
                  label: 'Padhai',
                  onTap: () => onNavigate(3)),
              const SizedBox(width: 10),
              _QuickChip(
                  icon: Icons.edit_outlined,
                  label: 'Journal',
                  onTap: () => onNavigate(3)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // TODO: connect a weather API; this is placeholder data.
              const _InfoTile(label: 'MAUSAM', value: '20°', sub: 'Clear'),
              const SizedBox(width: 10),
              _InfoTile(
                label: 'AAJ',
                value: '${now.day}',
                sub: '${_days[now.weekday - 1]}, ${_months[now.month - 1]}',
              ),
              const SizedBox(width: 10),
              const _InfoTile(label: 'MOOD', value: 'Pyaar', sub: 'Sab badhiya'),
            ],
          ),
          const SizedBox(height: 12),
          GlassCard(
            radius: 26,
            padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (_) => onNavigate(1),
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Kavya se kuch bhi poochho...',
                      hintStyle: TextStyle(color: KColors.muted, fontSize: 14),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Send',
                  onPressed: () => onNavigate(1),
                  icon: const Icon(Icons.send_rounded, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: KColors.accent,
                    foregroundColor: KColors.bg,
                    fixedSize: const Size(44, 44),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: KColors.glass,
        shape: const StadiumBorder(
          side: BorderSide(color: KColors.glassBorder),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: const Color(0xFF9FC0FF)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  const _InfoTile({
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: SizedBox(
          height: 68,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: KColors.muted, letterSpacing: 0.6)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700)),
              Text(sub,
                  style: const TextStyle(fontSize: 12, color: KColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
