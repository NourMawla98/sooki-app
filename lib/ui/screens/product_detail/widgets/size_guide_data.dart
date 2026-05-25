// Static size guide content, keyed by the English standardName returned by BE.
// ONE_SIZE / Canvas Size / Paper Size are intentionally absent — button is hidden for them.

enum SizeGuideType { table, bra, bed }

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
  final String subtitle;
  final String? howToMeasure;
  final bool hasUnitToggle; // IN/CM toggle — only for body-measurement standards
  final List<String> columns;
  final List<List<String>> rowsIn; // primary (inches when toggle present, otherwise cm/mm)
  final List<List<String>>? rowsCm; // alternate (cm) — only when hasUnitToggle=true
}

// Key = English standardName value from BE (ItemDetailSizeDto.standardName)
const Map<String, SizeGuideContent> kSizeGuides = {
  'International Letter': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'Body measurements for international letter sizes',
    howToMeasure:
        'Chest — around the fullest part of your bust, tape parallel to the floor.\n'
        'Waist — around the narrowest part, usually just above the belly button.\n'
        'Hip — around the fullest part of your hips, ~20 cm below your waist.',
    hasUnitToggle: true,
    columns: ['Size', 'Chest', 'Waist', 'Hip'],
    rowsIn: [
      ['XS', '31–33"', '23–25"', '33–35"'],
      ['S', '34–36"', '26–28"', '36–38"'],
      ['M', '37–39"', '29–31"', '39–41"'],
      ['L', '40–42"', '32–34"', '42–44"'],
      ['XL', '43–45"', '35–37"', '45–47"'],
      ['2XL', '46–48"', '38–40"', '48–50"'],
      ['3XL', '49–51"', '41–44"', '51–54"'],
      ['4XL', '52–54"', '45–48"', '55–58"'],
      ['5XL', '55–58"', '49–52"', '59–63"'],
    ],
    rowsCm: [
      ['XS', '79–84', '58–64', '84–89'],
      ['S', '86–91', '66–71', '91–97'],
      ['M', '94–99', '74–79', '99–104'],
      ['L', '102–107', '81–86', '107–112'],
      ['XL', '109–114', '89–94', '114–119'],
      ['2XL', '117–122', '97–102', '122–127'],
      ['3XL', '124–130', '104–112', '130–137'],
      ['4XL', '132–137', '114–122', '140–147'],
      ['5XL', '140–147', '124–132', '150–160'],
    ],
  ),

  "Women's Apparel": SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'Body measurements for EU women\'s apparel sizes',
    howToMeasure:
        'Chest — around the fullest part of your bust, tape parallel to the floor.\n'
        'Waist — around the narrowest part, usually just above the belly button.\n'
        'Hip — around the fullest part of your hips, ~20 cm below your waist.',
    columns: ['EU', 'Chest (cm)', 'Waist (cm)', 'Hip (cm)'],
    rowsIn: [
      ['32', '77–79', '59–61', '82–84'],
      ['34', '80–82', '62–64', '85–87'],
      ['36', '83–86', '65–68', '88–91'],
      ['38', '87–90', '69–72', '92–95'],
      ['40', '91–94', '73–76', '96–99'],
      ['42', '95–98', '77–80', '100–103'],
      ['44', '99–102', '81–84', '104–107'],
      ['46', '103–107', '85–89', '108–112'],
      ['48', '108–112', '90–94', '113–117'],
      ['50', '113–117', '95–99', '118–122'],
      ['52', '118–122', '100–104', '123–127'],
    ],
  ),

  "Kids' Shoes": SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'EU kids\' shoe sizes by foot length',
    howToMeasure:
        'Place your child\'s foot flat on paper, trace it and measure heel to toe in cm. '
        'Add 0.5 cm for growing room.',
    columns: ['EU', 'Foot (cm)', 'Age (approx)'],
    rowsIn: [
      ['17', '10.5', '0–6 months'],
      ['18', '11.0', '6–9 months'],
      ['19', '11.7', '9–12 months'],
      ['20', '12.4', '12–18 months'],
      ['21', '13.0', '18–24 months'],
      ['22', '13.7', '2 years'],
      ['23', '14.4', '2–3 years'],
      ['24', '15.0', '3 years'],
      ['25', '15.7', '3–4 years'],
      ['26', '16.4', '4 years'],
      ['27', '17.1', '4–5 years'],
      ['28', '17.7', '5 years'],
      ['29', '18.4', '5–6 years'],
      ['30', '19.0', '6–7 years'],
      ['31', '19.7', '7–8 years'],
      ['32', '20.4', '8–9 years'],
      ['33', '21.1', '9–10 years'],
      ['34', '21.7', '10–11 years'],
      ['35', '22.4', '11–12 years'],
    ],
  ),

  'Baby Sizes (Months)': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'Size by age, weight and height',
    howToMeasure: 'Babies grow quickly — if between sizes, size up for longer wear.',
    columns: ['Size', 'Age', 'Weight (kg)', 'Height (cm)'],
    rowsIn: [
      ['NB', 'Newborn', '0–3.5', '50'],
      ['0–3M', '0–3 months', '3.5–6', '56'],
      ['3–6M', '3–6 months', '6–8', '62'],
      ['6–9M', '6–9 months', '8–10', '68'],
      ['9–12M', '9–12 months', '10–11', '74'],
      ['12–18M', '12–18 months', '11–12.5', '80'],
      ['18–24M', '18–24 months', '12.5–14', '86'],
    ],
  ),

  'Kids Sizes (Age)': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'Size by age, height and weight',
    howToMeasure:
        'Measure your child\'s height standing straight against a wall without shoes.',
    columns: ['Size', 'Age', 'Height (cm)', 'Weight (kg)'],
    rowsIn: [
      ['3–4Y', '3–4 years', '98–104', '15–17'],
      ['4–5Y', '4–5 years', '104–110', '17–19'],
      ['5–6Y', '5–6 years', '110–116', '19–21'],
      ['6–7Y', '6–7 years', '116–122', '21–24'],
      ['7–8Y', '7–8 years', '122–128', '24–27'],
      ['8–9Y', '8–9 years', '128–134', '27–30'],
      ['9–10Y', '9–10 years', '134–140', '30–34'],
      ['10–11Y', '10–11 years', '140–146', '34–38'],
      ['11–12Y', '11–12 years', '146–152', '38–43'],
      ['12–14Y', '12–14 years', '152–158', '43–50'],
      ['14–16Y', '14–16 years', '158–164', '50–60'],
    ],
  ),

  'Bra Size': SizeGuideContent(
    type: SizeGuideType.bra,
    subtitle: 'Find your bra size in 3 steps',
  ),

  'Ring Sizes': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'EU ring sizes by circumference and diameter',
    howToMeasure:
        'Wrap a strip of paper around the base of your finger. Mark where it overlaps '
        'and measure the length in mm — that is your circumference.',
    columns: ['EU', 'Circumference (mm)', 'Diameter (mm)'],
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

  'Bed Sizes': SizeGuideContent(
    type: SizeGuideType.bed,
    subtitle: 'Mattress dimensions and recommended use',
    howToMeasure:
        'The size refers to the mattress. For bedding (sheets, duvets, covers), '
        'choose the same size as your mattress.',
    columns: ['Size', 'Dimensions', 'Best for'],
    rowsIn: [
      ['90×200', 'Single', 'One person / children\'s rooms'],
      ['120×200', 'Small Double', 'One person with extra width'],
      ['140×200', 'Double', 'Couples in smaller rooms'],
      ['160×200', 'Queen', 'Couples — most popular size'],
      ['180×200', 'King', 'Couples wanting extra space'],
      ['200×200', 'Super King', 'Maximum comfort for couples'],
    ],
  ),

  'Belt Size (CM)': SizeGuideContent(
    type: SizeGuideType.table,
    subtitle: 'Belt size by trouser waist measurement',
    howToMeasure:
        'Measure around your trouser waist in cm (where you wear your belt). '
        'Your belt size = your waist measurement + 5 cm.',
    columns: ['Belt size', 'Fits trouser waist'],
    rowsIn: [
      ['70 cm', '65–70 cm'],
      ['75 cm', '70–75 cm'],
      ['80 cm', '75–80 cm'],
      ['85 cm', '80–85 cm'],
      ['90 cm', '85–90 cm'],
      ['95 cm', '90–95 cm'],
      ['100 cm', '95–100 cm'],
      ['105 cm', '100–105 cm'],
      ['110 cm', '105–110 cm'],
      ['115 cm', '110–115 cm'],
      ['120 cm', '115–120 cm'],
      ['125 cm', '120–125 cm'],
      ['130 cm', '125–130 cm'],
    ],
  ),
};
