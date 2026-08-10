// Static size guide content, keyed by a language-neutral slug.
// ONE_SIZE / Canvas Size / Paper Size are intentionally absent - button is hidden for them.
//
// The backend returns standardName already translated, so it can never be a map
// key. `sizeGuideFor` matches it against the localized name of each slug, held
// in the translations under `size_guide.standard_name.<slug>`.
//
// Text fields (subtitle, howToMeasure, columns) hold translation keys, resolved
// with .tr() by the sheet. Row cells are raw values except the ones prefixed
// with `size_guide.`, which are translated the same way - see `isSizeGuideKey`.
// Size labels (first column) are never translated: they are matched against the
// size the customer picked on the product.

import 'package:easy_localization/easy_localization.dart';

enum SizeGuideType { table, bra, bed }

/// Prefix that marks a row cell as a translation key rather than raw data.
const String _keyPrefix = 'size_guide.';

/// True when a row cell is a translation key rather than raw data. Everything
/// else (measurements, size labels) is rendered as-is.
bool isSizeGuideKey(String value) => value.startsWith(_keyPrefix);

class SizeGuideContent {
  const SizeGuideContent({
    required this.type,
    required this.subtitle,
    this.howToMeasure,
    this.hasUnitToggle = false,
    this.columns = const [],
    this.rowsIn = const [],
    this.rowsCm,
  });

  final SizeGuideType type;

  /// Translation key.
  final String subtitle;

  /// Translation key.
  final String? howToMeasure;
  final bool hasUnitToggle; // IN/CM toggle - only for body-measurement standards
  /// Translation keys.
  final List<String> columns;
  final List<List<String>> rowsIn; // primary (inches when toggle present, otherwise cm/mm)
  final List<List<String>>? rowsCm; // alternate (cm) - only when hasUnitToggle=true
}

/// Guide for the standard the backend reported, or null when that standard has
/// no guide (One Size, Canvas Size, Paper Size) or the name is unknown.
SizeGuideContent? sizeGuideFor(String? standardName) {
  final name = standardName?.trim().toLowerCase();
  if (name == null || name.isEmpty) return null;
  for (final entry in kSizeGuides.entries) {
    final localized =
        'size_guide.standard_name.${entry.key}'.tr().trim().toLowerCase();
    if (localized == name) return entry.value;
  }
  return null;
}

