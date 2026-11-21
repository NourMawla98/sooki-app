import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/utils/text_localization.dart';

/// French showed "Taille Taille Unique": the size name already said "Taille".

void main() {
  test('a plain size gets the label word', () {
    expect(composeSizeLabel('Size {name}', 'M'), 'Size M');
    expect(composeSizeLabel('Taille {name}', '38'), 'Taille 38');
  });

  test('a size name that already has the word is shown alone', () {
    expect(composeSizeLabel('Taille {name}', 'Taille Unique'), 'Taille Unique');
    expect(composeSizeLabel('Size {name}', 'size one'), 'size one');
  });

  test('a template without a word just shows the name', () {
    expect(composeSizeLabel('{name}', 'XL'), 'XL');
  });
}
