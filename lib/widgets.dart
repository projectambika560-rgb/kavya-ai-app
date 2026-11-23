import 'package:flutter/material.dart';

import 'theme.dart';

/// Rounded translucent card used everywhere in the app.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 20,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? KColors.glass,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? KColors.glassBorder),
      ),
      child: child,
    );
  }
}

/// The big glowing avatar with rings.
class Orb extends StatelessWidget {
  final double size;
  const Orb({super.key, this.size = 140});

  Widget _ring(double d, Color c) => Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: c),
        ),
      );

  Widget _eye() => Container(
        width: size * 0.08,
        height: size * 0.17,
        decoration: BoxDecoration(
          color: KColors.bg.withAlpha(217),
          borderRadius: BorderRadius.circular(size * 0.05),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.8,
      height: size * 1.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _ring(size * 1.8, KColors.accent.withAlpha(70)),
          _ring(size * 1.45, KColors.violet.withAlpha(95)),
          _ring(size * 1.15, KColors.accentSoft.withAlpha(55)),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-0.3, -0.45),
                radius: 0.95,
                colors: [Color(0xFFB7D0FF), KColors.accent, Color(0xFF3A31B5)],
                stops: [0.0, 0.42, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: KColors.accent.withAlpha(140),
                  blurRadius: 70,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_eye(), SizedBox(width: size * 0.16), _eye()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small avatar for chat headers.
class MiniOrb extends StatelessWidget {
  final double size;
  const MiniOrb({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    Widget eye() => Container(
          width: size * 0.1,
          height: size * 0.22,
          decoration: BoxDecoration(
            color: KColors.bg,
            borderRadius: BorderRadius.circular(size * 0.06),
          ),
        );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.45),
          radius: 0.95,
          colors: [Color(0xFFB7D0FF), KColors.accent, Color(0xFF3A31B5)],
          stops: [0.0, 0.45, 1.0],
        ),
        boxShadow: [
          BoxShadow(color: KColors.accent.withAlpha(128), blurRadius: 20),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [eye(), SizedBox(width: size * 0.15), eye()],
      ),
    );
  }
}

/// Round glass icon button (menu, bell, back, ...).
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
      tooltip: tooltip,
      icon: Icon(icon, size: 22),
      style: IconButton.styleFrom(
        backgroundColor: KColors.glass,
        foregroundColor: KColors.text,
        fixedSize: const Size(44, 44),
        side: const BorderSide(color: KColors.glassBorder),
      ),
    );
  }
}

/// Filter chip: "Sab", "Active", ...
class FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? KColors.accent : KColors.glass,
      shape: StadiumBorder(
        side: selected
            ? BorderSide.none
            : const BorderSide(color: KColors.glassBorder),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? KColors.bg : KColors.text,
            ),
          ),
        ),
      ),
    );
  }
}

/// On/off switch styled like the design.
class KSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const KSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? Colors.white : KColors.muted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? KColors.accent
            : const Color(0x29FFFFFF),
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}

/// Bottom navigation: Home, Chat, Voice (centre), Skills, Memory.
class KavyaNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const KavyaNav({super.key, required this.index, required this.onTap});

  Widget _item(int i, String label, IconData icon) {
    final active = index == i;
    final color = active ? KColors.accentSoft : KColors.muted;
    return Semantics(
      button: true,
      selected: active,
      child: Material(
        color: active ? KColors.accent.withAlpha(56) : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onTap(i),
          child: SizedBox(
            width: 58,
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: color),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mic() {
    final active = index == 2;
    return Semantics(
      button: true,
      selected: active,
      label: 'Voice',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: active
              ? Border.all(color: KColors.accent.withAlpha(90), width: 4)
              : null,
          boxShadow: [
            BoxShadow(color: KColors.accent.withAlpha(140), blurRadius: 28),
          ],
        ),
        child: Material(
          color: KColors.accent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onTap(2),
            child: const SizedBox(
              width: 60,
              height: 60,
              child: Icon(Icons.mic, size: 26, color: KColors.bg),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: KColors.glass,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: KColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item(0, 'Home', Icons.home_outlined),
          _item(1, 'Chat', Icons.chat_bubble_outline),
          _mic(),
          _item(3, 'Skills', Icons.bolt),
          _item(4, 'Memory', Icons.layers_outlined),
        ],
      ),
    );
  }
}
