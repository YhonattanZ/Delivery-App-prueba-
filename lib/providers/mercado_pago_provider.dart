import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/mercado_pago_document_type.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_card_token.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_payment_method_installments.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MercadoPagoProvider extends GetConnect {
  final User _user = User.fromJson(GetStorage().read('user') ?? {});

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

  Future<Response> createPayment({
    required String? token,
    required String? paymentMethodId,
    required String? paymentTypeID,
    required String? emailClient,
    required String? issuerID,
    required String? identificationType,
    required String? identificationNumber,
    required int? installments,
    required double? transactionAmount,
    required Order? order,
  }) async {
    Response res = await post('${Environment.API_URL}api/payments/create', {
      'token': token,
      'issuer_id': issuerID,
      'payment_method_id': paymentMethodId,
      'transaction_amount': transactionAmount,
      'installments': installments,
      'payer': {
        'email': emailClient,
        'identification': {
          'type': identificationType,
          'number': identificationNumber,
        },
      },
      'order': order!.toMap()
    }, headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    print('RESPONSE: ${res.body}');
    print('STATUS CODE: ${res.statusCode}');

    return res;
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
