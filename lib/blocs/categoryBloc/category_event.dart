abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;

  AddCategory({required this.name});
}

class UpdateCategory extends CategoryEvent {
  final int id;
  final String name;

  UpdateCategory({
    required this.id,
    required this.name,
  });
}

class DeleteCategory extends CategoryEvent {
  final int id;

  DeleteCategory({required this.id});
} 