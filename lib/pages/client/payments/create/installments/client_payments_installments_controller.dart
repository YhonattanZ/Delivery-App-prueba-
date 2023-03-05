import 'package:app_delivery/providers/mercado_pago_provider.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_card_token.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_installment.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_payment_method_installments.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientPaymentsInstallmentsController extends GetxController {
  final MercadoPagoProvider _mercadoPagoProvider = MercadoPagoProvider();
  final User _user = User.fromJson(GetStorage().read('user') ?? {});

  List<Product> selectedProducts = <Product>[].obs;
  MercadoPagoPaymentMethodInstallments? methodInstallments;
  List<MercadoPagoInstallment> installmentList = <MercadoPagoInstallment>[].obs;
  var total = 0.0.obs;
  var installments = ''.obs;

//Arguments traidos de create Installments
  final MercadoPagoCardToken _mercadoPagoCardToken =
      MercadoPagoCardToken.fromJson(Get.arguments['card']);
  String identificationNumber = Get.arguments['identification_number'];
  String identificationType = Get.arguments['identification_type'];

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

  void createPayment() async {
    if (installments.value.isEmpty) {
      Get.snackbar('No valido', 'Selecciona una cantidad de cuotas');
      return;
    }
    Address a = Address.fromMap(GetStorage().read('address') ?? {});
    List<Product> products =
        Product.fromJsonList(GetStorage().read('shopping_bag'));
    Order order =
        Order(idClient: _user.id, idAddress: a.id, products: products);
    ResponseApi responseApi = await _mercadoPagoProvider.createPayment(
        token: _mercadoPagoCardToken.id,
        paymentMethodId: methodInstallments!.paymentMethodId,
        paymentTypeID: methodInstallments!.paymentTypeId,
        emailClient: _user.email,
        issuerID: methodInstallments!.issuer!.id,
        identificationType: identificationType,
        identificationNumber: identificationNumber,
        installments: int.parse(installments.value),
        transactionAmount: total.value,
        order: order);
    Get.snackbar('TOKEN', '${_mercadoPagoCardToken.id}');
    Fluttertoast.showToast(msg: responseApi.message ?? '');
    if (responseApi.success == true) {
      GetStorage().remove('shopping_bag');
    }
    Get.toNamed('client/payments/status');
  }

//Obtener cuotas de pago
  void getInstallments() async {
    if (_mercadoPagoCardToken.firstSixDigits != null) {
      var result = await _mercadoPagoProvider.getAllInstallments(
          _mercadoPagoCardToken.firstSixDigits!, '${total.value}');

      methodInstallments = result;
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
