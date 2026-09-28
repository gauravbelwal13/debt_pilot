import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../home/presentation/widgets/avatar_selector_sheet.dart';
import '../../../home/presentation/widgets/profile_avatar.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  String _userName = 'Gaurav';

  AppAvatar _avatar = AppAvatar.nova;

  bool _notificationsEnabled = true;

  bool _appLockEnabled = false;

  Future<void> _editAvatar() async {
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
          initialAvatar: _avatar,
        );
      },
    );

    if (selectedAvatar == null) {
      return;
    }

    setState(() {
      _avatar = selectedAvatar;
    });
  }

  Future<void> _editName() async {
    final controller = TextEditingController(
      text: _userName,
    );

    final result = await showDialog<String>(
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
            decoration: const InputDecoration(
              labelText: 'Your name',
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
                final value =
                    controller.text.trim();

                if (value.isEmpty) {
                  return;
                }

                Navigator.of(
                  dialogContext,
                ).pop(value);
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
        result.isNotEmpty) {
      setState(() {
        _userName = result;
      });
    }
  }

  void _showComingSoon(
    String message,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'DebtPilot',
      applicationVersion: 'UI Preview',
      applicationIcon: const Icon(
        Icons.account_balance_wallet_rounded,
        color: AppColors.primary,
        size: 34,
      ),
      applicationLegalese:
          'Track. Plan. Become debt free.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(context),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              _buildProfileCard(context),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              SettingsSection(
                title: 'Preferences',
                children: [
                  SettingsTile(
                    icon: Icons.notifications_rounded,
                    title: 'Notifications',
                    subtitle:
                        _notificationsEnabled
                            ? 'Payment reminders are on'
                            : 'Payment reminders are off',
                    trailing: Switch(
                      value:
                          _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled =
                              value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _notificationsEnabled =
                            !_notificationsEnabled;
                      });
                    },
                  ),
                  SettingsTile(
                    icon: Icons.palette_rounded,
                    title: 'Appearance',
                    subtitle:
                        'Light theme',
                    onTap: () {
                      _showComingSoon(
                        'Theme customization will be connected later.',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              SettingsSection(
                title: 'Security',
                children: [
                  SettingsTile(
                    icon: Icons.lock_rounded,
                    title: 'App Lock',
                    subtitle:
                        _appLockEnabled
                            ? 'Protection enabled'
                            : 'Protection disabled',
                    iconColor:
                        AppColors.purple,
                    trailing: Switch(
                      value:
                          _appLockEnabled,
                      onChanged: (value) {
                        setState(() {
                          _appLockEnabled =
                              value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _appLockEnabled =
                            !_appLockEnabled;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              SettingsSection(
                title: 'Data',
                children: [
                  SettingsTile(
                    icon: Icons.upload_file_rounded,
                    title: 'Export Data',
                    subtitle:
                        'Export your debt information',
                    iconColor:
                        AppColors.blue,
                    onTap: () {
                      _showComingSoon(
                        'Data export will be connected with the local database.',
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.download_rounded,
                    title: 'Import Data',
                    subtitle:
                        'Import supported records',
                    iconColor:
                        AppColors.blue,
                    onTap: () {
                      _showComingSoon(
                        'Data import will be connected later.',
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.backup_rounded,
                    title: 'Backup & Restore',
                    subtitle:
                        'Protect your local data',
                    iconColor:
                        AppColors.orange,
                    onTap: () {
                      _showComingSoon(
                        'Backup and restore will be added with persistence.',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.xxl,
              ),

              SettingsSection(
                title: 'Support',
                children: [
                  SettingsTile(
                    icon: Icons.help_rounded,
                    title: 'Help & Feedback',
                    iconColor:
                        AppColors.info,
                    onTap: () {
                      _showComingSoon(
                        'Help and feedback will be connected later.',
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.info_rounded,
                    title: 'About DebtPilot',
                    iconColor:
                        AppColors.primary,
                    showDivider: false,
                    onTap: _showAbout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          tooltip: 'Back',
        ),
        Expanded(
          child: Text(
            'Profile & Settings',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        const SizedBox(
          width: 48,
        ),
      ],
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight,
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ProfileAvatar(
                avatar: _avatar,
                size: 92,
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: _editAvatar,
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
            _userName,
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

          Text(
            'DebtPilot user',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color:
                      AppColors.textSecondary,
                ),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          OutlinedButton.icon(
            onPressed: _editName,
            icon: const Icon(
              Icons.edit_rounded,
              size: 17,
            ),
            label: const Text(
              'Edit Profile',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  AppColors.primary,
              side: const BorderSide(
                color: AppColors.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  AppSpacing.radiusMd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}