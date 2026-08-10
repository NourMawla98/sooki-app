import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/apis/reports_api.dart';
import '../../../enums/report_category.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/aurora/aurora_selectable_chip.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../cart/widgets/aurora_login_gate_dialog.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class EmailSupportScreen extends StatefulWidget {
  const EmailSupportScreen({super.key});

  @override
  State<EmailSupportScreen> createState() => _EmailSupportScreenState();
}

class _EmailSupportScreenState extends State<EmailSupportScreen> {
  ReportCategory _selectedCategory = ReportCategory.orderIssue;
  final _subjectController = TextEditingController();
  final _orderController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;

  // Subset shown here; backend also supports Bug & Suggestion.
  static const _categories = [
    ReportCategory.orderIssue,
    ReportCategory.payment,
    ReportCategory.account,
    ReportCategory.other,
  ];

  // Backend limits (subject 150, description 2000).
  static const int _subjectMax = 150;
  static const int _descriptionMax = 2000;

  @override
  void dispose() {
    _subjectController.dispose();
    _orderController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;

    // Reports are customer-only on the backend.
    if (!GetIt.instance<AuthService>().isCustomer) {
      showAuroraLoginGate(context);
      return;
    }

    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    if (subject.isEmpty) {
      ToastService.instance.showError('email_support_screen.enter_subject_error'.tr());
      return;
    }
    if (message.isEmpty) {
      ToastService.instance.showError('email_support_screen.enter_message_error'.tr());
      return;
    }
    if (subject.length > _subjectMax) {
      ToastService.instance.showError(
        'email_support_screen.subject_too_long_error'
            .tr(namedArgs: {'max': localizedNumber(_subjectMax)}),
      );
      return;
    }

    // Backend has no order field — fold it into the description when provided.
    final order = _orderController.text.trim();
    final description = order.isEmpty ? message : 'Order: $order\n\n$message';
    if (description.length > _descriptionMax) {
      ToastService.instance.showError('email_support_screen.message_too_long_error'.tr());
      return;
    }

    setState(() => _submitting = true);
    final result = await GetIt.instance<ReportsApi>().createReport(
      category: _selectedCategory.backendValue,
      subject: subject,
      description: description,
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (_) {}, // ErrorInterceptor already toasts the failure.
      (responseMessage) {
        if (responseMessage.isNotEmpty) {
          ToastService.instance.showSuccess(responseMessage);
        }
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
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 32),
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
                                      'email_support_screen.reply_notice'.tr(),
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

                            _SectionLabel(label: 'email_support_screen.category_label'.tr(), isDark: isDark),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _categories
                                  .map((cat) => AuroraSelectableChip(
                                        label: cat.label,
                                        isSelected: _selectedCategory == cat,
                                        onTap: () => setState(() => _selectedCategory = cat),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),

                            _SectionLabel(label: 'email_support_screen.your_message_label'.tr(), isDark: isDark),
                            const SizedBox(height: 10),
                            AuroraInputField(
                              label: 'email_support_screen.subject_field_label'.tr(),
                              hint: 'email_support_screen.subject_field_hint'.tr(),
                              controller: _subjectController,
                              prefixIcon: FontAwesomeIcons.pen,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                            AuroraInputField(
                              label: 'email_support_screen.order_number_label'.tr(),
                              hint: '#ORD-XXXX',
                              controller: _orderController,
                              prefixIcon: FontAwesomeIcons.hashtag,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                            AuroraInputField(
                              label: 'email_support_screen.message_field_label'.tr(),
                              hint: 'email_support_screen.message_field_hint'.tr(),
                              controller: _messageController,
                              maxLines: 6,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                            ),
                            const SizedBox(height: 28),

                            AuroraPrimaryButton(
                              text: 'email_support_screen.send_message_button'.tr(),
                              isLoading: _submitting,
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(
              isRtl ? FontAwesomeIcons.arrowRight : FontAwesomeIcons.arrowLeft,
              size: 20,
              color: color,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Text(
            'email_support_screen.title'.tr(),
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
