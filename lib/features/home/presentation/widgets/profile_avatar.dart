import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

enum AppAvatar {
  nova,
  arin,
  maya,
  kabir,
  zoya,
  dev,
  tara,
  rian,
}

class AvatarDefinition {
  const AvatarDefinition({
    required this.avatar,
    required this.name,
    required this.background,
  });

  final AppAvatar avatar;
  final String name;
  final Color background;
}

const List<AvatarDefinition> avatarDefinitions = [
  AvatarDefinition(
    avatar: AppAvatar.nova,
    name: 'Nova',
    background: Color(0xFFE1F5F1),
  ),
  AvatarDefinition(
    avatar: AppAvatar.arin,
    name: 'Arin',
    background: Color(0xFFE6F1FF),
  ),
  AvatarDefinition(
    avatar: AppAvatar.maya,
    name: 'Maya',
    background: Color(0xFFF0EBFF),
  ),
  AvatarDefinition(
    avatar: AppAvatar.kabir,
    name: 'Kabir',
    background: Color(0xFFFFF4DD),
  ),
  AvatarDefinition(
    avatar: AppAvatar.zoya,
    name: 'Zoya',
    background: Color(0xFFFFE9E9),
  ),
  AvatarDefinition(
    avatar: AppAvatar.dev,
    name: 'Dev',
    background: Color(0xFFE4F2EF),
  ),
  AvatarDefinition(
    avatar: AppAvatar.tara,
    name: 'Tara',
    background: Color(0xFFEDE9FF),
  ),
  AvatarDefinition(
    avatar: AppAvatar.rian,
    name: 'Rian',
    background: Color(0xFFE8F3FF),
  ),
];

AvatarDefinition avatarDefinitionFor(AppAvatar avatar) {
  return avatarDefinitions.firstWhere(
    (definition) => definition.avatar == avatar,
  );
}

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    required this.avatar,
    this.size = 64,
    this.showShadow = true,
    super.key,
  });

  final AppAvatar avatar;
  final double size;
  final bool showShadow;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final definition = avatarDefinitionFor(widget.avatar);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.72,
              end: 1,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
            ),
            child: child,
          ),
        );
      },
      child: _AnimatedCharacter(
        key: ValueKey(widget.avatar),
        avatar: widget.avatar,
        background: definition.background,
        size: widget.size,
        showShadow: widget.showShadow,
        animation: _animationController,
      ),
    );
  }
}

class _AnimatedCharacter extends AnimatedWidget {
  const _AnimatedCharacter({
    required super.key,
    required this.avatar,
    required this.background,
    required this.size,
    required this.showShadow,
    required Animation<double> animation,
  }) : super(listenable: animation);

  final AppAvatar avatar;
  final Color background;
  final double size;
  final bool showShadow;

  Animation<double> get animation =>
      listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final value = animation.value;

    final bob =
        math.sin(value * math.pi * 2) * size * 0.018;

    final breathing =
        1 + math.sin(value * math.pi * 2) * 0.008;

