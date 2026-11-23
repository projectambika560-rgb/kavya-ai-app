import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';

/// Voice mode UI. The waveform is animated for the look only.
/// TODO: add real speech input/output (for example the `speech_to_text`
/// and `flutter_tts` packages) and feed the result into AgentService.
class VoiceScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;
  const VoiceScreen({super.key, required this.onNavigate});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  bool _listening = true;
  bool _muted = false;

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  Widget _waveform() {
    const bars = 15;
    return AnimatedBuilder(
      animation: _ac,
      builder: (context, _) {
        final live = _listening && !_muted;
        return SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(bars, (i) {
              final wave = 0.5 + 0.5 * math.sin(2 * math.pi * (_ac.value + i / bars));
              final h = live ? 12 + 50 * wave : 8.0;
              return Container(
                width: 5,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(
                  color: i > 3 && i < 11 ? const Color(0xFF8FB0FF) : KColors.accent,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = !_listening
        ? 'Ruki hui hai'
        : _muted
            ? 'Mic mute hai'
            : 'Sun rahi hai...';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlassIconButton(
                icon: Icons.chevron_left,
                tooltip: 'Back to Home',
                onPressed: () => widget.onNavigate(0),
              ),
              const Text('Voice',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(44, 44),
                  foregroundColor: KColors.text,
                  backgroundColor: KColors.glass,
                  side: const BorderSide(color: KColors.glassBorder),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Hinglish',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 4,
                backgroundColor: _listening && !_muted ? KColors.green : KColors.muted,
              ),
              const SizedBox(width: 8),
              Text(status,
                  style: const TextStyle(
                      fontSize: 14,
                      color: KColors.accentSoft,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Orb(size: 128),
                    const SizedBox(height: 20),
                    _waveform(),
                  ],
                ),
              ),
            ),
          ),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Demo text. Replace with the live transcript later.
                Text('TUM',
                    style: TextStyle(
                        fontSize: 11, color: KColors.muted, letterSpacing: 0.6)),
                SizedBox(height: 4),
                Text('Kal subah 7 baje ka alarm laga do.',
                    style: TextStyle(fontSize: 14, height: 1.45)),
                Divider(height: 20, color: KColors.glassBorder),
                Text('KAVYA',
                    style: TextStyle(
                        fontSize: 11, color: KColors.muted, letterSpacing: 0.6)),
                SizedBox(height: 4),
                Text('Theek hai, kal subah 7:00 ka alarm set kar diya.',
                    style: TextStyle(
                        fontSize: 14, height: 1.45, color: KColors.accentSoft)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: _muted ? 'Unmute microphone' : 'Mute microphone',
                onPressed: () => setState(() => _muted = !_muted),
                icon: Icon(_muted ? Icons.mic_off : Icons.mic_none, size: 24),
                style: IconButton.styleFrom(
                  backgroundColor: KColors.glass,
                  foregroundColor: KColors.text,
                  fixedSize: const Size(56, 56),
                  side: const BorderSide(color: KColors.glassBorder),
                ),
              ),
              const SizedBox(width: 28),
              IconButton(
                tooltip: _listening ? 'Stop' : 'Start listening',
                onPressed: () => setState(() => _listening = !_listening),
                icon: Icon(_listening ? Icons.stop_rounded : Icons.mic, size: 30),
                style: IconButton.styleFrom(
                  backgroundColor: _listening ? KColors.coral : KColors.accent,
                  foregroundColor: KColors.bg,
                  fixedSize: const Size(72, 72),
                ),
              ),
              const SizedBox(width: 28),
              IconButton(
                tooltip: 'Switch to chat',
                onPressed: () => widget.onNavigate(1),
                icon: const Icon(Icons.chat_bubble_outline, size: 24),
                style: IconButton.styleFrom(
                  backgroundColor: KColors.glass,
                  foregroundColor: KColors.text,
                  fixedSize: const Size(56, 56),
                  side: const BorderSide(color: KColors.glassBorder),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
