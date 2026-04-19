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
    CategoryNode('Accessories', [
      CategoryNode('Bags'),
      CategoryNode('Jewelry'),
      CategoryNode('Belts'),
    ]),
  ]),
  CategoryNode('Men', [
    CategoryNode('Tops', [
      CategoryNode('Shirts'),
      CategoryNode('Tees'),
      CategoryNode('Knitwear'),
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
    CategoryNode('Accessories', [
      CategoryNode('Watches'),
      CategoryNode('Belts'),
      CategoryNode('Wallets'),
    ]),
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
