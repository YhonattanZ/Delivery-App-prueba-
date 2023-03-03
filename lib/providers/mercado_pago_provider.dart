import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/mercado_pago_document_type.dart';
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
}
