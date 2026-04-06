import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/product.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/rating_stars/star_rating.dart';

class ProductTabs extends StatelessWidget {
  final Product product;
  final List<Review> reviews;

  const ProductTabs({
    super.key,
    required this.product,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primaryPurple,
            unselectedLabelColor: AppColors.gray400,
            indicatorColor: AppColors.primaryPurple,
            labelStyle: AppTextStyles.label,
            tabs: [
              const Tab(text: 'Details'),
              Tab(text: 'Reviews (${reviews.length})'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildDetailsTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.description,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Key Features',
            style: AppTextStyles.heading4,
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              for (int i = 0; i < product.features.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.check,
                      size: 14,
                      color: AppColors.accentGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        product.features[i],
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
                if (i < product.features.length - 1) const SizedBox(height: 6),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Specifications',
            style: AppTextStyles.heading4,
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              for (int i = 0;
                  i < product.specifications.entries.length;
                  i++)
                Container(
                  padding: const EdgeInsets.all(10),
                  color: i.isEven ? AppColors.gray50 : AppColors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.specifications.entries.elementAt(i).key,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          product.specifications.entries.elementAt(i).value,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (int i = 0; i < reviews.length; i++) ...[
            _buildReviewCard(reviews[i]),
            if (i < reviews.length - 1) ...[
              const Divider(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              review.userName,
              style: AppTextStyles.label,
            ),
            const Spacer(),
            StarRating(
              rating: review.rating,
              size: 12,
              showValue: false,
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (review.isVerifiedPurchase)
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                size: 10,
                color: AppColors.verifiedGreen,
              ),
              const SizedBox(width: 4),
              Text(
                'Verified Purchase',
                style: AppTextStyles.captionSmall.copyWith(
                  color: AppColors.verifiedGreen,
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        Text(
          review.text,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              review.date,
              style: AppTextStyles.captionSmall,
            ),
            const Spacer(),
            Text(
              '${review.helpfulCount} found helpful',
              style: AppTextStyles.captionSmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
