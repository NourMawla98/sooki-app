import '../models/product.dart';

// ─── Color name → hex lookup ────────────────────────────────────────────────
// Used by _colorVariantFromName to infer hex codes from human-readable names
// (including multi-color names like "Navy/White" or "Black/Red/Grey").

const Map<String, String> _hexByColorName = {
  'black': '#000000',
  'white': '#FFFFFF',
  'navy': '#1B1B3A',
  'red': '#FF6B6B',
  'grey': '#808080',
  'gray': '#808080',
  'blue': '#4169E1',
  'brown': '#8B4513',
  'beige': '#F5F5DC',
  'pink': '#FFB6C1',
  'classic blue': '#4169E1',
  'dark wash': '#1B1B3A',
  'light wash': '#87CEEB',
  'tortoise': '#8B4513',
  'gold': '#FFD700',
  'silver': '#C0C0C0',
  'tan': '#D2B48C',
  'burgundy': '#800020',
  'green': '#2E8B57',
  'orange': '#FFA500',
  'space black': '#000000',
  'rose gold': '#B76E79',
};

String _hexForPart(String part) =>
    _hexByColorName[part.trim().toLowerCase()] ?? '#808080';

ColorVariant _colorVariantFromName(
  String name, {
  bool isAvailable = true,
  String? swatchAssetPath,
  List<String>? imageUrls,
}) {
  final hexes = name.split('/').map(_hexForPart).toList();
  return ColorVariant(
    name: name,
    hexCode: hexes.first,
    hexCodes: hexes.length > 1 ? hexes : null,
    swatchAssetPath: swatchAssetPath,
    imageUrls: imageUrls,
    isAvailable: isAvailable,
  );
}

// ─── Color Variant Presets ───────────────────────────────────────────────────

final _defaultColors = [
  _colorVariantFromName('Black'),
  _colorVariantFromName('White'),
  _colorVariantFromName('Navy'),
  _colorVariantFromName('Red', isAvailable: false),
];

const _defaultSizes = [
  SizeVariant(label: 'S'),
  SizeVariant(label: 'M'),
  SizeVariant(label: 'L'),
  SizeVariant(label: 'XL', isAvailable: false),
];

// ─── Image Paths ────────────────────────────────────────────────────────────
// Bundled as local assets — emulator can't reach external HTTPS.

const _imgSummerDress = 'assets/images/products/summer_dress.jpg';
const _imgCasualTop = 'assets/images/products/casual_top.jpg';
const _imgSneakers = 'assets/images/products/sneakers.jpg';
const _imgHandbag = 'assets/images/products/handbag.jpg';
const _imgFloralDress = 'assets/images/products/floral_dress.jpg';
const _imgStripedTop = 'assets/images/products/striped_top.jpg';
const _imgDenimJacket = 'assets/images/products/denim_jacket.jpg';
const _imgSunglasses = 'assets/images/products/sunglasses.jpg';
const _imgBackpack = 'assets/images/products/backpack.jpg';
const _imgRunningShoes = 'assets/images/products/running_shoes.jpg';
const _imgSmartWatch = 'assets/images/products/smart_watch.jpg';
const _imgHeadphones = 'assets/images/products/headphones.jpg';

// ─── Browse Products ─────────────────────────────────────────────────────────

