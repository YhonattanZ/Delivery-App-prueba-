import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProductDetailController extends GetxController {
  List<Product>? selectedProducts = [];

  ClientProductDetailController() {
//Productos almacenados en sesion
  }

  void checkAddedProducts(Product product, var price, var counter) {
    price.value = product.price!.toDouble();
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts =
            Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      int index = selectedProducts!.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        counter.value = selectedProducts?[index].quantity ?? 0;
        price.value = product.price! * counter.value.toDouble();
        selectedProducts?.forEach((element) {
          print('PRODUCTO: ${element.toMap()}');
        });
      }
    }
  }

  void addToBag(Product product, var price, var counter) {
    if (counter.value > 0) {
      //VALIDAR SI EL PRODUCTO YA FUE AGREGADO CON GET STORAGE
      int index = selectedProducts!.indexWhere((p) => p.id == product.id);
      if (index == -1) {
        if (counter.value > 0) {
          product.quantity = counter.value;
        } else {
          product.quantity ??= 1;
        }

        selectedProducts?.add(product);
      } else {
        selectedProducts?[index].quantity = counter.value;
      } // HA SIDO AGREGADO

      GetStorage().write(
          'shopping_bag',
          selectedProducts!
              .map((e) => e.toMap())
              .toList()); // TODO: ERROR DE GUARDADO DE PRODUCTO

      Fluttertoast.showToast(
          webShowClose: false,
          textColor: kSecondaryColor,
          msg: 'Producto agregado con exito al carrito');
    }
  }

  void AddItem(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = product.price! * counter.value.toDouble();
  }

  void removeItem(Product product, var price, var counter) {
    if (counter.value > 0) {
      counter.value = counter.value - 1;
      price.value = product.price! * counter.value.toDouble();
    }
  }
}
