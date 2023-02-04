import 'package:app_delivery/pages/client/adress/list/client_address_list_controller.dart';
import 'package:app_delivery/pages/pages.dart';
import 'package:app_delivery/providers/address_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  AddressProvider addressProvider = AddressProvider();

  TextEditingController addressController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController referencePointController = TextEditingController();

  double latRefPoint = 0;
  double lngRefPoint = 0;

  ClientAddressListController _addressListController = Get
      .find(); // Instanciamos el controlador de la lista de direcciones, para actualizar la pagina al agregar una direccion nueva

  void openGoogleMaps(BuildContext context) async {
    Map<String, dynamic> refPointMap = await showMaterialModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => ClientAddressMapPage(),
    );
    referencePointController.text = refPointMap['address'];
    latRefPoint = refPointMap['lat'];
    lngRefPoint = refPointMap['lng'];
  }

  void createAddress() async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;

    if (isValidForm(addressName, neighborhood)) {
      Address address = Address(
          address: addressName,
          neighborhood: neighborhood,
          lat: latRefPoint,
          lng: lngRefPoint,
          idUser: user.id);
      ResponseApi responseApi = await addressProvider.createAdress(address);
      Fluttertoast.showToast(
          msg: '${responseApi.message ?? ''} ', toastLength: Toast.LENGTH_LONG);

      if (responseApi.success == true) {
        address.id = responseApi.data;
        GetStorage().write('address', address.toMap());
        _addressListController
            .update(); // Con el metodo update actualizamos la lista de las direcciones al agregar la nueva
        Get.back();
      }
    }
  }

  bool isValidForm(String address, String neighborhood) {
    if (address.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el nombre de la direccion');
      return false;
    }
    if (neighborhood.isEmpty) {
      Get.snackbar(
          'Formulario no valido', 'Ingresa el nombre de la urbanizacion');
      return false;
    }
    if (latRefPoint == 0) {
      Get.snackbar('Formulario no valido', 'Selecciona el punto de referencia');
    }
    if (lngRefPoint == 0) {
      Get.snackbar('Formulario no valido', 'Selecciona el punto de referencia');
    }
    return true;
  }
}