final List<Product> mockBrowseProducts = [
  Product(
    id: 'browse_1',
    name: 'Summer Dress',
    brand: 'SooKi Fashion',
    category: 'Women',
    subCategory: 'Dresses',
    detailedCategory: 'Midi',
    price: 29.99,
    rating: 4.5,
    reviewCount: 128,
    stockCount: 25,
    isNew: true,
    imageUrls: [_imgSummerDress, _imgFloralDress, _imgStripedTop],
    thumbnailUrl: _imgSummerDress,
    colors: [
      _colorVariantFromName('Black',
          imageUrls: [_imgSummerDress, _imgFloralDress]),
      _colorVariantFromName('White',
          imageUrls: [_imgCasualTop, _imgStripedTop]),
      _colorVariantFromName('Navy', imageUrls: [_imgDenimJacket]),
      _colorVariantFromName('Red', isAvailable: false),
    ],
    sizes: _defaultSizes,
    description:
        'A lightweight summer dress perfect for warm days. Features a flattering A-line silhouette with a vibrant floral print.',
    features: [
      'Lightweight breathable fabric',
      'A-line silhouette',
      'Machine washable',
      'Adjustable straps',
    ],
    specifications: {
      'Material': '100% Cotton',
      'Care': 'Machine wash cold',
      'Fit': 'Regular',
      'Length': 'Midi',
    },
  ),
  Product(
    id: 'browse_2',
    name: 'Casual Top',
    brand: 'Urban Style',
    category: 'Women',
    subCategory: 'Tops',
    detailedCategory: 'Tees',
    price: 19.99,
    rating: 4.2,
    reviewCount: 89,
    stockCount: 40,
    isNew: true,
    imageUrls: [_imgCasualTop],
    thumbnailUrl: _imgCasualTop,
    colors: _defaultColors,
    sizes: _defaultSizes,
    description:
        'An everyday casual top with a relaxed fit. Pairs effortlessly with jeans or skirts for a laid-back look.',
    features: [
      'Soft cotton blend',
      'Relaxed fit',
      'Machine washable',
      'Pre-shrunk fabric',
    ],
    specifications: {
      'Material': 'Cotton/Polyester blend',
      'Care': 'Machine wash cold',
      'Fit': 'Relaxed',
      'Neckline': 'Crew neck',
    },
  ),
  Product(
    id: 'browse_3',
    name: 'Sneakers',
    brand: 'SportX',
    category: 'Women',
    subCategory: 'Shoes',
    detailedCategory: 'Sneakers',
    price: 59.99,
    rating: 4.8,
    reviewCount: 256,
    stockCount: 15,
    isNew: false,
    imageUrls: [_imgSneakers],
    thumbnailUrl: _imgSneakers,
    colors: [
      _colorVariantFromName('White'),
      _colorVariantFromName('Black'),
      _colorVariantFromName('Grey'),
      _colorVariantFromName('Blue'),
    ],
    sizes: const [
      SizeVariant(label: '7'),
      SizeVariant(label: '8'),
      SizeVariant(label: '9'),
      SizeVariant(label: '10', isAvailable: false),
    ],
    description:
        'Lightweight everyday sneakers with superior cushioning. Designed for all-day comfort whether walking or running errands.',
    features: [
      'Memory foam insole',
      'Breathable mesh upper',
      'Non-slip rubber sole',
      'Lightweight design',
    ],
    specifications: {
      'Material': 'Mesh/Synthetic',
      'Sole': 'Rubber',
      'Closure': 'Lace-up',
      'Weight': '280g per shoe',
    },
  ),
  Product(
    id: 'browse_4',
    name: 'Handbag',
    brand: 'Luxe Co',
    category: 'Women',
    subCategory: 'Accessories',
    detailedCategory: 'Bags',
    price: 45.99,
    rating: 4.6,
    reviewCount: 167,
    stockCount: 20,
    isNew: true,
    imageUrls: [_imgHandbag],
    thumbnailUrl: _imgHandbag,
    colors: [
      _colorVariantFromName('Black'),
      _colorVariantFromName('Brown'),
      _colorVariantFromName('Beige'),
      _colorVariantFromName('Pink', isAvailable: false),
    ],
    sizes: const [
      SizeVariant(label: 'S'),
      SizeVariant(label: 'M'),
      SizeVariant(label: 'L'),
    ],
    description:
        'A stylish handbag crafted from premium faux leather. Spacious interior with multiple compartments for effortless organization.',
    features: [
      'Premium faux leather',
      'Multiple compartments',
      'Detachable shoulder strap',
      'Gold-tone hardware',
    ],
    specifications: {
      'Material': 'Faux Leather',
      'Dimensions': '30 x 25 x 12 cm',
      'Closure': 'Magnetic snap',
      'Lining': 'Polyester',
    },
  ),
  Product(
    id: 'browse_5',
    name: 'Floral Dress',
    brand: 'SooKi Fashion',
    category: 'Women',
    subCategory: 'Dresses',
    detailedCategory: 'Midi',
    price: 34.99,
    rating: 4.7,
    reviewCount: 203,
    stockCount: 18,
    isNew: false,
    imageUrls: [_imgFloralDress],
    thumbnailUrl: _imgFloralDress,
    colors: _defaultColors,
    sizes: _defaultSizes,
    description:
        'A charming floral dress with an elegant wrap design. Perfect for brunch dates or weekend outings.',
    features: [
      'Premium cotton blend',
      'Wrap-style design',
      'Machine washable',
      'Side pockets',
    ],
    specifications: {
      'Material': 'Cotton/Viscose blend',
      'Care': 'Machine wash cold',
      'Fit': 'Regular',
      'Length': 'Knee-length',
    },
  ),
  Product(
    id: 'browse_6',
    name: 'Striped Top',
    brand: 'Urban Style',
    category: 'Women',
    subCategory: 'Tops',
    detailedCategory: 'Tees',
    price: 24.99,
    rating: 4.3,
    reviewCount: 95,
    stockCount: 35,
    isNew: true,
    imageUrls: [_imgStripedTop],
    thumbnailUrl: _imgStripedTop,
    colors: [
      _colorVariantFromName('Navy/White'),
      _colorVariantFromName('Black/White'),
      _colorVariantFromName('Red/White'),
      _colorVariantFromName('Green/White', isAvailable: false),
    ],
    sizes: _defaultSizes,
    description:
        'A classic striped top with a modern twist. Versatile enough to dress up or down for any occasion.',
    features: [
      'Soft jersey fabric',
      'Classic stripe pattern',
      'Machine washable',
      'Colour-fast dye',
    ],
    specifications: {
      'Material': '95% Cotton, 5% Elastane',
      'Care': 'Machine wash cold',
      'Fit': 'Slim fit',
      'Neckline': 'Boat neck',
    },
  ),
];

