import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../screens/splash/widgets/aurora_glow_blob.dart';

/// Full-viewport Electric-Aurora "Coming Soon" placeholder used by feature
/// tabs that won't ship on day one (Deals, Loyalty). Aurora glow blobs in
/// the corners, a pulsing aurora orb with a feature icon, the feature name
/// as a kicker, a big aurora-gradient "Coming Soon" heading, and a short
/// tagline. Theme-aware, reads on both dark and light backgrounds.
class ComingSoonScreen extends StatefulWidget {
  /// All-caps feature kicker above the heading (e.g. "DEALS", "LOYALTY").
  final String featureName;

  /// One or two short sentences that tease what's coming.
  final String tagline;

  /// Icon shown inside the pulsing aurora orb.
  final FaIconData icon;

  /// Show a back button at the top-left (for pushed routes).
  final bool showBackButton;

  const ComingSoonScreen({
    super.key,
    required this.featureName,
    required this.tagline,
    required this.icon,
    this.showBackButton = false,
  });

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bgColor = isDark ? AppColors.auroraDeepBase : AppColors.white;
        final kickerColor = isDark
            ? AppColors.white.withValues(alpha: 0.55)
            : AppColors.primaryPurple.withValues(alpha: 0.70);
        final taglineColor = isDark
            ? AppColors.white.withValues(alpha: 0.70)
            : AppColors.primaryPurple.withValues(alpha: 0.80);
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final isRtl = Directionality.of(context) == TextDirection.rtl;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AuroraGlowBlob(
                  top: -100,
                  right: -80,
                  size: 360,
                  color: AppColors.auroraPink,
                  intensity: isDark ? 0.32 : 0.20,
                ),
                AuroraGlowBlob(
                  bottom: -100,
                  left: -80,
                  size: 380,
                  color: AppColors.auroraElectricBlue,
                  intensity: isDark ? 0.28 : 0.16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.showBackButton)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          4,
                          4,
                          16,
                          0,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: FaIcon(
                                  isRtl
                                      ? FontAwesomeIcons.arrowRight
                                      : FontAwesomeIcons.arrowLeft,
                                  size: 18,
                                  color: iconColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildPulsingOrb(),
                              const SizedBox(height: 36),
                              Text(
                                widget.featureName,
                                style: AppTextStyles.captionSmall.copyWith(
                                  color: kickerColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 4,
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: AppColors.auroraCartButtonGradient,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                blendMode: BlendMode.srcIn,
                                child: Text(
                                  'coming_soon_screen.coming_soon'.tr(),
                                  style: AppTextStyles.heading1.copyWith(
                                    color: AppColors.white,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    height: 1.0,
                                    decoration: TextDecoration.none,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                widget.tagline,
                                style: AppTextStyles.caption.copyWith(
                                  color: taglineColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulsingOrb() {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final t = _pulse.value;
        return Container(
          width: 110,
          height: 110,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.auroraPink.withValues(alpha: 0.55 + 0.25 * t),
                AppColors.auroraPurple.withValues(alpha: 0.30),
                const Color(0x00000000),
              ],
              stops: const [0.25, 0.65, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.auroraPink.withValues(alpha: 0.30 + 0.25 * t),
                blurRadius: 36 + 12 * t,
                spreadRadius: 6 + 4 * t,
              ),
              BoxShadow(
                color: AppColors.auroraElectricBlue.withValues(
                  alpha: 0.15 + 0.10 * t,
                ),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FaIcon(
            widget.icon,
            size: 36,
            color: AppColors.white,
          ),
        );
      },
    );
  }
}
