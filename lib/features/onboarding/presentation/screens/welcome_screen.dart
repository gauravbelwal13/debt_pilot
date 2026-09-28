import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_gradient_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _exitController;

  @override
  void initState() {
    super.initState();

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _exitController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_exitController.isAnimating) return;

    await _exitController.forward();

    if (!mounted) return;

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF073D3A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;

            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.00,
                    0.30,
                    0.58,
                    1.00,
                  ],
                  colors: [
                    Color(0xFFF2FAFC),
                    Color(0xFFFFF0E8),
                    Color(0xFFFFD8B7),
                    Color.fromARGB(255, 131, 5, 55),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Landscape artwork.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: height * 0.36,
                    height: height * 0.50,
                    child: Image.asset(
                      'assets/images/welcome_landscape.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),

                  // Soft transition into landscape.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: height * 0.32,
                    height: height * 0.18,
                    child: const IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00FFDDBF),
                              Color(0xCCFFDDBF),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Dark bottom fade.
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: height * 0.36,
                    child: const IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00073D3A),
                              Color(0xB0073D3A),
                              Color(0xFF073D3A),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          // Upper content disappears first.
                          Expanded(
                            child: FadeTransition(
                              opacity: Tween<double>(
                                begin: 1,
                                end: 0,
                              ).animate(
                                CurvedAnimation(
                                  parent: _exitController,
                                  curve: const Interval(
                                    0.0,
                                    0.45,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              ),
                              child: ScaleTransition(
                                scale: Tween<double>(
                                  begin: 1,
                                  end: 0.94,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _exitController,
                                    curve: const Interval(
                                      0.0,
                                      0.55,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: height * 0.045,
                                    ),

                                    Image.asset(
                                      'assets/images/debtpilot_logo.png',
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.contain,
                                    ),

                                    const SizedBox(
                                      height: AppSpacing.sm,
                                    ),

                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: AppTextStyles
                                            .textTheme.headlineMedium
                                            ?.copyWith(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.8,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: 'Debt',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Pilot',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: AppSpacing.sm,
                                    ),

                                    Text(
                                      'Turn your debts\ninto freedom.',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles
                                          .textTheme.headlineMedium
                                          ?.copyWith(
                                        fontSize: 19,
                                        height: 1.14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: AppSpacing.md,
                                    ),

                                    Text(
                                      'Track • Plan • Pay • Achieve',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles
                                          .textTheme.labelLarge
                                          ?.copyWith(
                                        color: AppColors.primaryDark,
                                        fontSize: 12,
                                        letterSpacing: 0.2,
                                      ),
                                    ),

                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: Column(
                              children: [
                                // Bottom text disappears.
                                FadeTransition(
                                  opacity: Tween<double>(
                                    begin: 1,
                                    end: 0,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _exitController,
                                      curve: const Interval(
                                        0.0,
                                        0.35,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'A better tomorrow\nis a planned today.',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles
                                        .textTheme.bodyLarge
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: AppSpacing.xxl,
                                ),

                                // Selected action enlarges.
                                ScaleTransition(
                                  scale: Tween<double>(
                                    begin: 1,
                                    end: 1.16,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _exitController,
                                      curve: const Interval(
                                        0.20,
                                        1.0,
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                  ),
                                  child: AppGradientButton(
                                    label: 'Get Started',
                                    icon: Icons.arrow_forward_rounded,
                                    onPressed: _continue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}