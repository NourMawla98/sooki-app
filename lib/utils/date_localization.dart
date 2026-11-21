import 'package:easy_localization/easy_localization.dart';

import 'number_localization.dart';

/// Renders a date the way the active locale expects: a translated short month
/// name and digits in the locale's numeral system. A UTC time is shown on the
/// device's own calendar day, so an evening order is not dated tomorrow or
/// yesterday.
String localizedLongDate(DateTime dt) {
  final local = dt.toLocal();
  return 'time.long_date'.tr(namedArgs: {
    'day': localizedNumber(local.day),
    'month': 'time.month_short.${local.month}'.tr(),
    'year': localizedNumber(local.year),
  });
}
