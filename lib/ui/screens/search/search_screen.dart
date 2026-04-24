import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/mock_products.dart';
import '../../../models/product.dart';
import '../../../services/theme_service.dart';
import '../../../themes/themes.dart';
import '../../reusable_components/product_card/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery});
  final String? initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String _query;
  late List<Product> _matches;

  @override
  void initState() {
    super.initState();
    _query = (widget.initialQuery ?? '').trim();
    _matches = _search(_query);
  }

  List<Product> _search(String q) {
    final needle = q.toLowerCase();
    if (needle.isEmpty) return const [];
    return [...mockBrowseProducts, ...mockDealProducts]
        .where((p) =>
            p.name.toLowerCase().contains(needle) ||
            p.brand.toLowerCase().contains(needle) ||
            p.category.toLowerCase().contains(needle))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final text = isDark ? AppColors.white : AppColors.primaryPurple;
        final muted = text.withValues(alpha: 0.55);
        final glyph = isDark ? AppColors.white : AppColors.auroraPurple;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: FaIcon(FontAwesomeIcons.arrowLeft,
                                size: 20, color: glyph),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _query.isEmpty ? 'Search' : '"$_query"',
                          style: AppFonts.primary(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_query.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_matches.length} RESULTS',
                        style: AppFonts.primary(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: muted,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                Expanded(child: _buildBody(text, muted)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(Color text, Color muted) {
    if (_matches.isEmpty) {
      return Center(
        child: Text(
          _query.isEmpty
              ? 'No query'
              : 'No results for "$_query"',
          style: AppFonts.primary(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: muted,
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: _matches.length,
      itemBuilder: (_, i) => ProductCard(product: _matches[i]),
    );
  }
}
