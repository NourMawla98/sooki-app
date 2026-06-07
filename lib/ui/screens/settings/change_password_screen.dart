import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/profile_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await serviceLocator<ProfileApi>().changePassword(
      currentPassword: _currentCtrl.text,
      newPassword: _newCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      (_) {},
      (message) {
        if (message.isNotEmpty) ToastService.instance.showSuccess(message);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -80,
                right: -80,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -80,
                left: -80,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(isDark: isDark),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionLabel(
                                label: 'Current password',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 8),
                              AuroraInputField(
                                controller: _currentCtrl,
                                hint: 'Enter current password',
                                isPassword: true,
                                prefixIcon: FontAwesomeIcons.lock,
                                textInputAction: TextInputAction.next,
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              _SectionLabel(
                                label: 'New password',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 8),
                              AuroraInputField(
                                controller: _newCtrl,
                                hint: 'Enter new password',
                                isPassword: true,
                                prefixIcon: FontAwesomeIcons.lockOpen,
                                textInputAction: TextInputAction.next,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Required';
                                  }
                                  if (v.length < 8) {
                                    return 'At least 8 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _SectionLabel(
                                label: 'Confirm new password',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 8),
                              AuroraInputField(
                                controller: _confirmCtrl,
                                hint: 'Re-enter new password',
                                isPassword: true,
                                prefixIcon: FontAwesomeIcons.lockOpen,
                                textInputAction: TextInputAction.done,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Required';
                                  }
                                  if (v != _newCtrl.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),
                              AuroraPrimaryButton(
                                text: 'Update Password',
                                onPressed: _submit,
                                isLoading: _loading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final bool isDark;
  const _TopBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.white : AppColors.auroraPurple;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 20, color: color),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Text(
            'Change Password',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        label,
        style: AppTextStyles.dsFieldLabel.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.55)
              : AppColors.auroraPurple,
        ),
      ),
    );
  }
}
