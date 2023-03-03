import 'package:app_delivery/providers/mercado_pago_provider.dart';
import 'package:app_delivery/src/models/mercado_pago_document_type.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_card_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';

class ClientPaymentsCreateController extends GetxController {
  TextEditingController documentCtrl = TextEditingController();
  var cardNumber = ''.obs;
  var expireDate = ''.obs;
  var cardHolderName = ''.obs;
  var cvvCode = ''.obs;
  var isCvvFocused = false.obs;
  GlobalKey<FormState> keyform = GlobalKey();
  var idDocument = ''.obs;

  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  List<MercadoPagoDocumentType> documents = <MercadoPagoDocumentType>[].obs;

  ClientPaymentsCreateController() {
    getDocumentType();
  }

  void createCardToken() async {
    String documentNumber = documentCtrl.text;
    if (isValidForm(documentNumber)) {
      cardNumber.value = cardNumber.value.replaceAll(' ', '');
      List<String> list = expireDate.split('/');
      int month = int.parse(list[0]);
      String year = '20${list[1]}';
      MercadoPagoCardToken mercadoPagoCardToken =
          await mercadoPagoProvider.createToken(
              cardNumber: cardNumber.value,
              expirationMonth: month,
              expirationYear: year,
              cardHolderName: cardHolderName.value,
              cvv: cvvCode.value,
              documentId: idDocument.value,
              documentNumber: documentNumber);
      Get.toNamed('client/payments/installments',
          arguments: {'card': mercadoPagoCardToken.toJson()});
    }
  }

  bool isValidForm(String documentNumber) {
    if (cardNumber.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el número de tarjeta');
      return false;
    }
    if (expireDate.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa la fecha de vencimiento');
      return false;
    }
    if (cardHolderName.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el nombre del titular');
      return false;
    }
    if (cvvCode.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el código de seguridad');
      return false;
    }
    if (idDocument.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Selecciona el tipo de documento');
      return false;
    }
    if (documentNumber.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el número de documento');
      return false;
    }
    return true;
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber.value = creditCardModel.cardNumber;
    expireDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  void getDocumentType() async {
    var result = await mercadoPagoProvider.getAllDocumentsType();
    documents.clear();
    documents.addAll(result);
  }
}
