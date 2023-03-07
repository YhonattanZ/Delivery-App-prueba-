import 'dart:async';

import 'package:app_delivery/pages/pages.dart';
import 'package:app_delivery/providers/categories_provider.dart';
import 'package:app_delivery/providers/products_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductListController extends GetxController {
  CategoriesProvider _categoriesProvider = CategoriesProvider();
  ProductProvider productProvider = ProductProvider();
  List<Product>? selectedProducts = [];
  var items = 0.obs;

  var productName = ''.obs;
  Timer? searchOnTyping;

  List<Category> categories = <Category>[].obs;

  ClientProductListController() {
    getCategories();
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts =
            Product.fromJsonList(GetStorage().read('shopping_bag'));
      }
      for (var element in selectedProducts!) {
        items.value = items.value + (element.quantity!.toInt());
      }
    }
  }

  void onChangeText(String text) {
    const duration = Duration(milliseconds: 800);
    if (searchOnTyping != null) {
      searchOnTyping?.cancel();
    }
    searchOnTyping = Timer(duration, () {
      productName.value = text;
    });
  }

  void getCategories() async {
    var result = await _categoriesProvider.getAllCategory();
    categories.clear();
    categories.addAll(result);
  }

  Future<List<Product>> getProducts(
      String idCategory, String nameProduct) async {
    if (nameProduct.isEmpty) {
      return await productProvider.findByCategory(idCategory);
    } else {
      return await productProvider.findByName(idCategory, nameProduct);
    }
  }

  void goToClientOrderPage() {
    Get.toNamed('/client/orders/create');
  }

  void openModalBottomSheet(Product product, BuildContext context) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientProductDetailPage(
              product: product,
            ));
  }
}
