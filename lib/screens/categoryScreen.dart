import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/blocs/categoryBloc/category_bloc.dart';
import 'package:pos_frontend/blocs/categoryBloc/category_event.dart';
import 'package:pos_frontend/blocs/categoryBloc/category_state.dart';
import 'package:pos_frontend/models/categoryModel/categoryEntity.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';

class CategoryScreen extends StatefulWidget {
  final ApiService apiService;

  const CategoryScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    _categoryBloc = CategoryBloc(apiService: widget.apiService);
    _categoryBloc.add(LoadCategories());
  }

  @override
  void dispose() {
    _categoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoryBloc,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Categories'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddCategoryDialog(context),
              ),
            ],
          ),
          drawer: SidebarScreen(apiService: widget.apiService),
          body: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CategoryError) {
                return Center(child: Text(state.message));
              }
              if (state is CategoryLoaded) {
                return _buildCategoryList(context, state.categories);
              }
              return const Center(child: Text('No categories found'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(
      BuildContext context, List<CategoryEntity> categories) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Edit'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('Delete'),
                  value: 'delete',
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditCategoryDialog(context, category);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, category);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext parentContext) {
    final nameController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                parentContext.read<CategoryBloc>().add(
                      AddCategory(name: nameController.text),
                    );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(
      BuildContext parentContext, CategoryEntity category) {
    final nameController = TextEditingController(text: category.name);

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && category.id != null) {
                parentContext.read<CategoryBloc>().add(
                      UpdateCategory(
                        id: category.id!,
                        name: nameController.text,
                      ),
                    );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext parentContext, CategoryEntity category) {
    if (category.id == null) return;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete ${category.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              parentContext
                  .read<CategoryBloc>()
                  .add(DeleteCategory(id: category.id!));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
