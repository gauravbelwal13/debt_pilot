import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'avatar_selector_sheet.dart';
import 'profile_avatar.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    required this.userName,
    required this.avatar,
    required this.onNameChanged,
    required this.onAvatarChanged,
    required this.onSettings,
    super.key,
  });

  final String userName;
  final AppAvatar avatar;

  final ValueChanged<String> onNameChanged;
  final ValueChanged<AppAvatar> onAvatarChanged;

  final VoidCallback onSettings;

  Future<void> _editAvatar(
    BuildContext context,
  ) async {
    final selectedAvatar =
        await showModalBottomSheet<AppAvatar>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            AppSpacing.radiusXl,
          ),
        ),
      ),
      builder: (_) {
        return AvatarSelectorSheet(
          initialAvatar: avatar,
          
        );
      },
    );

    if (selectedAvatar != null) {
      onAvatarChanged(selectedAvatar);
    }
  }

  Future<void> _editName(
    BuildContext context,
  ) async {
    final controller =
        TextEditingController(
      text: userName,
    );

    final result =
        await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Edit Name',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization:
                TextCapitalization.words,
            decoration:
                const InputDecoration(
              labelText: 'Your name',
              hintText: 'Enter your name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                final name =
                    controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                Navigator.of(
                  dialogContext,
                ).pop(name);
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result != null &&
        result.trim().isNotEmpty) {
      onNameChanged(
        result.trim(),
      );
    }
  }

  Future<void> _showAbout(
  BuildContext context,
) async {
  Navigator.of(context).pop();

  await Future<void>.delayed(
    const Duration(
      milliseconds: 180,
    ),
  );

  if (!context.mounted) {
    return;
  }
}

  Future<void> _showExitConfirmation(
    BuildContext context,
  ) async {
    final shouldExit =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Exit DebtPilot?',
          ),
          content: const Text(
            'Your locally stored data will remain '
            'on this device.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: const Text(
                'Exit',
              ),
            ),
          ],
        );
      },
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

   void _openAbout(BuildContext context) {
  Navigator.of(context).pop();
  context.push('/about');
}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width:
          MediaQuery.of(context).size.width * 0.84,
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: 'Close',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ProfileAvatar(
                        avatar: avatar,
                        size: 96,
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Material(
                          color: AppColors.primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () {
                              _editAvatar(
                                context,
                              );
                            },
                            customBorder:
                                const CircleBorder(),
                            child: const Padding(
                              padding:
                                  EdgeInsets.all(8),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 17,
                                color:
                                    AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: AppSpacing.md,
                  ),

                  Text(
                    userName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight:
                              FontWeight.w800,
                        ),
                  ),

                  const SizedBox(
                    height: AppSpacing.xs,
                  ),

                  InkWell(
                    onTap: () {
                      _editName(
                        context,
                      );
                    },
                    borderRadius:
                        BorderRadius.circular(
                      AppSpacing.radiusRound,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            AppSpacing.md,
                        vertical:
                            AppSpacing.xs,
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_rounded,
                            size: 14,
                            color:
                                AppColors.primary,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Edit profile',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      AppColors.primary,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              color: AppColors.divider,
            ),

            const SizedBox(
              height: AppSpacing.sm,
            ),

            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                children: [
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    selected: true,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  _DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About',
                    onTap: () {
                      _openAbout(
                        context,
                      );
                    },
                  ),

                  _DrawerItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pop();

                      onSettings();
                    },
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  const Divider(
                    color: AppColors.divider,
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  _DrawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Exit',
                    iconColor:
                        AppColors.error,
                    onTap: () {
                      _showExitConfirmation(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(
                AppSpacing.lg,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(
                  AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius:
                      BorderRadius.circular(
                    AppSpacing.radiusMd,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color:
                          AppColors.primaryDark,
                      size: 20,
                    ),
                    const SizedBox(
                      width: AppSpacing.sm,
                    ),
                    Expanded(
                      child: Text(
                        'Small steps today. '
                        'More freedom tomorrow.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color:
                                  AppColors.primaryDark,
                              fontWeight:
                                  FontWeight.w600,
                            ),
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

class _DrawerItem
    extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ??
        (selected
            ? AppColors.primary
            : AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Material(
        color: selected
            ? AppColors.primaryLight
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(
            AppSpacing.radiusMd,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: color,
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: color,
                          fontWeight:
                              selected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                        ),
                  ),
                ),
                if (selected)
                  Container(
                    width: 7,
                    height: 7,
                    decoration:
                        const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}