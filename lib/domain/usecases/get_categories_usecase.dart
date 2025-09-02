import '../entities/category_entity.dart';
import '../repositories/music_repository.dart';

/// Use case for getting all music categories
class GetCategoriesUseCase {
  final MusicRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<List<CategoryEntity>> call() async {
    try {
      return await _repository.getCategories();
    } catch (e) {
      throw Exception('Failed to load categories: ${e.toString()}');
    }
  }
}