    return Transform.translate(
      offset: Offset(0, bob),
      child: Transform.scale(
        scale: breathing,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: background,
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: size * 0.12,
                      offset: Offset(0, size * 0.05),
                    ),
                  ]
                : null,
          ),
          child: ClipOval(
            child: CustomPaint(
              painter: _CharacterPainter(
                avatar: avatar,
                animationValue: value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CharacterPainter extends CustomPainter {
  const _CharacterPainter({
    required this.avatar,
    required this.animationValue,
  });

  final AppAvatar avatar;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final character = _CharacterStyle.forAvatar(avatar);

    final centerX = size.width / 2;

    final scale = size.width / 100;

    canvas.save();
    canvas.scale(scale);

    final blinkPhase = animationValue % 1;
    final isBlinking =
        blinkPhase > 0.84 && blinkPhase < 0.89;

    // Shadow behind character.
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.07);

    canvas.drawOval(
      const Rect.fromLTWH(24, 88, 52, 7),
      shadowPaint,
    );

    // Body.
    final bodyPaint = Paint()
      ..color = character.shirt;

    final bodyRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(27, 61, 46, 43),
      const Radius.circular(18),
    );

    canvas.drawRRect(bodyRect, bodyPaint);

    // Shirt detail.
    final shirtDetailPaint = Paint()
      ..color = character.shirtDetail;

    canvas.drawCircle(
      Offset(centerX, 80),
      7,
      shirtDetailPaint,
    );

    // Neck.
    final neckPaint = Paint()
      ..color = character.skin;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(43, 51, 14, 17),
        const Radius.circular(6),
      ),
      neckPaint,
    );

    // Ears.
    canvas.drawCircle(
      const Offset(29, 43),
      6,
      neckPaint,
    );

    canvas.drawCircle(
      const Offset(71, 43),
      6,
      neckPaint,
    );

    // Head.
    canvas.drawCircle(
      const Offset(50, 42),
      25,
      neckPaint,
    );

    // Hair.
    final hairPaint = Paint()
      ..color = character.hair;

    _drawHair(canvas, hairPaint, avatar);

    // Hair accent.
    if (character.hairAccent != null) {
      final accentPaint = Paint()
        ..color = character.hairAccent!;

      canvas.drawCircle(
        const Offset(68, 25),
        4,
        accentPaint,
      );
    }

    // Eyes.
    final eyePaint = Paint()
      ..color = AppColors.textPrimary;

    if (isBlinking) {
      final blinkPaint = Paint()
        ..color = AppColors.textPrimary
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        const Offset(39, 43),
        const Offset(44, 43),
        blinkPaint,
      );

      canvas.drawLine(
        const Offset(56, 43),
        const Offset(61, 43),
        blinkPaint,
      );
    } else {
      canvas.drawCircle(
        const Offset(41, 43),
        2.2,
        eyePaint,
      );

      canvas.drawCircle(
        const Offset(59, 43),
        2.2,
        eyePaint,
      );

      final eyeHighlight = Paint()
        ..color = Colors.white;

      canvas.drawCircle(
        const Offset(41.7, 42.3),
        0.7,
        eyeHighlight,
      );

      canvas.drawCircle(
        const Offset(59.7, 42.3),
        0.7,
        eyeHighlight,
      );
    }

    // Nose.
    final nosePaint = Paint()
      ..color = character.skinShadow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      const Offset(50, 45),
      const Offset(48.5, 49),
      nosePaint,
    );

    // Smile.
    final smilePaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final smilePath = Path()
      ..moveTo(45, 53)
      ..quadraticBezierTo(50, 57, 55, 53);

    canvas.drawPath(smilePath, smilePaint);

    // Accessories.
    _drawAccessory(canvas, character, avatar);

    canvas.restore();
  }

  void _drawHair(
    Canvas canvas,
    Paint paint,
    AppAvatar avatar,
  ) {
    switch (avatar) {
      case AppAvatar.nova:
        canvas.drawCircle(
          const Offset(50, 29),
          24,
          paint,
        );

        canvas.drawCircle(
          const Offset(31, 31),
          9,
          paint,
        );

        canvas.drawCircle(
          const Offset(69, 31),
          9,
          paint,
        );

      case AppAvatar.arin:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(26, 16, 48, 25),
            const Radius.circular(15),
          ),
          paint,
        );

        canvas.drawRect(
          const Rect.fromLTWH(26, 28, 48, 9),
          paint,
        );

      case AppAvatar.maya:
        canvas.drawCircle(
          const Offset(50, 27),
          26,
          paint,
        );

        canvas.drawCircle(
          const Offset(27, 35),
          8,
          paint,
        );

        canvas.drawCircle(
          const Offset(73, 35),
          8,
          paint,
        );

      case AppAvatar.kabir:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(27, 17, 46, 23),
            const Radius.circular(10),
          ),
          paint,
        );

        final fringe = Path()
          ..moveTo(30, 31)
          ..quadraticBezierTo(40, 20, 50, 29)
          ..quadraticBezierTo(60, 19, 70, 31)
          ..lineTo(70, 38)
          ..lineTo(30, 38)
          ..close();

        canvas.drawPath(fringe, paint);

      case AppAvatar.zoya:
        canvas.drawCircle(
          const Offset(50, 28),
          25,
          paint,
        );

        canvas.drawCircle(
          const Offset(25, 48),
          8,
          paint,
        );

        canvas.drawCircle(
          const Offset(75, 48),
          8,
          paint,
        );

      case AppAvatar.dev:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(28, 17, 44, 18),
            const Radius.circular(8),
          ),
          paint,
        );

        final beardPaint = Paint()
          ..color = paint.color.withValues(alpha: 0.75);

        canvas.drawArc(
          const Rect.fromLTWH(35, 46, 30, 25),
          0,
          math.pi,
          true,
          beardPaint,
        );

      case AppAvatar.tara:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(25, 18, 50, 22),
            const Radius.circular(13),
          ),
          paint,
        );

        canvas.drawCircle(
          const Offset(29, 42),
          8,
          paint,
        );

        canvas.drawCircle(
          const Offset(71, 42),
          8,
          paint,
        );

      case AppAvatar.rian:
        canvas.drawCircle(
          const Offset(50, 28),
          24,
          paint,
        );

        final frontHair = Path()
          ..moveTo(28, 29)
          ..quadraticBezierTo(43, 12, 58, 27)
          ..quadraticBezierTo(68, 18, 73, 31)
          ..lineTo(72, 38)
          ..lineTo(28, 38)
          ..close();

        canvas.drawPath(frontHair, paint);
    }
  }

  void _drawAccessory(
    Canvas canvas,
    _CharacterStyle character,
    AppAvatar avatar,
  ) {
    switch (avatar) {
      case AppAvatar.nova:
        final glassesPaint = Paint()
          ..color = AppColors.textPrimary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(
          const Offset(40, 43),
          6,
          glassesPaint,
        );

        canvas.drawCircle(
          const Offset(60, 43),
          6,
          glassesPaint,
        );

        canvas.drawLine(
          const Offset(46, 43),
          const Offset(54, 43),
          glassesPaint,
        );

      case AppAvatar.arin:
        final capPaint = Paint()
          ..color = character.accessory;

        canvas.drawArc(
          const Rect.fromLTWH(25, 11, 50, 25),
          math.pi,
          math.pi,
          true,
          capPaint,
        );

        canvas.drawOval(
          const Rect.fromLTWH(51, 27, 30, 7),
          capPaint,
        );

      case AppAvatar.maya:
        final earringPaint = Paint()
          ..color = AppColors.orange;

        canvas.drawCircle(
          const Offset(28, 50),
          3,
          earringPaint,
        );

        canvas.drawCircle(
          const Offset(72, 50),
          3,
          earringPaint,
        );

      case AppAvatar.kabir:
        final headphonePaint = Paint()
          ..color = character.accessory
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

        canvas.drawArc(
          const Rect.fromLTWH(29, 16, 42, 45),
          math.pi,
          math.pi,
          false,
          headphonePaint,
        );

      case AppAvatar.zoya:
        final bowPaint = Paint()
          ..color = character.accessory;

        final left = Path()
          ..moveTo(66, 21)
          ..lineTo(79, 15)
          ..lineTo(75, 29)
          ..close();

        final right = Path()
          ..moveTo(79, 15)
          ..lineTo(87, 24)
          ..lineTo(75, 29)
          ..close();

        canvas.drawPath(left, bowPaint);
        canvas.drawPath(right, bowPaint);

      case AppAvatar.dev:
        final glassesPaint = Paint()
          ..color = AppColors.textPrimary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(
          const Offset(40, 43),
          6,
          glassesPaint,
        );

        canvas.drawCircle(
          const Offset(60, 43),
          6,
          glassesPaint,
        );

        canvas.drawLine(
          const Offset(46, 43),
          const Offset(54, 43),
          glassesPaint,
        );

      case AppAvatar.tara:
        final flowerPaint = Paint()
          ..color = AppColors.primary;

        canvas.drawCircle(
          const Offset(75, 22),
          4,
          flowerPaint,
        );

        canvas.drawCircle(
          const Offset(81, 22),
          4,
          flowerPaint,
        );

        canvas.drawCircle(
          const Offset(78, 17),
          4,
          flowerPaint,
        );

        canvas.drawCircle(
          const Offset(78, 22),
          2,
          Paint()..color = AppColors.orange,
        );

      case AppAvatar.rian:
        final browPaint = Paint()
          ..color = character.accessory
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawLine(
          const Offset(36, 36),
          const Offset(46, 34),
          browPaint,
        );

        canvas.drawLine(
          const Offset(54, 34),
          const Offset(64, 36),
          browPaint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _CharacterPainter oldDelegate) {
    return oldDelegate.avatar != avatar ||
        oldDelegate.animationValue != animationValue;
  }
}

class _CharacterStyle {
  const _CharacterStyle({
    required this.skin,
    required this.skinShadow,
    required this.hair,
    required this.shirt,
    required this.shirtDetail,
    required this.accessory,
    this.hairAccent,
  });

  final Color skin;
  final Color skinShadow;
  final Color hair;
  final Color shirt;
  final Color shirtDetail;
  final Color accessory;
  final Color? hairAccent;

  static _CharacterStyle forAvatar(AppAvatar avatar) {
    switch (avatar) {
      case AppAvatar.nova:
        return const _CharacterStyle(
          skin: Color(0xFFF2C7A5),
          skinShadow: Color(0xFFDCA47E),
          hair: Color(0xFF3B2926),
          shirt: AppColors.primary,
          shirtDetail: Color(0xFFBCE8DF),
          accessory: AppColors.primaryDark,
        );

      case AppAvatar.arin:
        return const _CharacterStyle(
          skin: Color(0xFFC98D68),
          skinShadow: Color(0xFFA96D4F),
          hair: Color(0xFF201B1A),
          shirt: AppColors.blue,
          shirtDetail: Color(0xFFB9D9FA),
          accessory: AppColors.blue,
        );

      case AppAvatar.maya:
        return const _CharacterStyle(
          skin: Color(0xFFE0A77C),
          skinShadow: Color(0xFFC3845E),
          hair: Color(0xFF472D25),
          shirt: AppColors.purple,
          shirtDetail: Color(0xFFD8CCFF),
          accessory: AppColors.orange,
        );

      case AppAvatar.kabir:
        return const _CharacterStyle(
          skin: Color(0xFFA96F4F),
          skinShadow: Color(0xFF8B5239),
          hair: Color(0xFF211B1A),
          shirt: Color(0xFF356F9B),
          shirtDetail: Color(0xFFB8D9EE),
          accessory: Color(0xFF24516F),
        );

      case AppAvatar.zoya:
        return const _CharacterStyle(
          skin: Color(0xFFD59A75),
          skinShadow: Color(0xFFB97A59),
          hair: Color(0xFF241B1B),
          shirt: Color(0xFFE47777),
          shirtDetail: Color(0xFFFFC7C7),
          accessory: Color(0xFFB94C67),
        );

      case AppAvatar.dev:
        return const _CharacterStyle(
          skin: Color(0xFF7E513C),
          skinShadow: Color(0xFF633B2D),
          hair: Color(0xFF171515),
          shirt: Color(0xFF344A67),
          shirtDetail: Color(0xFFAEC0D9),
          accessory: Color(0xFF26364D),
        );

      case AppAvatar.tara:
        return const _CharacterStyle(
          skin: Color(0xFFE7B38E),
          skinShadow: Color(0xFFC98A68),
          hair: Color(0xFF5A392C),
          shirt: Color(0xFF4E9F8E),
          shirtDetail: Color(0xFFC5E8DF),
          accessory: AppColors.primary,
        );

      case AppAvatar.rian:
        return const _CharacterStyle(
          skin: Color(0xFFB87958),
          skinShadow: Color(0xFF95553F),
          hair: Color(0xFF292020),
          shirt: Color(0xFFF09B38),
          shirtDetail: Color(0xFFFFD49D),
          accessory: Color(0xFFB96816),
        );
    }
  }
}