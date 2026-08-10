import 'package:easy_localization/easy_localization.dart';

/// Customer report categories. Mirrors backend `ReportCategoryEnum`:
/// 1=Bug, 2=PaymentIssue, 3=OrderIssue, 4=Account, 5=Suggestion, 6=Other.
enum ReportCategory {
  bug(backendValue: 1),
  payment(backendValue: 2),
  orderIssue(backendValue: 3),
  account(backendValue: 4),
  suggestion(backendValue: 5),
  other(backendValue: 6);

  const ReportCategory({required this.backendValue});

  /// Backend enum value sent in the create-report request.
  final int backendValue;

  /// Chip display label (localized).
  String get label {
    switch (this) {
      case bug:        return 'enums.report_category.bug'.tr();
      case payment:    return 'enums.report_category.payment'.tr();
      case orderIssue: return 'enums.report_category.order_issue'.tr();
      case account:    return 'enums.report_category.account'.tr();
      case suggestion: return 'enums.report_category.suggestion'.tr();
      case other:      return 'enums.report_category.other'.tr();
    }
  }
}
