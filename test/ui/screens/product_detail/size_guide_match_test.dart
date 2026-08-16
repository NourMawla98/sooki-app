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

/// Codes the backend now sends alongside the display value, per standard.
final Map<String, List<String>> _codes = {
  'international_letter': ['XS', 'M', '3XL'],
  'womens_apparel': ['38', '48'],
  'kids_shoes': ['17', '35'],
  'baby_sizes': ['NB', '0-3M', '18-24M'],
  'kids_sizes': ['3-4Y', '8-10Y', '10-12Y', '14-16Y'],
  'ring_sizes': ['44', '70'],
  'bed_sizes': ['90x200', '160x200'],
};

String? _matchedRow(String slug, {String? code, String? label}) {
  final rows = kSizeGuides[slug]!.rowsIn;
  final index = sizeGuideRowIndex(rows, code: code, label: label);
  return index == -1 ? null : rows[index][0];
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

  group('the size code picks its own row', () {
    _codes.forEach((slug, codes) {
      for (final code in codes) {
        test('$slug: $code', () {
          expect(_matchedRow(slug, code: code), code);
        });
      }
    });

    test('a code the guide does not list falls through to the label', () {
      expect(
        _matchedRow('kids_sizes', code: '20-22Y', label: '8-10 Years'),
        '8-10Y',
      );
    });

    test('an empty code falls through to the label', () {
      expect(_matchedRow('baby_sizes', code: '', label: '0-3 Mois'), '0-3M');
    });
  });

  group('translated display values resolve to one guide row', () {
    _displayToRow.forEach((slug, cases) {
      cases.forEach((displayValue, expectedRow) {
        test('$slug: $displayValue', () {
          expect(_matchedRow(slug, label: displayValue), expectedRow);
        });
      });
    });

    test('nothing matches when neither a code nor a label is given', () {
      expect(_matchedRow('kids_sizes'), isNull);
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
