import 'package:flutter/material.dart';

import '../agent_service.dart';
import '../theme.dart';
import '../widgets.dart';

class _Msg {
  final String text;
  final bool fromUser;
  final String? skill;
  const _Msg(this.text, this.fromUser, {this.skill});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _msgs = [
    const _Msg('Namaste dost! Aaj ka din kaisa raha?', false),
  ];
  bool _busy = false;

  static const _suggestions = ['Journal likho', 'Kal ka plan', 'Gaana badlo'];

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _input.text).trim();
    if (text.isEmpty || _busy) return;
    setState(() {
      _msgs.add(_Msg(text, true));
      _input.clear();
      _busy = true;
    });
    _toEnd();
    final r = await AgentService.instance.reply(text);
    if (!mounted) return;
    setState(() {
      _msgs.add(_Msg(r.text, false, skill: r.skill));
      _busy = false;
    });
    _toEnd();
  }

  Widget _bubble(_Msg m, double maxW) {
    final user = m.fromUser;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Column(
          crossAxisAlignment:
              user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: user ? KColors.accent : const Color(0x12FFFFFF),
                border: user ? null : Border.all(color: KColors.glassBorder),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(user ? 20 : 6),
                  bottomRight: Radius.circular(user ? 6 : 20),
                ),
              ),
              child: Text(
                m.text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: user ? KColors.bg : KColors.text,
                  fontWeight: user ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (m.skill != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _skillCard(m.skill!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _skillCard(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: KColors.accent.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KColors.accent.withAlpha(90)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, size: 18, color: KColors.accentSoft),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width * 0.78;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: [
              const MiniOrb(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Kavya',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        CircleAvatar(
                            radius: 3.5, backgroundColor: KColors.green),
                        SizedBox(width: 6),
                        Text('Online, sab yaad hai',
                            style: TextStyle(
                                fontSize: 12, color: KColors.muted)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            itemCount: _msgs.length + (_busy ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i >= _msgs.length) {
                return const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Kavya soch rahi hai...',
                    style: TextStyle(fontSize: 12, color: KColors.muted),
                  ),
                );
              }
              return _bubble(_msgs[i], maxW);
            },
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _suggestions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => ActionChip(
              label: Text(_suggestions[i]),
              onPressed: () => _send(_suggestions[i]),
              backgroundColor: KColors.glass,
              side: const BorderSide(color: KColors.glassBorder),
              shape: const StadiumBorder(),
              labelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GlassCard(
            radius: 26,
            padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    onSubmitted: (_) => _send(),
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Kavya ko message likho...',
                      hintStyle: TextStyle(color: KColors.muted, fontSize: 14),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Send',
                  onPressed: _send,
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
        ),
      ],
    );
  }
}
