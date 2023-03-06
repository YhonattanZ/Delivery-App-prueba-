import 'package:app_delivery/pages/client/products/list/client_product_list_controller.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientOrdersCreateController extends GetxController {
  List<Product> selectedProducts = <Product>[].obs;
  var total = 0.0.obs;
  final ClientProductListController _clientProductListController = Get.find();

  ClientOrdersCreateController() {
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        var result = GetStorage().read('shopping_bag');
        selectedProducts.clear();
        selectedProducts.addAll(result);
      } else {
        var result = Product.fromJsonList(GetStorage().read('shopping_bag'));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
    }
    getTotal();
  }
  void goToAdressListPage() {
    Get.toNamed('/client/address/list');
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in selectedProducts) {
      total.value = total.value + (product.quantity! * product.price!);
    }
  }

  void deleteItem(Product product) {
    selectedProducts.remove(product);
    GetStorage()
        .write('shopping_bag', selectedProducts.map((e) => e.toMap()).toList());
    getTotal();
    _clientProductListController.items.value = 0;
    if (selectedProducts.isEmpty) {
      _clientProductListController.items.value = 0;
    } else {
      for (var element in selectedProducts) {
        _clientProductListController.items.value =
            _clientProductListController.items.value +
                (element.quantity!.toInt());
      }
    }
  }

  void addItem(Product product) {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.remove(product);
    product.quantity = product.quantity! + 1;
    selectedProducts.insert(index, product);
    GetStorage()
        .write('shopping_bag', selectedProducts.map((e) => e.toMap()).toList());
    getTotal();
    //Antes de realizar el recorrido de valores, se regresa el valor a 0
    _clientProductListController.items.value = 0;
    //Este for loop recorre los items añadidos en la lista y muestra la cantidad en la bolsa de compra
    for (var element in selectedProducts) {
      _clientProductListController.items.value =
          _clientProductListController.items.value +
              (element.quantity!.toInt());
    }
  }

  void removeItem(Product product) {
    if (product.quantity! > 1) {
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      selectedProducts.remove(product);
      product.quantity = product.quantity! - 1;
      selectedProducts.insert(index, product);
      GetStorage().write(
          'shopping_bag', selectedProducts.map((e) => e.toMap()).toList());
      getTotal();
      _clientProductListController.items.value = 0;
      for (var element in selectedProducts) {
        _clientProductListController.items.value =
            _clientProductListController.items.value +
                (element.quantity!.toInt());
      }
    }
  }
}