// ─── Deal Products ───────────────────────────────────────────────────────────

final List<Product> mockDealProducts = [
  Product(
    id: 'deal_1',
    name: 'Denim Jacket',
    brand: 'Street Wear',
    category: 'Women',
    subCategory: 'Jackets',
    price: 44.99,
    originalPrice: 89.99,
    discountPercentage: 50,
    rating: 4.5,
    reviewCount: 312,
    stockCount: 19,
    isVerified: false,
    imageUrls: [_imgDenimJacket],
    thumbnailUrl: _imgDenimJacket,
    colors: [
      _colorVariantFromName('Classic Blue'),
      _colorVariantFromName('Dark Wash'),
      _colorVariantFromName('Light Wash'),
      _colorVariantFromName('Black'),
    ],
    sizes: _defaultSizes,
    description:
        'A timeless denim jacket with a modern slim fit. The perfect layering piece for transitional weather.',
    features: [
      'Premium denim fabric',
      'Slim fit cut',
      'Button closure',
      'Multiple pockets',
    ],
    specifications: {
      'Material': '100% Denim',
      'Care': 'Machine wash cold',
      'Fit': 'Slim',
      'Closure': 'Button front',
    },
  ),
  Product(
    id: 'deal_2',
    name: 'Designer Sunglasses',
    brand: 'Luxe Co',
    category: 'Women',
    subCategory: 'Accessories',
    detailedCategory: 'Jewelry',
    price: 79.99,
    originalPrice: 149.99,
    discountPercentage: 47,
    rating: 4.7,
    reviewCount: 189,
    stockCount: 8,
    isVerified: false,
    imageUrls: [_imgSunglasses],
    thumbnailUrl: _imgSunglasses,
    colors: [
      _colorVariantFromName('Black'),
      _colorVariantFromName('Tortoise'),
      _colorVariantFromName('Gold'),
      _colorVariantFromName('Silver', isAvailable: false),
    ],
    sizes: const [
      SizeVariant(label: 'Standard'),
    ],
    description:
        'Sleek designer sunglasses with UV400 protection. Crafted with premium acetate frames for lasting durability.',
    features: [
      'UV400 protection',
      'Polarized lenses',
      'Premium acetate frame',
      'Includes hard case',
    ],
    specifications: {
      'Material': 'Acetate/Metal',
      'Lens': 'Polarized UV400',
      'Frame Width': '140mm',
      'Weight': '28g',
    },
  ),
  Product(
    id: 'deal_3',
    name: 'Leather Backpack',
    brand: 'Luxe Co',
    category: 'Women',
    subCategory: 'Accessories',
    detailedCategory: 'Bags',
    price: 69.99,
    originalPrice: 129.99,
    discountPercentage: 46,
    rating: 4.6,
    reviewCount: 234,
    stockCount: 12,
    isVerified: true,
    imageUrls: [_imgBackpack],
    thumbnailUrl: _imgBackpack,
    colors: [
      _colorVariantFromName('Black'),
      _colorVariantFromName('Brown'),
      _colorVariantFromName('Tan'),
      _colorVariantFromName('Burgundy'),
    ],
    sizes: const [
      SizeVariant(label: 'Standard'),
    ],
    description:
        'A sophisticated leather backpack combining style and functionality. Features a padded laptop compartment and multiple organizer pockets.',
    features: [
      'Genuine leather exterior',
      'Padded laptop compartment',
      'Water-resistant lining',
      'Adjustable straps',
    ],
    specifications: {
      'Material': 'Genuine Leather',
      'Dimensions': '40 x 30 x 15 cm',
      'Laptop Fit': 'Up to 15 inches',
      'Weight': '850g',
    },
  ),
  Product(
    id: 'deal_4',
    name: 'Running Shoes',
    brand: 'SportX',
    category: 'Women',
    subCategory: 'Shoes',
    detailedCategory: 'Sneakers',
    price: 59.99,
    originalPrice: 119.99,
    discountPercentage: 50,
    rating: 4.8,
    reviewCount: 445,
    stockCount: 31,
    isVerified: false,
    imageUrls: [_imgRunningShoes],
    thumbnailUrl: _imgRunningShoes,
    colors: [
      _colorVariantFromName('Black/Red'),
      _colorVariantFromName('White/Blue'),
      _colorVariantFromName('Grey/Green'),
      _colorVariantFromName('Navy/Orange', isAvailable: false),
    ],
    sizes: const [
      SizeVariant(label: '7'),
      SizeVariant(label: '8'),
      SizeVariant(label: '9'),
      SizeVariant(label: '10', isAvailable: false),
    ],
    description:
        'High-performance running shoes engineered for speed and comfort. Responsive cushioning adapts to your stride.',
    features: [
      'Responsive foam midsole',
      'Breathable mesh upper',
      'Reflective details',
      'Durable rubber outsole',
    ],
    specifications: {
      'Material': 'Engineered Mesh/Synthetic',
      'Sole': 'EVA/Rubber',
      'Drop': '8mm',
      'Weight': '245g per shoe',
    },
  ),
  Product(
    id: 'deal_5',
    name: 'Smart Watch',
    brand: 'TechGear',
    category: 'Electronics',
    price: 129.99,
    originalPrice: 199.99,
    discountPercentage: 35,
    rating: 4.9,
    reviewCount: 567,
    stockCount: 15,
    isVerified: true,
    imageUrls: [_imgSmartWatch],
    thumbnailUrl: _imgSmartWatch,
    colors: [
      _colorVariantFromName('Space Black'),
      _colorVariantFromName('Silver'),
      _colorVariantFromName('Rose Gold'),
      _colorVariantFromName('Blue'),
    ],
    sizes: const [
      SizeVariant(label: '40mm'),
      SizeVariant(label: '44mm'),
    ],
    description:
        'A feature-packed smart watch with health monitoring and GPS. Tracks heart rate, sleep, and over 100 workout modes.',
    features: [
      'Heart rate monitoring',
      'Built-in GPS',
      'Water resistant 50m',
      '7-day battery life',
    ],
    specifications: {
      'Display': '1.4" AMOLED',
      'Battery': '7 days typical use',
      'Connectivity': 'Bluetooth 5.2',
      'Water Rating': '5 ATM',
    },
  ),
  Product(
    id: 'deal_6',
    name: 'Wireless Headphones',
    brand: 'TechGear',
    category: 'Electronics',
    price: 39.99,
    originalPrice: 89.99,
    discountPercentage: 56,
    rating: 4.8,
    reviewCount: 389,
    stockCount: 23,
    isVerified: true,
    imageUrls: [_imgHeadphones],
    thumbnailUrl: _imgHeadphones,
    colors: [
      _colorVariantFromName('Black'),
      _colorVariantFromName('White'),
      _colorVariantFromName('Navy'),
      _colorVariantFromName('Red', isAvailable: false),
    ],
    sizes: const [
      SizeVariant(label: 'One Size'),
    ],
    description:
        'Premium wireless headphones with active noise cancellation. Crystal-clear audio with deep bass and 30-hour battery life.',
    features: [
      'Active noise cancellation',
      '30-hour battery life',
      'Bluetooth 5.3',
      'Foldable design',
    ],
    specifications: {
      'Driver': '40mm dynamic',
      'Battery': '30 hours (ANC on)',
      'Charging': 'USB-C fast charge',
      'Weight': '250g',
    },
  ),
];

