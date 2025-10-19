import 'dart:io';
import 'package:podcast/models/category.dart';
import 'package:podcast/services/api_service.dart';

class CategoryRepository {
  final ApiService _apiService;

  CategoryRepository(this._apiService);

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.get('/category');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }

  Future<Category> getCategoryById(String uuid) async {
    try {
      final response = await _apiService.get('/category/$uuid');

      if (response.statusCode == 200) {
        return Category.fromJson(response.data);
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      throw Exception('Error loading category: $e');
    }
  }

  Future<Category> createCategory({
    required String libelle,
    required String description,
    File? image,
  }) async {
    try {
      final fields = {
        'libelle': libelle,
        'description': description,
      };

      final response = await _apiService.uploadFile(
        '/category',
        fields,
        image,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Category.fromJson(response.data);
      } else {
        throw Exception('Failed to create category');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  Future<Category> updateCategory({
    required String uuid,
    required String libelle,
    required String description,
    File? image,
  }) async {
    try {
      final fields = {
        'libelle': libelle,
        'description': description,
      };

      final response = await _apiService.uploadFile(
        '/category/$uuid',
        fields,
        image,
      );

      if (response.statusCode == 200) {
        return Category.fromJson(response.data);
      } else {
        throw Exception('Failed to update category');
      }
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String uuid) async {
    try {
      final response = await _apiService.delete('/category/$uuid');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete category');
      }
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }
}
