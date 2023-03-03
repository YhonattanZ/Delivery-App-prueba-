import 'package:app_delivery/providers/mercado_pago_provider.dart';
import 'package:app_delivery/src/models/mercado_pago_document_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';

class ClientPaymentsCreateController extends GetxController {
  TextEditingController documentCtrl = TextEditingController();
  var cardNumber = ''.obs;
  var expireDate = ''.obs;
  var cardHolderName = ''.obs;
  var cvvCode = ''.obs;
  var isCvvFocused = true.obs;
  GlobalKey<FormState> keyform = GlobalKey();
  var idDocument = ''.obs;

  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  List<MercadoPagoDocumentType> documents = <MercadoPagoDocumentType>[].obs;

  ClientPaymentsCreateController() {
    getDocumentType();
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