// ─── Reviews ─────────────────────────────────────────────────────────────────
// 38 mock reviews so the lazy-load-10-at-a-time pagination can be exercised
// end-to-end before the real API lands.

const _reviewerNames = [
  'Sarah M.', 'Mike R.', 'Emily K.', 'James L.', 'Amira H.',
  'David P.', 'Layla N.', 'Daniel S.', 'Noura Z.', 'Omar T.',
  'Rachel G.', 'Kevin B.', 'Priya V.', 'Tom W.', 'Yasmin A.',
  'Leo D.', 'Hana F.', 'Marco L.',
];

const _reviewerTexts = [
  'Absolutely love this! Great quality and fits perfectly.',
  'Good product overall. Sizing runs a bit small, I recommend going one size up.',
  'Beautiful design, exactly as shown in the pictures. Fast shipping too!',
  'Decent quality for the price. Nothing exceptional but does the job.',
  'Exceeded my expectations — the fabric feels premium and looks elegant.',
  'Arrived earlier than promised. Packaging was thoughtful and sturdy.',
  'Color is slightly different in person but I still like it a lot.',
  'Fits true to size for me. Very comfortable for long wear.',
  'Not bad, but I wish there were more color options available.',
  'Solid five stars. Would definitely recommend to a friend.',
  'Material wrinkles a bit, but the shape and cut are great.',
  'Perfect for the office or a casual evening out — very versatile.',
  'Customer support was responsive when I had a sizing question.',
  'Stitching is neat and the hem lies flat. Well made.',
  'Bought this as a gift and she loved it. Worth the price.',
  'Photos don\'t fully capture the detail — it looks better in person.',
  'A little tight around the shoulders but otherwise great.',
  'Have washed it three times and it still looks brand new.',
];

const _reviewerDates = [
  '2024-12-18', '2024-12-15', '2024-12-10', '2024-12-04',
  '2024-11-28', '2024-11-22', '2024-11-15', '2024-11-08',
  '2024-10-30', '2024-10-21', '2024-10-12', '2024-10-03',
  '2024-09-25', '2024-09-17', '2024-09-09', '2024-08-30',
];

final List<Review> mockReviews = List.generate(38, (i) {
  const ratings = [5.0, 4.5, 5.0, 4.0, 5.0, 4.0, 3.5, 5.0, 4.5, 4.0];
  return Review(
    userName: _reviewerNames[i % _reviewerNames.length],
    rating: ratings[i % ratings.length],
    text: _reviewerTexts[i % _reviewerTexts.length],
    date: _reviewerDates[i % _reviewerDates.length],
    isVerifiedPurchase: i % 4 != 3,
    helpfulCount: (i * 7) % 33,
  );
});
