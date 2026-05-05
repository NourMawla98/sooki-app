import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/user_profile_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../../reusable_components/input_fields/aurora_phone_field.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = GetIt.instance<UserProfileService>();
    _firstNameCtrl = TextEditingController(text: profile.firstName);
    _lastNameCtrl  = TextEditingController(text: profile.lastName);
    _emailCtrl     = TextEditingController(text: profile.email);
    _phoneCtrl     = TextEditingController(text: profile.phone);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await GetIt.instance<UserProfileService>().save(
      firstName: _firstNameCtrl.text.trim(),
      lastName:  _lastNameCtrl.text.trim(),
      email:     _emailCtrl.text.trim(),
      phone:     _phoneCtrl.text.trim(),
    );
    setState(() => _saving = false);
    if (mounted) {
      ToastService.instance.showSuccess('Profile updated');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final iconColor =
            isDark ? AppColors.white : AppColors.auroraPurple;
        final titleColor =
            isDark ? AppColors.white : AppColors.auroraDeepBase;

        return Scaffold(
          backgroundColor: bg,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -100,
                right: -100,
                size: 280,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.18 : 0.08,
              ),
              AuroraGlowBlob(
                bottom: -100,
                left: -100,
                size: 300,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.16 : 0.07,
              ),
              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              size: 18,
                              color: iconColor,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Edit Profile',
                            style: AppTextStyles.heading3.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar preview
                              Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: AppColors.auroraGradient,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(2.5),
                                  child: ListenableBuilder(
                                    listenable: GetIt.instance<
                                        UserProfileService>(),
                                    builder: (context, _) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark
                                              ? AppColors.auroraDeepBase
                                              : AppColors.white,
                                        ),
                                        child: Center(
                                          child: ShaderMask(
                                            shaderCallback: (bounds) =>
                                                const LinearGradient(
                                              colors: AppColors.auroraGradient,
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(Rect.fromLTWH(
                                                0,
                                                0,
                                                bounds.width,
                                                bounds.height)),
                                            blendMode: BlendMode.srcIn,
                                            child: Text(
                                              GetIt.instance<
                                                      UserProfileService>()
                                                  .initials,
                                              style:
                                                  AppTextStyles.dsCTA.copyWith(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _SectionLabel(label: 'First name', isDark: isDark),
                                        const SizedBox(height: 8),
                                        AuroraInputField(
                                          controller: _firstNameCtrl,
                                          hint: 'Jane',
                                          prefixIcon: FontAwesomeIcons.user,
                                          textInputAction: TextInputAction.next,
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _SectionLabel(label: 'Last name', isDark: isDark),
                                        const SizedBox(height: 8),
                                        AuroraInputField(
                                          controller: _lastNameCtrl,
                                          hint: 'Doe',
                                          prefixIcon: FontAwesomeIcons.user,
                                          textInputAction: TextInputAction.next,
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              _SectionLabel(
                                  label: 'Email Address', isDark: isDark),
                              const SizedBox(height: 8),
                              AuroraInputField(
                                controller: _emailCtrl,
                                hint: 'your@email.com',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: FontAwesomeIcons.envelope,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Email is required'
                                        : null,
                              ),

                              const SizedBox(height: 20),

                              _SectionLabel(
                                  label: 'Phone Number', isDark: isDark),
                              const SizedBox(height: 8),
                              AuroraPhoneField(
                                controller: _phoneCtrl,
                              ),

                              const SizedBox(height: 36),

                              AuroraPrimaryButton(
                                text: 'SAVE CHANGES',
                                isLoading: _saving,
                                onPressed: _save,
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

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.dsFieldLabel.copyWith(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.55)
            : AppColors.auroraPurple,
      ),
    );
  }
}
