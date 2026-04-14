import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/themes/app_colors.dart';
import 'package:sooki_app/themes/themed_colors.dart';

void main() {
  group('ThemedColors — light mode', () {
    const c = ThemedColors(isDark: false);

    test('background is light gray', () {
      expect(c.background, AppColors.backgroundLight);
    });

    test('surface is white', () {
      expect(c.surface, AppColors.white);
    });

    test('textPrimary uses brand purple', () {
      expect(c.textPrimary, AppColors.primaryPurple);
    });

    test('textSecondary is gray600', () {
      expect(c.textSecondary, AppColors.gray600);
    });

    test('border is gray200', () {
      expect(c.border, AppColors.gray200);
    });

    test('divider is gray100', () {
      expect(c.divider, AppColors.gray100);
    });

    test('scaffoldForeground is brand purple', () {
      expect(c.scaffoldForeground, AppColors.primaryPurple);
    });
  });

  group('ThemedColors — dark mode', () {
    const c = ThemedColors(isDark: true);

    test('background is deep indigo', () {
      expect(c.background, AppColors.darkBackground);
    });

    test('surface is elevated dark', () {
      expect(c.surface, AppColors.darkSurface);
    });

    test('textPrimary is white', () {
      expect(c.textPrimary, AppColors.white);
    });

    test('textSecondary is gray300', () {
      expect(c.textSecondary, AppColors.gray300);
    });

    test('border is a dark divider color', () {
      expect(c.border, AppColors.darkBorder);
    });

    test('divider matches dark border family', () {
      expect(c.divider, AppColors.darkBorder);
    });

    test('scaffoldForeground is white', () {
      expect(c.scaffoldForeground, AppColors.white);
    });
  });
}
