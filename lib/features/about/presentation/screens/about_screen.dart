import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../home/presentation/widgets/profile_avatar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    AppIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: Colors.transparent,
                    ),
                    const Expanded(
                      child: Text(
                        'About',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xxxl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _AppHero(),

                    const SizedBox(height: AppSpacing.xl),

                    const _SectionTitle(
                      title: 'What is DebtPilot?',
                      subtitle:
                          'A simple way to understand, organize, and track your debt journey.',
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FeatureRow(
                            icon: Icons.account_balance_wallet_rounded,
                            title: 'Track your debts',
                            description:
                                'Keep your loans and outstanding balances in one place.',
                            color: AppColors.primary,
                            background: AppColors.primaryLight,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          const _FeatureRow(
                            icon: Icons.calendar_month_rounded,
                            title: 'Plan your payments',
                            description:
                                'See upcoming payment dates and keep your schedule clear.',
                            color: AppColors.blue,
                            background: AppColors.blueLight,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          const _FeatureRow(
                            icon: Icons.insights_rounded,
                            title: 'Understand your progress',
                            description:
                                'Turn your debt information into useful progress insights.',
                            color: AppColors.purple,
                            background: AppColors.purpleLight,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    const _SectionTitle(
                      title: 'The idea behind DebtPilot',
                      subtitle:
                          'Debt can feel complicated when everything is scattered. DebtPilot is designed to make the picture easier to understand.',
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.orangeLight,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                            ),
                            child: const Icon(
                              Icons.flag_rounded,
                              color: AppColors.orange,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          Text(
                            'One clear picture.',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                          ),

                          const SizedBox(height: AppSpacing.sm),

                          Text(
                            'DebtPilot brings your debt details, payment schedule, calendar and progress into one simple experience.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.55,
                                  color: AppColors.textSecondary,
                                ),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(
                              AppSpacing.lg,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.route_rounded,
                                  color: AppColors.primaryDark,
                                ),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    'Track. Understand. Move forward.',
                                    style: TextStyle(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    const _SectionTitle(
                      title: 'Developer',
                      subtitle:
                          'Designed and developed with a focus on simple mobile experiences.',
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppCard(
                      child: Row(
                        children: [
                          const ProfileAvatar(
                            avatar: AppAvatar.nova,
                            size: 72,
                          ),

                          const SizedBox(width: AppSpacing.lg),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gaurav Belwal',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight:
                                            FontWeight.w800,
                                        color:
                                            AppColors.textPrimary,
                                      ),
                                ),

                                const SizedBox(
                                  height: AppSpacing.xs,
                                ),

                                Text(
                                  'Flutter Developer',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color:
                                            AppColors.primaryDark,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                ),

                                const SizedBox(
                                  height: AppSpacing.sm,
                                ),

                                Text(
                                  'Product, UI and application development',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color:
                                            AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    AppCard(
                      child: Column(
                        children: [
                          const _TechItem(
                            icon: Icons.phone_android_rounded,
                            label: 'Flutter',
                          ),
                          const Divider(
                            height: AppSpacing.xl,
                            color: AppColors.divider,
                          ),
                          const _TechItem(
                            icon: Icons.code_rounded,
                            label: 'Dart',
                          ),
                          const Divider(
                            height: AppSpacing.xl,
                            color: AppColors.divider,
                          ),
                          const _TechItem(
                            icon: Icons.account_tree_rounded,
                            label: 'Riverpod + GoRouter',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    Center(
                      child: Column(
                        children: [
                          Text(
                            'DebtPilot',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Turn your debts into freedom.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'MVP • Built with Flutter',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.textMuted,
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
      ),
    );
  }
}

class _AppHero extends StatelessWidget {
  const _AppHero();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.explore_rounded,
              size: 38,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
              children: [
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

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Turn your debts into freedom.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              _MiniPill(
                icon: Icons.track_changes_rounded,
                label: 'Track',
              ),
              _MiniPill(
                icon: Icons.event_note_rounded,
                label: 'Plan',
              ),
              _MiniPill(
                icon: Icons.insights_rounded,
                label: 'Understand',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                height: 1.45,
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusMd,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusRound,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TechItem extends StatelessWidget {
  const _TechItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusSm,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}