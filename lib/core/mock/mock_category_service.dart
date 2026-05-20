import '../../shared/models/category_model.dart';
import 'mock_data.dart';

class MockCategoryService {
  static const _delay = Duration(milliseconds: 400);

  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(_delay);
    return List.from(MockData.categories);
  }
}
