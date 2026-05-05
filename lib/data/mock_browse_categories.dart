import 'package:flutter/material.dart' show Color;

import '../themes/app_colors.dart';

class BrowseSubcategory {
  final String label;
  final String imageAsset;
  const BrowseSubcategory({required this.label, required this.imageAsset});
}

class BrowseMainCategory {
  final String name;
  final String imageAsset;
  final Color accentColor;
  final int itemCount;
  final List<BrowseSubcategory> subcategories;
  const BrowseMainCategory({
    required this.name,
    required this.imageAsset,
    required this.accentColor,
    required this.itemCount,
    required this.subcategories,
  });
}

const String _p = 'assets/images/products/';

const List<BrowseMainCategory> mockBrowseCategories = [
  BrowseMainCategory(
    name: 'Women',
    imageAsset: '${_p}summer_dress.jpg',
    accentColor: AppColors.auroraPink,
    itemCount: 1240,
    subcategories: [
      BrowseSubcategory(label: 'Dresses',  imageAsset: '${_p}summer_dress.jpg'),
      BrowseSubcategory(label: 'Tops',     imageAsset: '${_p}casual_top.jpg'),
      BrowseSubcategory(label: 'Shoes',    imageAsset: '${_p}sneakers.jpg'),
      BrowseSubcategory(label: 'Jackets',  imageAsset: '${_p}denim_jacket.jpg'),
      BrowseSubcategory(label: 'Bags',     imageAsset: '${_p}handbag.jpg'),
      BrowseSubcategory(label: 'Jewelry',  imageAsset: '${_p}sunglasses.jpg'),
    ],
  ),
  BrowseMainCategory(
    name: 'Men',
    imageAsset: '${_p}striped_top.jpg',
    accentColor: AppColors.auroraElectricBlue,
    itemCount: 890,
    subcategories: [
      BrowseSubcategory(label: 'Shirts',    imageAsset: '${_p}striped_top.jpg'),
      BrowseSubcategory(label: 'Bottoms',   imageAsset: '${_p}denim_jacket.jpg'),
      BrowseSubcategory(label: 'Shoes',     imageAsset: '${_p}running_shoes.jpg'),
      BrowseSubcategory(label: 'Outerwear', imageAsset: '${_p}denim_jacket.jpg'),
      BrowseSubcategory(label: 'Watches',   imageAsset: '${_p}smart_watch.jpg'),
      BrowseSubcategory(label: 'Wallets',   imageAsset: '${_p}handbag.jpg'),
    ],
  ),
  BrowseMainCategory(
    name: 'Beauty',
    imageAsset: '${_p}sunglasses.jpg',
    accentColor: AppColors.auroraGold,
    itemCount: 540,
    subcategories: [
      BrowseSubcategory(label: 'Makeup',    imageAsset: '${_p}sunglasses.jpg'),
      BrowseSubcategory(label: 'Skincare',  imageAsset: '${_p}floral_dress.jpg'),
      BrowseSubcategory(label: 'Haircare',  imageAsset: '${_p}casual_top.jpg'),
      BrowseSubcategory(label: 'Fragrance', imageAsset: '${_p}summer_dress.jpg'),
      BrowseSubcategory(label: 'Nails',     imageAsset: '${_p}striped_top.jpg'),
      BrowseSubcategory(label: 'Tools',     imageAsset: '${_p}headphones.jpg'),
    ],
  ),
  BrowseMainCategory(
    name: 'Home',
    imageAsset: '${_p}headphones.jpg',
    accentColor: AppColors.auroraTeal,
    itemCount: 430,
    subcategories: [
      BrowseSubcategory(label: 'Living Room', imageAsset: '${_p}backpack.jpg'),
      BrowseSubcategory(label: 'Bedroom',     imageAsset: '${_p}floral_dress.jpg'),
      BrowseSubcategory(label: 'Kitchen',     imageAsset: '${_p}headphones.jpg'),
      BrowseSubcategory(label: 'Decor',       imageAsset: '${_p}handbag.jpg'),
      BrowseSubcategory(label: 'Lighting',    imageAsset: '${_p}smart_watch.jpg'),
      BrowseSubcategory(label: 'Storage',     imageAsset: '${_p}backpack.jpg'),
    ],
  ),
  BrowseMainCategory(
    name: 'Kids',
    imageAsset: '${_p}casual_top.jpg',
    accentColor: AppColors.auroraPurple,
    itemCount: 320,
    subcategories: [
      BrowseSubcategory(label: 'Clothing',    imageAsset: '${_p}casual_top.jpg'),
      BrowseSubcategory(label: 'Toys',        imageAsset: '${_p}headphones.jpg'),
      BrowseSubcategory(label: 'Books',       imageAsset: '${_p}backpack.jpg'),
      BrowseSubcategory(label: 'Shoes',       imageAsset: '${_p}sneakers.jpg'),
      BrowseSubcategory(label: 'Bags',        imageAsset: '${_p}backpack.jpg'),
      BrowseSubcategory(label: 'Accessories', imageAsset: '${_p}sunglasses.jpg'),
    ],
  ),
];
