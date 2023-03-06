import 'dart:convert';

import 'package:app_delivery/providers/mercado_pago_provider.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_card_token.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_installment.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_payment.dart';
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
    Response response = await _mercadoPagoProvider.createPayment(
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

    if (response.statusCode == 201) {
      ResponseApi responseApi = ResponseApi.fromJson(response.body);
      //En caso de exito, se retornara toda la informacion de mecado pago
      MercadoPagoPayment mercadoPagoPayment =
          MercadoPagoPayment.fromJson(responseApi.data);
      GetStorage().remove('shopping_bag');
      Get.offNamedUntil('client/payments/status', (route) => false, arguments: {
        'mercadopago_payment': mercadoPagoPayment.toJson(),
      });
      //En caso de fallar, se retornara el error especifico
    } else if (response.statusCode == 501) {
      final data = json.decode(response.body);
      if (data['err']['status'] == 400) {
        badRequestProcess(data);
      } else {
        badTokenProcess(data['status'], methodInstallments!);
      }
    }
  }

  void badRequestProcess(dynamic data) {
    Map<String, String> paymentErrorCodeMap = {
      '3034': 'Informacion de la tarjeta invalida',
      '3033': 'La longitud de digitos de tu tarjeta es erróneo',
      '205': 'Ingresa el número de tu tarjeta',
      '208': 'Digita un mes de expiración',
      '209': 'Digita un año de expiración',
      '212': 'Ingresa tu documento',
      '213': 'Ingresa tu documento',
      '214': 'Ingresa tu documento',
      '220': 'Ingresa tu banco emisor',
      '221': 'Ingresa el nombre y apellido',
      '224': 'Ingresa el código de seguridad',
      'E301': 'Hay algo mal en el número. Vuelve a ingresarlo.',
      'E302': 'Revisa el código de seguridad',
      '316': 'Ingresa un nombre válido',
      '322': 'Revisa tu documento',
      '323': 'Revisa tu documento',
      '324': 'Revisa tu documento',
      '325': 'Revisa la fecha',
      '326': 'Revisa la fecha'
    };
    String? errorMessage;
    print('CODIGO ERROR ${data['cause'][0]['code']}');

    if (paymentErrorCodeMap.containsKey('${data['cause'][0]['code']}')) {
      print('ENTRO IF');
      errorMessage = paymentErrorCodeMap['${data['cause'][0]['code']}'];
    } else {
      errorMessage = 'No pudimos procesar tu pago';
    }
    Get.snackbar('Error con tu informacion', errorMessage ?? '');
    // Navigator.pop(context);
  }

  void badTokenProcess(
      String status, MercadoPagoPaymentMethodInstallments installments) {
    Map<String, String> badTokenErrorCodeMap = {
      '106': 'No puedes realizar pagos a usuarios de otros paises.',
      '109':
          '${installments.paymentMethodId} no procesa pagos en ${this.installments.value} cuotas',
      '126': 'No pudimos procesar tu pago.',
      '129':
          '${installments.paymentMethodId} no procesa pagos del monto seleccionado.',
      '145': 'No pudimos procesar tu pago',
      '150': 'No puedes realizar pagos',
      '151': 'No puedes realizar pagos',
      '160': 'No pudimos procesar tu pago',
      '204':
          '${installments.paymentMethodId} no está disponible en este momento.',
      '801':
          'Realizaste un pago similar hace instantes. Intenta nuevamente en unos minutos',
    };
    String? errorMessage;
    if (badTokenErrorCodeMap.containsKey(status.toString())) {
      errorMessage = badTokenErrorCodeMap[status];
    } else {
      errorMessage = 'No pudimos procesar tu pago';
    }
    Get.snackbar('Error en la transaccion', errorMessage ?? '');
    // Navigator.pop(context);
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
