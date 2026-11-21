import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/app_version.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';

/// Opens the store page for an update. Swappable so tests do not leave the app.
typedef StoreOpener = Future<void> Function(String url);

Future<void> openStoreUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || url.isEmpty) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Covers the whole app while this build is below the minimum supported
/// version. Nothing behind it can be reached, back does not leave it, and its
/// one button opens the store.
class UpdateRequiredScreen extends StatelessWidget {
  final AppVersionConfig config;
  final StoreOpener onOpenStore;

  const UpdateRequiredScreen({
    super.key,
    required this.config,
    this.onOpenStore = openStoreUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final muted = isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
    final message = config.message;

    return PopScope(
      canPop: false,
      child: Material(
        color: isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.auroraPurple.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.rocket,
                      size: 40,
                      color: AppColors.auroraPurple,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'app_update.title'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3.copyWith(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message ?? 'app_update.body'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: muted,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuroraPrimaryButton(
                    text: 'app_update.button'.tr(),
                    onPressed: config.storeUrl.isEmpty
                        ? null
                        : () => onOpenStore(config.storeUrl),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
