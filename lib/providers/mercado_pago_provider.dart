import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/mercado_pago_document_type.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_card_token.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_payment_method_installments.dart';
import 'package:get/get.dart';

class MercadoPagoProvider extends GetConnect {
  String url = Environment.API_MERCADOPAGO;

  //Traer todos los documentos validos

  Future<List<MercadoPagoDocumentType>> getAllDocumentsType() async {
    Response res = await get('$url/identification_types', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Environment.Token_Acceso_Mercadopago}'
    });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada', 'No posee autorizacion');
      return [];
    }

    List<MercadoPagoDocumentType> documents =
        MercadoPagoDocumentType.fromJsonList(res.body);

    return documents;
  }

  Future<MercadoPagoPaymentMethodInstallments> getAllInstallments(
      String bin, String amount) async {
    Response res = await get('$url/payment_methods/installments', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Environment.Token_Acceso_Mercadopago}'
    }, query: {
      'bin': bin,
      'amount': amount
    });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada',
          'Su usuario no tiene permitido leer esta informacion');
      return MercadoPagoPaymentMethodInstallments();
    }
    if (res.statusCode != 200) {
      Get.snackbar('Peticion negada',
          'Su usuario no tiene permitido leer esta informacion');
      return MercadoPagoPaymentMethodInstallments();
    }

    MercadoPagoPaymentMethodInstallments documents =
        MercadoPagoPaymentMethodInstallments.fromJson(res.body[0]);

    return documents;
  }

//Crear token de MercadoPago
  Future<MercadoPagoCardToken> createToken(
      {String? cvv,
      String? expirationYear,
      int? expirationMonth,
      String? cardNumber,
      String? cardHolderName,
      String? documentNumber,
      String? documentId}) async {
    Response res = await post(
        '$url/card_tokens?public_key=${Environment.Public_Key_Mercadopago}', {
      'security_code': cvv,
      'expiration_year': expirationYear,
      'expiration_month': expirationMonth,
      'card_number': cardNumber,
      'cardholder': {
        'name': cardHolderName,
        'identification': {'number': documentNumber, 'type': documentId}
      }
    },
        headers: {
          'Content-Type': 'application/json',
        });
    if (res.statusCode != 201) {
      Get.snackbar('Error', 'No se pudo validar la tarjeta');
    }
    MercadoPagoCardToken response = MercadoPagoCardToken.fromJson(res.body);
    return response;
  }
}
