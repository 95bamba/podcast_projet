import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/bloc/category/category_event.dart';
import 'package:podcast/bloc/category/category_state.dart';
import 'package:podcast/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc(this._categoryRepository) : super(CategoryInitial()) {
    on<CategoryLoadRequested>(_onCategoryLoadRequested);
    on<CategoryCreateRequested>(_onCategoryCreateRequested);
    on<CategoryUpdateRequested>(_onCategoryUpdateRequested);
    on<CategoryDeleteRequested>(_onCategoryDeleteRequested);
  }

  Future<void> _onCategoryLoadRequested(
    CategoryLoadRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryRepository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onCategoryCreateRequested(
    CategoryCreateRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.createCategory(
        libelle: event.libelle,
        description: event.description,
        image: event.image,
      );
      emit(const CategoryOperationSuccess('Category created successfully'));
      // Reload categories
      add(CategoryLoadRequested());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onCategoryUpdateRequested(
    CategoryUpdateRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.updateCategory(
        uuid: event.uuid,
        libelle: event.libelle,
        description: event.description,
        image: event.image,
      );
      emit(const CategoryOperationSuccess('Category updated successfully'));
      // Reload categories
      add(CategoryLoadRequested());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onCategoryDeleteRequested(
    CategoryDeleteRequested event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.deleteCategory(event.uuid);
      emit(const CategoryOperationSuccess('Category deleted successfully'));
      // Reload categories
      add(CategoryLoadRequested());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
