import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../models/delivery_address.dart';
import '../../../routes/route_constants.dart';
import '../../../services/address_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/dialogs/aurora_confirm_sheet.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ThemeService.instance,
        GetIt.instance<AddressService>(),
      ]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final service = GetIt.instance<AddressService>();
        final addresses = service.addresses;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -100, right: -100, size: 260,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -100, left: -100, size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.auroraPurple,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Addresses',
                            style: AppTextStyles.dsH2.copyWith(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.auroraPurple,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: addresses.isEmpty
                          ? _EmptyState(isDark: isDark)
                          : _AddressList(
                              addresses: addresses,
                              isDark: isDark,
                            ),
                    ),
                  ],
                ),
              ),

              // Sticky add button
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _StickyAddButton(isDark: isDark, isEmpty: addresses.isEmpty),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Address list ────────────────────────────────────────────────────────────

class _AddressList extends StatelessWidget {
  final List<DeliveryAddress> addresses;
  final bool isDark;

  const _AddressList({required this.addresses, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      itemCount: addresses.length,
      separatorBuilder: (context, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _AddressCard(
        address: addresses[i],
        isDark: isDark,
      ),
    );
  }
}

// ─── Address card ────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  final DeliveryAddress address;
  final bool isDark;

  const _AddressCard({required this.address, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final borderColor = address.isDefault
        ? AppColors.auroraPurple.withValues(alpha: isDark ? 0.45 : 0.38)
        : isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.10);

    final cardBg = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.white;

    final shadow = isDark
        ? null
        : [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ];

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        editAddressScreenRoute,
        arguments: address,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: shadow,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 42, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label + default badge
                  Row(
                    children: [
                      Text(
                        address.label,
                        style: AppTextStyles.dsBody.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        _DefaultBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Address line
                  Text(
                    address.line,
                    style: AppTextStyles.dsBody.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.45)
                          : AppColors.auroraPurple.withValues(alpha: 0.55),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // Phone
                  Text(
                    address.phone,
                    style: AppTextStyles.dsBody.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.30)
                          : AppColors.auroraPurple.withValues(alpha: 0.38),
                    ),
                  ),
                ],
              ),
            ),

            // X delete button
            Positioned(
              top: 8, right: 8,
              child: _DeleteButton(address: address, isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Default badge ───────────────────────────────────────────────────────────

class _DefaultBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.auroraCartButtonGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Default',
        style: AppTextStyles.caption.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 0.3,
          height: 1.0,
        ),
      ),
    );
  }
}

// ─── Delete button ───────────────────────────────────────────────────────────

class _DeleteButton extends StatelessWidget {
  final DeliveryAddress address;
  final bool isDark;

  const _DeleteButton({required this.address, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showAuroraConfirmSheet(
        context,
        title: 'Delete "${address.label}"?',
        subtitle: 'This address will be permanently removed from your saved locations.',
        icon: FontAwesomeIcons.trash,
        confirmLabel: 'Delete',
        onConfirm: () => GetIt.instance<AddressService>().remove(address.id),
      ),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.xmark,
            size: 12,
            color: isDark
                ? AppColors.white.withValues(alpha: 0.25)
                : AppColors.auroraPurple.withValues(alpha: 0.28),
          ),
        ),
      ),
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.locationDot,
              size: 52,
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.10)
                  : AppColors.auroraPurple.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 16),
            Text(
              'No saved addresses',
              style: AppTextStyles.dsH2.copyWith(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.65)
                    : AppColors.auroraDeepBase.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your home, work or any delivery spot and we\'ll remember it.',
              textAlign: TextAlign.center,
              style: AppTextStyles.dsBody.copyWith(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.30)
                    : AppColors.auroraPurple.withValues(alpha: 0.40),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sticky add button ───────────────────────────────────────────────────────

class _StickyAddButton extends StatelessWidget {
  final bool isDark;
  final bool isEmpty;
  const _StickyAddButton({required this.isDark, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase)
                .withValues(alpha: 0),
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          ],
          stops: const [0.0, 0.45],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: SafeArea(
        top: false,
        child: AuroraPrimaryButton(
          text: isEmpty ? 'Add your first address' : 'Add new address',
          onPressed: () =>
              Navigator.pushNamed(context, addAddressScreenRoute),
        ),
      ),
    );
  }
}
