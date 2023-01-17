import 'package:app_delivery/providers/categories_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';

class ClientProductListController extends GetxController {
  CategoriesProvider _categoriesProvider = CategoriesProvider();

  List<Category> categories = <Category>[].obs;

  ClientProductListController() {
    getCategories();
  }

  void getCategories() async {
    var result = await _categoriesProvider.getAllCategory();
    categories.clear();
    categories.addAll(result);
  }
}
