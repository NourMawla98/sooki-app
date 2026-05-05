import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/aurora/aurora_selectable_chip.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class EmailSupportScreen extends StatefulWidget {
  const EmailSupportScreen({super.key});

  @override
  State<EmailSupportScreen> createState() => _EmailSupportScreenState();
}

class _EmailSupportScreenState extends State<EmailSupportScreen> {
  String _selectedCategory = 'Order Issue';
  final _subjectController = TextEditingController();
  final _orderController = TextEditingController();
  final _messageController = TextEditingController();

  static const _categories = ['Order Issue', 'Payment', 'Account', 'Other'];

  @override
  void dispose() {
    _subjectController.dispose();
    _orderController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_subjectController.text.trim().isEmpty) {
      ToastService.instance.showError('Please enter a subject');
      return;
    }
    if (_messageController.text.trim().isEmpty) {
      ToastService.instance.showError('Please enter a message');
      return;
    }
    ToastService.instance.showSuccess('Support ticket submitted');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -80, right: -80,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -80, left: -80,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(isDark: isDark),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Response time notice
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.auroraElectricBlue.withValues(alpha: 0.08)
                                    : AppColors.auroraElectricBlue.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.auroraElectricBlue.withValues(alpha: isDark ? 0.18 : 0.14),
                                ),
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.clock,
                                    size: 13,
                                    color: AppColors.auroraElectricBlue.withValues(alpha: 0.70),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'We typically reply within a few hours during business days.',
                                      style: AppTextStyles.captionSmall.copyWith(
                                        color: isDark
                                            ? AppColors.auroraElectricBlue.withValues(alpha: 0.80)
                                            : AppColors.auroraElectricBlue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            _SectionLabel(label: 'Category', isDark: isDark),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _categories
                                  .map((cat) => AuroraSelectableChip(
                                        label: cat,
                                        isSelected: _selectedCategory == cat,
                                        onTap: () => setState(() => _selectedCategory = cat),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),

                            _SectionLabel(label: 'Your Message', isDark: isDark),
                            const SizedBox(height: 10),
                            AuroraInputField(
                              label: 'Subject',
                              hint: 'Brief description of your issue',
                              controller: _subjectController,
                              prefixIcon: FontAwesomeIcons.pen,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                            AuroraInputField(
                              label: 'Order Number (optional)',
                              hint: '#ORD-XXXX',
                              controller: _orderController,
                              prefixIcon: FontAwesomeIcons.hashtag,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                            AuroraInputField(
                              label: 'Message',
                              hint: 'Describe your issue in detail...',
                              controller: _messageController,
                              maxLines: 6,
                              textInputAction: TextInputAction.newline,
                            ),
                            const SizedBox(height: 28),

                            AuroraPrimaryButton(
                              text: 'Send Message',
                              onPressed: _submit,
                            ),
                          ],
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
            'Email Support',
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
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.dsSectionLabel.copyWith(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.28)
            : AppColors.auroraPurple.withValues(alpha: 0.45),
        letterSpacing: 1.8,
      ),
    );
  }
}
