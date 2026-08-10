import 'package:easy_localization/easy_localization.dart';

/// Preset labels offered when saving an address. The value persisted to the
/// backend is always the English [storageValue] so the record stays readable
/// whatever language the customer used; the UI translates it back for display.
enum AddressLabelType {
  home(storageValue: 'Home', labelKey: 'label_chooser.home'),
  office(storageValue: 'Office', labelKey: 'label_chooser.office'),
  other(storageValue: 'Other', labelKey: 'label_chooser.other');

  const AddressLabelType({required this.storageValue, required this.labelKey});

  final String storageValue;
  final String labelKey;

  String get label => labelKey.tr();

  /// Matches a stored label back to a preset. 'Work' is accepted for older
  /// records that used it for the office preset. Returns null for custom labels.
  static AddressLabelType? fromStorageValue(String? value) {
    final raw = value?.trim().toLowerCase();
    if (raw == null || raw.isEmpty) return null;
    if (raw == 'home') return home;
    if (raw == 'office' || raw == 'work') return office;
    if (raw == 'other') return other;
    return null;
  }
}

/// Display form of a stored address label: presets are translated, custom
/// labels are shown exactly as the customer typed them.
String localizedAddressLabel(String? storedLabel) =>
    AddressLabelType.fromStorageValue(storedLabel)?.label ??
    (storedLabel ?? '');
