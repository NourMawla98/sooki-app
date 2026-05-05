/// Single source of truth for the Shopping screen's three-level category
/// tree. Products reference leaf labels via their `category`, `subCategory`,
/// and `detailedCategory` fields.
///
/// Hierarchy rules:
/// - Not every category has subcategories.
/// - Not every subcategory has detailed categories.
/// - A product sits at whatever the deepest level is for its branch — the
///   deeper levels are `null` when the branch doesn't go that far.
/// - `Sale` is a cross-category view, not a real branch. It filters whatever
///   branch is currently visible by `discountPercentage != null`. Products
///   never store `Sale` as their `category`.
class CategoryNode {
  final String label;
  final List<CategoryNode> children;
  const CategoryNode(this.label, [this.children = const []]);

  bool get hasChildren => children.isNotEmpty;
}

const List<CategoryNode> mockTaxonomy = [
  CategoryNode('Women', [
    CategoryNode('Dresses', [
      CategoryNode('Cocktail'),
      CategoryNode('Maxi'),
      CategoryNode('Midi'),
    ]),
    CategoryNode('Tops', [
      CategoryNode('Blouses'),
      CategoryNode('Tees'),
      CategoryNode('Knitwear'),
    ]),
    CategoryNode('Shoes', [
      CategoryNode('Heels'),
      CategoryNode('Sneakers'),
      CategoryNode('Flats'),
    ]),
    CategoryNode('Jackets'),
    CategoryNode('Bags', [
      CategoryNode('Tote'),
      CategoryNode('Crossbody'),
      CategoryNode('Clutch'),
    ]),
    CategoryNode('Jewelry', [
      CategoryNode('Necklaces'),
      CategoryNode('Earrings'),
      CategoryNode('Bracelets'),
    ]),
  ]),
  CategoryNode('Men', [
    CategoryNode('Shirts', [
      CategoryNode('Casual'),
      CategoryNode('Formal'),
      CategoryNode('Polo'),
    ]),
    CategoryNode('Bottoms', [
      CategoryNode('Jeans'),
      CategoryNode('Chinos'),
      CategoryNode('Shorts'),
    ]),
    CategoryNode('Shoes', [
      CategoryNode('Sneakers'),
      CategoryNode('Boots'),
      CategoryNode('Loafers'),
    ]),
    CategoryNode('Outerwear', [
      CategoryNode('Coats'),
      CategoryNode('Jackets'),
      CategoryNode('Vests'),
    ]),
    CategoryNode('Watches', [
      CategoryNode('Sport'),
      CategoryNode('Dress'),
      CategoryNode('Smart'),
    ]),
    CategoryNode('Wallets'),
  ]),
  CategoryNode('Beauty', [
    CategoryNode('Makeup', [
      CategoryNode('Foundation'),
      CategoryNode('Lipstick'),
      CategoryNode('Eyes'),
    ]),
    CategoryNode('Skincare', [
      CategoryNode('Moisturiser'),
      CategoryNode('Serum'),
      CategoryNode('Cleanser'),
    ]),
    CategoryNode('Haircare', [
      CategoryNode('Shampoo'),
      CategoryNode('Conditioner'),
      CategoryNode('Treatments'),
    ]),
    CategoryNode('Fragrance'),
    CategoryNode('Nails'),
    CategoryNode('Tools'),
  ]),
  CategoryNode('Home', [
    CategoryNode('Living Room', [
      CategoryNode('Sofas'),
      CategoryNode('Tables'),
      CategoryNode('Shelves'),
    ]),
    CategoryNode('Bedroom', [
      CategoryNode('Bedding'),
      CategoryNode('Pillows'),
      CategoryNode('Curtains'),
    ]),
    CategoryNode('Kitchen', [
      CategoryNode('Cookware'),
      CategoryNode('Appliances'),
      CategoryNode('Storage'),
    ]),
    CategoryNode('Decor'),
    CategoryNode('Lighting'),
    CategoryNode('Storage'),
  ]),
  CategoryNode('Kids', [
    CategoryNode('Clothing', [
      CategoryNode('Tops'),
      CategoryNode('Bottoms'),
      CategoryNode('Dresses'),
    ]),
    CategoryNode('Toys', [
      CategoryNode('Educational'),
      CategoryNode('Outdoor'),
      CategoryNode('Creative'),
    ]),
    CategoryNode('Books'),
    CategoryNode('Shoes'),
    CategoryNode('Bags'),
    CategoryNode('Accessories'),
  ]),
  CategoryNode('Electronics'),
  CategoryNode('Sale'),
];

/// Returns the node for a given L1 label, or `null` if not present.
CategoryNode? findCategory(String label) {
  for (final node in mockTaxonomy) {
    if (node.label == label) return node;
  }
  return null;
}

/// Returns the L2 subcategory node under [category] matching [subLabel], or
/// `null` if not present.
CategoryNode? findSubCategory(String category, String subLabel) {
  final parent = findCategory(category);
  if (parent == null) return null;
  for (final child in parent.children) {
    if (child.label == subLabel) return child;
  }
  return null;
}
