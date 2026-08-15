import 'package:easy_localization/easy_localization.dart';

import 'number_localization.dart';

/// Renders a date the way the active locale expects: a translated short month
/// name and digits in the locale's numeral system.
String localizedLongDate(DateTime dt) => 'time.long_date'.tr(namedArgs: {
      'day': localizedNumber(dt.day),
      'month': 'time.month_short.${dt.month}'.tr(),
      'year': localizedNumber(dt.year),
    });
