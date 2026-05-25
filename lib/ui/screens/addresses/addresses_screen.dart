import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/dtos/address/address_dto.dart';
import '../../../routes/route_constants.dart';
import '../../../services/address_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../reusable_components/skeleton/skeleton_shimmer.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/dialogs/aurora_confirm_sheet.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await GetIt.instance<AddressService>().loadFromServer();
    if (mounted) setState(() => _loading = false);
  }

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
          backgroundColor: isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              size: 18,
                              color: isDark ? AppColors.white : AppColors.auroraPurple,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Addresses',
                            style: AppTextStyles.dsH2.copyWith(
                              color: isDark ? AppColors.white : AppColors.auroraPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _loading
                          ? _AddressSkeleton(isDark: isDark)
                          : RefreshIndicator(
                              onRefresh: _load,
                              child: addresses.isEmpty
                                  ? _EmptyState(isDark: isDark)
                                  : _AddressList(addresses: addresses, isDark: isDark),
                            ),
                    ),
                  ],
                ),
              ),
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

class _AddressSkeleton extends StatelessWidget {
  final bool isDark;
  const _AddressSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => _AddressCardSkeleton(isDark: isDark),
    );
  }
}

class _AddressCardSkeleton extends StatelessWidget {
  final bool isDark;
  const _AddressCardSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.white.withValues(alpha: 0.04) : AppColors.white;
    final borderColor = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.10);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 13,
            width: 100,
            child: SkeletonShimmer(borderRadius: BorderRadius.circular(6)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 11,
            width: 160,
            child: SkeletonShimmer(borderRadius: BorderRadius.circular(5)),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 11,
            width: 120,
            child: SkeletonShimmer(borderRadius: BorderRadius.circular(5)),
          ),
        ],
      ),
    );
  }
}

class _AddressList extends StatelessWidget {
  final List<AddressDto> addresses;
  final bool isDark;

  const _AddressList({required this.addresses, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      itemCount: addresses.length,
      separatorBuilder: (context, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _AddressCard(address: addresses[i], isDark: isDark),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressDto address;
  final bool isDark;

  const _AddressCard({required this.address, required this.isDark});

  String get _locationLine {
    final parts = <String>[address.city.name];
    if (address.area != null) parts.add(address.area!.name);
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = address.isDefault
        ? AppColors.auroraPurple.withValues(alpha: isDark ? 0.45 : 0.38)
        : isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.10);

    final cardBg = isDark ? AppColors.white.withValues(alpha: 0.04) : AppColors.white;

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
      onTap: () => Navigator.pushNamed(context, editAddressScreenRoute, arguments: address),
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
                  Row(
                    children: [
                      Text(
                        address.label ?? '',
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
                  const SizedBox(height: 4),
                  Text(
                    address.fullName,
                    style: AppTextStyles.dsBody.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.55)
                          : AppColors.auroraDeepBase.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _locationLine,
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
                  if (!address.isDefault) ...[
                    const SizedBox(height: 8),
                    _SetDefaultButton(address: address),
                  ],
                ],
              ),
            ),
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

class _SetDefaultButton extends StatelessWidget {
  final AddressDto address;
  const _SetDefaultButton({required this.address});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final msg = await GetIt.instance<AddressService>().setDefault(address.id);
        if (msg.isNotEmpty) ToastService.instance.showSuccess(msg);
      },
      child: Text(
        'Set as default',
        style: AppTextStyles.caption.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.auroraPurple,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final AddressDto address;
  final bool isDark;

  const _DeleteButton({required this.address, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final confirmed = await showAuroraConfirmSheet(
          context,
          title: 'Delete "${address.label ?? 'address'}"?',
          subtitle: 'This address will be permanently removed from your saved locations.',
          icon: FontAwesomeIcons.trash,
          confirmLabel: 'Delete',
        );
        if (confirmed) {
          final msg = await GetIt.instance<AddressService>().deleteAddress(address.id);
          if (msg.isNotEmpty) ToastService.instance.showSuccess(msg);
        }
      },
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

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
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
        ),
      ],
    );
  }
}

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
            (isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase).withValues(alpha: 0),
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
          onPressed: () => Navigator.pushNamed(context, addAddressScreenRoute),
        ),
      ),
    );
  }
}
