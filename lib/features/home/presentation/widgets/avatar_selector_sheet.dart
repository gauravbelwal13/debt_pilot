import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'profile_avatar.dart';

class AvatarSelectorSheet extends StatefulWidget {
  const AvatarSelectorSheet({
    required this.initialAvatar,
    super.key,
  });

  final AppAvatar initialAvatar;

  @override
  State<AvatarSelectorSheet> createState() =>
      _AvatarSelectorSheetState();
}

class _AvatarSelectorSheetState
    extends State<AvatarSelectorSheet> {
  late AppAvatar _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.initialAvatar;
  }

  void _save() {
    Navigator.of(context).pop(_selectedAvatar);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDefinition =
        avatarDefinitionFor(_selectedAvatar);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              'Choose your character',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),

            const SizedBox(height: AppSpacing.xs),

            Text(
              'This is how you will appear in DebtPilot.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),

            const SizedBox(height: AppSpacing.xl),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.75,
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
              child: ProfileAvatar(
                key: ValueKey(_selectedAvatar),
                avatar: _selectedAvatar,
                size: 92,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                selectedDefinition.name,
                key: ValueKey(selectedDefinition.name),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: avatarDefinitions.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              itemBuilder: (context, index) {
                final definition = avatarDefinitions[index];
                final isSelected =
                    definition.avatar == _selectedAvatar;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = definition.avatar;
                    });
                  },
                  child: AnimatedScale(
                    scale: isSelected ? 1.08 : 1,
                    duration:
                        const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 220),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.18),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : null,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: ProfileAvatar(
                        avatar: definition.avatar,
                        size: 58,
                        showShadow: false,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize:
                      const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusMd,
                    ),
                  ),
                ),
                child: const Text(
                  'Use this character',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}