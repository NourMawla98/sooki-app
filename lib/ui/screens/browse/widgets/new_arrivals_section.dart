import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../../../routes/route_constants.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/product_card/product_card.dart';

/// Displays a header row and a 2-column grid of [ProductCard] widgets
/// with a staggered entrance animation.
///
/// The title adapts based on [selectedCategory]:
/// - "All" shows "New Arrivals"
/// - Any other value shows the category name directly
class NewArrivalsSection extends StatefulWidget {
  final List<Product> products;
  final String selectedCategory;

  const NewArrivalsSection({
    super.key,
    required this.products,
    required this.selectedCategory,
  });

  @override
  State<NewArrivalsSection> createState() => _NewArrivalsSectionState();
}

class _NewArrivalsSectionState extends State<NewArrivalsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.selectedCategory == 'All'
        ? 'New Arrivals'
        : widget.selectedCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.sectionTitle),
              Text(
                '${widget.products.length} items',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Product grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.58,
                ),
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final staggerStart = (index * 0.1).clamp(0.0, 1.0);
                  final staggerEnd = (staggerStart + 0.5).clamp(0.0, 1.0);
                  final progress = Interval(
                    staggerStart,
                    staggerEnd,
                    curve: Curves.easeOutCubic,
                  ).transform(_controller.value);

                  final opacity = progress.clamp(0.0, 1.0);
                  final translateY = 30.0 * (1 - progress);

                  final product = widget.products[index];
                  return Transform.translate(
                    offset: Offset(0, translateY),
                    child: Opacity(
                      opacity: opacity,
                      child: ProductCard(
                        product: product,
                        onTap: () => Navigator.pushNamed(
                          context,
                          productDetailScreenRoute,
                          arguments: product,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
