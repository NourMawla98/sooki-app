import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/ui/screens/product_detail/widgets/size_guide_data.dart';

// Arabic display values the backend returns, kept as escapes so the file stays
// plain ASCII: "0-3 months" and "14-16 years".
const String _arMonths0To3 = '\u0660-\u0663 \u0623\u0634\u0647\u0631';
const String _arYears14To16 = '\u0661\u0664-\u0661\u0666 \u0633\u0646\u0629';

/// Multiplication sign, which the bed standard uses between its dimensions.
const String _times = '\u00d7';

/// The backend keeps a language-neutral code per size value but returns only
/// the translated display value, so the guide has to recognise a row from the
/// translated text. These are the values the seeded standards return.
final Map<String, Map<String, String>> _displayToRow = {
  'baby_sizes': {
    '0-3 Months': '0-3M',
    '0-3 Mois': '0-3M',
    _arMonths0To3: '0-3M',
    '18-24 Months': '18-24M',
  },
  'kids_sizes': {
    '8-10 Years': '8-10Y',
    '10-12 Ans': '10-12Y',
    _arYears14To16: '14-16Y',
  },
  'bed_sizes': {'90 $_times 200 cm': '90x200', '160 $_times 200 cm': '160x200'},
  'belt_size': {'70 cm': '70 cm', '130 cm': '130 cm'},
};

int _matchingRows(String slug, String displayValue) {
  final rows = kSizeGuides[slug]!.rowsIn;
  final exact = rows.indexWhere((row) => row[0] == displayValue);
  if (exact != -1) return 1;
  final key = sizeMatchKey(displayValue);
  if (key.isEmpty) return 0;
  return rows.where((row) => sizeMatchKey(row[0]) == key).length;
}

String? _matchedRow(String slug, String displayValue) {
  final rows = kSizeGuides[slug]!.rowsIn;
  final exact = rows.indexWhere((row) => row[0] == displayValue);
  if (exact != -1) return rows[exact][0];
  final key = sizeMatchKey(displayValue);
  if (key.isEmpty) return null;
  for (final row in rows) {
    if (sizeMatchKey(row[0]) == key) return row[0];
  }
  return null;
}

void main() {
  group('sizeMatchKey', () {
    test('keeps digits and separators, drops words and units', () {
      expect(sizeMatchKey('0-3 Months'), '0-3');
      expect(sizeMatchKey('70 cm'), '70');
      expect(sizeMatchKey('90 $_times 200 cm'), '90x200');
      expect(sizeMatchKey('90x200'), '90x200');
    });

    test('reads Arabic-Indic digits as western ones', () {
      expect(sizeMatchKey(_arMonths0To3), '0-3');
      expect(sizeMatchKey(_arYears14To16), '14-16');
    });

    test('is empty for a label with no digits', () {
      expect(sizeMatchKey('M'), '');
      expect(sizeMatchKey('NB'), '');
    });
  });

  group('translated display values resolve to one guide row', () {
    _displayToRow.forEach((slug, cases) {
      cases.forEach((displayValue, expectedRow) {
        test('$slug: $displayValue', () {
          expect(_matchingRows(slug, displayValue), 1);
          expect(_matchedRow(slug, displayValue), expectedRow);
        });
      });
    });
  });

  group('every guide row is distinguishable', () {
    kSizeGuides.forEach((slug, content) {
      test(slug, () {
        final keys = <String>[];
        for (final row in content.rowsIn) {
          final key = sizeMatchKey(row[0]);
          if (key.isEmpty) continue;
          expect(
            keys,
            isNot(contains(key)),
            reason: 'two rows in $slug reduce to "$key"',
          );
          keys.add(key);
        }
      });
    });
  });
}
