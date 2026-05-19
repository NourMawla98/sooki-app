import '../../../backend_integration/dtos/category/category_dto.dart';
import '../../../backend_integration/dtos/category/sub_category_dto.dart';

/// Route arguments for [CategoryDetailScreen].
class CategoryDetailArgs {
  final CategoryDto mainCategory;
  final SubCategoryDto? subCategory;

  const CategoryDetailArgs({
    required this.mainCategory,
    this.subCategory,
  });
}
