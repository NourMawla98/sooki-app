/// Customer report categories. Mirrors backend `ReportCategoryEnum`:
/// 1=Bug, 2=PaymentIssue, 3=OrderIssue, 4=Account, 5=Suggestion, 6=Other.
enum ReportCategory {
  bug(backendValue: 1, label: 'Bug'),
  payment(backendValue: 2, label: 'Payment'),
  orderIssue(backendValue: 3, label: 'Order Issue'),
  account(backendValue: 4, label: 'Account'),
  suggestion(backendValue: 5, label: 'Suggestion'),
  other(backendValue: 6, label: 'Other');

  const ReportCategory({required this.backendValue, required this.label});

  /// Backend enum value sent in the create-report request.
  final int backendValue;

  /// Chip display label.
  final String label;
}
