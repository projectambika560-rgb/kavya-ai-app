import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';
import 'screens/memory_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/voice_screen.dart';
import 'theme.dart';
import 'widgets.dart';

void main() => runApp(const KavyaApp());

class KavyaApp extends StatelessWidget {
  const KavyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kavya',
      debugShowCheckedModeBanner: false,
      theme: kavyaTheme(),
      home: const Shell(),
    );
  }
}

/// Holds the 5 tabs: 0 Home, 1 Chat, 2 Voice, 3 Skills, 4 Memory.
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _index,
                children: [
                  HomeScreen(onNavigate: _go),
                  const ChatScreen(),
                  VoiceScreen(onNavigate: _go),
                  const SkillsScreen(),
                  const MemoryScreen(),
                ],
              ),
            ),
            KavyaNav(index: _index, onTap: _go),
          ],
        ),
      ),
    );
  }
}
