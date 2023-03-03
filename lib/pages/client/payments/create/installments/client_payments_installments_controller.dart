import 'package:app_delivery/providers/mercado_pago_provider.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_card_token.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_installment.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientPaymentsInstallmentsController extends GetxController {
  final MercadoPagoProvider _mercadoPagoProvider = MercadoPagoProvider();

  List<Product> selectedProducts = <Product>[].obs;
  List<MercadoPagoInstallment> installmentList = <MercadoPagoInstallment>[].obs;
  var total = 0.0.obs;
  var installments = ''.obs;

  final MercadoPagoCardToken _mercadoPagoCardToken =
      MercadoPagoCardToken.fromJson(Get.arguments['card']);

  ClientPaymentsInstallmentsController() {
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
    getInstallments();
  }

  void getInstallments() async {
    if (_mercadoPagoCardToken.firstSixDigits != null) {
      var result = await _mercadoPagoProvider.getAllInstallments(
          _mercadoPagoCardToken.firstSixDigits!, '${total.value}');

      if (result.payerCosts != null) {
        installmentList.clear();
        installmentList.addAll(result.payerCosts!);
      }
    }
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in selectedProducts) {
      total.value = total.value + (product.quantity! * product.price!);
    }
  }
}