// Key = language-neutral slug, matched to the backend name by [sizeGuideFor].
const Map<String, SizeGuideContent> kSizeGuides = {
  'international_letter': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'size_guide.international_letter.subtitle',
    howToMeasure: 'size_guide.how_to_measure.body',
    hasUnitToggle: true,
    columns: [
      'size_guide.column.size',
      'size_guide.column.chest',
      'size_guide.column.waist',
      'size_guide.column.hip',
    ],
    rowsIn: [
      ['XS', '31-33"', '23-25"', '33-35"'],
      ['S', '34-36"', '26-28"', '36-38"'],
      ['M', '37-39"', '29-31"', '39-41"'],
      ['L', '40-42"', '32-34"', '42-44"'],
      ['XL', '43-45"', '35-37"', '45-47"'],
      ['2XL', '46-48"', '38-40"', '48-50"'],
      ['3XL', '49-51"', '41-44"', '51-54"'],
      ['4XL', '52-54"', '45-48"', '55-58"'],
      ['5XL', '55-58"', '49-52"', '59-63"'],
    ],
    rowsCm: [
      ['XS', '79-84', '58-64', '84-89'],
      ['S', '86-91', '66-71', '91-97'],
      ['M', '94-99', '74-79', '99-104'],
      ['L', '102-107', '81-86', '107-112'],
      ['XL', '109-114', '89-94', '114-119'],
      ['2XL', '117-122', '97-102', '122-127'],
      ['3XL', '124-130', '104-112', '130-137'],
      ['4XL', '132-137', '114-122', '140-147'],
      ['5XL', '140-147', '124-132', '150-160'],
    ],
  ),

  'womens_apparel': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'size_guide.womens_apparel.subtitle',
    howToMeasure: 'size_guide.how_to_measure.body',
    columns: [
      'size_guide.column.eu',
      'size_guide.column.chest_cm',
      'size_guide.column.waist_cm',
      'size_guide.column.hip_cm',
    ],
    rowsIn: [
      ['32', '77-79', '59-61', '82-84'],
      ['34', '80-82', '62-64', '85-87'],
      ['36', '83-86', '65-68', '88-91'],
      ['38', '87-90', '69-72', '92-95'],
      ['40', '91-94', '73-76', '96-99'],
      ['42', '95-98', '77-80', '100-103'],
      ['44', '99-102', '81-84', '104-107'],
      ['46', '103-107', '85-89', '108-112'],
      ['48', '108-112', '90-94', '113-117'],
      ['50', '113-117', '95-99', '118-122'],
      ['52', '118-122', '100-104', '123-127'],
    ],
  ),

  'kids_shoes': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'size_guide.kids_shoes.subtitle',
    howToMeasure: 'size_guide.how_to_measure.kids_shoes',
    columns: [
      'size_guide.column.eu',
      'size_guide.column.foot_cm',
      'size_guide.column.age_approx',
    ],
    rowsIn: [
      ['17', '10.5', 'size_guide.age.months_0_6'],
      ['18', '11.0', 'size_guide.age.months_6_9'],
      ['19', '11.7', 'size_guide.age.months_9_12'],
      ['20', '12.4', 'size_guide.age.months_12_18'],
      ['21', '13.0', 'size_guide.age.months_18_24'],
      ['22', '13.7', 'size_guide.age.years_2'],
      ['23', '14.4', 'size_guide.age.years_2_3'],
      ['24', '15.0', 'size_guide.age.years_3'],
      ['25', '15.7', 'size_guide.age.years_3_4'],
      ['26', '16.4', 'size_guide.age.years_4'],
      ['27', '17.1', 'size_guide.age.years_4_5'],
      ['28', '17.7', 'size_guide.age.years_5'],
      ['29', '18.4', 'size_guide.age.years_5_6'],
      ['30', '19.0', 'size_guide.age.years_6_7'],
      ['31', '19.7', 'size_guide.age.years_7_8'],
      ['32', '20.4', 'size_guide.age.years_8_9'],
      ['33', '21.1', 'size_guide.age.years_9_10'],
      ['34', '21.7', 'size_guide.age.years_10_11'],
      ['35', '22.4', 'size_guide.age.years_11_12'],
    ],
  ),

  'baby_sizes': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'size_guide.baby_sizes.subtitle',
    howToMeasure: 'size_guide.how_to_measure.baby',
    columns: [
      'size_guide.column.size',
      'size_guide.column.age',
      'size_guide.column.weight_kg',
      'size_guide.column.height_cm',
    ],
    rowsIn: [
      ['NB', 'size_guide.age.newborn', '0-3.5', '50'],
      ['0-3M', 'size_guide.age.months_0_3', '3.5-6', '56'],
      ['3-6M', 'size_guide.age.months_3_6', '6-8', '62'],
      ['6-9M', 'size_guide.age.months_6_9', '8-10', '68'],
      ['9-12M', 'size_guide.age.months_9_12', '10-11', '74'],
      ['12-18M', 'size_guide.age.months_12_18', '11-12.5', '80'],
      ['18-24M', 'size_guide.age.months_18_24', '12.5-14', '86'],
    ],
  ),

  'kids_sizes': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'size_guide.kids_sizes.subtitle',
    howToMeasure: 'size_guide.how_to_measure.kids_height',
    columns: [
      'size_guide.column.size',
      'size_guide.column.age',
      'size_guide.column.height_cm',
      'size_guide.column.weight_kg',
    ],
    rowsIn: [
      ['3-4Y', 'size_guide.age.years_3_4', '98-104', '15-17'],
      ['4-5Y', 'size_guide.age.years_4_5', '104-110', '17-19'],
      ['5-6Y', 'size_guide.age.years_5_6', '110-116', '19-21'],
      ['6-7Y', 'size_guide.age.years_6_7', '116-122', '21-24'],
      ['7-8Y', 'size_guide.age.years_7_8', '122-128', '24-27'],
      ['8-9Y', 'size_guide.age.years_8_9', '128-134', '27-30'],
      ['9-10Y', 'size_guide.age.years_9_10', '134-140', '30-34'],
      ['10-11Y', 'size_guide.age.years_10_11', '140-146', '34-38'],
      ['11-12Y', 'size_guide.age.years_11_12', '146-152', '38-43'],
      ['12-14Y', 'size_guide.age.years_12_14', '152-158', '43-50'],
      ['14-16Y', 'size_guide.age.years_14_16', '158-164', '50-60'],
    ],
  ),

  'bra': SizeGuideContent(
    type: SizeGuideType.bra,
    subtitle: 'size_guide.bra.subtitle',
  ),

  'ring_sizes': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'size_guide.ring_sizes.subtitle',
    howToMeasure: 'size_guide.how_to_measure.ring',
    columns: [
      'size_guide.column.eu',
      'size_guide.column.circumference_mm',
      'size_guide.column.diameter_mm',
    ],
    rowsIn: [
      ['44', '44', '14.0'],
      ['46', '46', '14.6'],
      ['48', '48', '15.3'],
      ['50', '50', '15.9'],
      ['52', '52', '16.6'],
      ['54', '54', '17.2'],
      ['56', '56', '17.8'],
      ['58', '58', '18.5'],
      ['60', '60', '19.1'],
      ['62', '62', '19.7'],
      ['64', '64', '20.4'],
      ['66', '66', '21.0'],
      ['68', '68', '21.6'],
      ['70', '70', '22.3'],
    ],
  ),

  'bed_sizes': SizeGuideContent(
    type: SizeGuideType.bed,
    subtitle: 'size_guide.bed_sizes.subtitle',
    howToMeasure: 'size_guide.how_to_measure.bed',
    columns: [
      'size_guide.column.size',
      'size_guide.column.dimensions',
      'size_guide.column.best_for',
    ],
    rowsIn: [
      ['90x200', 'size_guide.bed.single', 'size_guide.bed.single_use'],
      ['120x200', 'size_guide.bed.small_double', 'size_guide.bed.small_double_use'],
      ['140x200', 'size_guide.bed.double', 'size_guide.bed.double_use'],
      ['160x200', 'size_guide.bed.queen', 'size_guide.bed.queen_use'],
      ['180x200', 'size_guide.bed.king', 'size_guide.bed.king_use'],
      ['200x200', 'size_guide.bed.super_king', 'size_guide.bed.super_king_use'],
    ],
  ),

  'belt_size': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'size_guide.belt_size.subtitle',
    howToMeasure: 'size_guide.how_to_measure.belt',
    columns: [
      'size_guide.column.belt_size',
      'size_guide.column.fits_trouser_waist',
    ],
    rowsIn: [
      ['70 cm', '65-70 cm'],
      ['75 cm', '70-75 cm'],
      ['80 cm', '75-80 cm'],
      ['85 cm', '80-85 cm'],
      ['90 cm', '85-90 cm'],
      ['95 cm', '90-95 cm'],
      ['100 cm', '95-100 cm'],
      ['105 cm', '100-105 cm'],
      ['110 cm', '105-110 cm'],
      ['115 cm', '110-115 cm'],
      ['120 cm', '115-120 cm'],
      ['125 cm', '120-125 cm'],
      ['130 cm', '125-130 cm'],
    ],
  ),
};
