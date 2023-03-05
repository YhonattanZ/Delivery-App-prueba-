import 'package:app_delivery/providers/address_provider.dart';
import 'package:app_delivery/providers/orders_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddressListController extends GetxController {
  List<Address> address = [];
  final AddressProvider _addressProvider = AddressProvider();
  final OrdersProvider _ordersProvider = OrdersProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});

  var radioValue = 0.obs;

  ClientAddressListController() {
    print('DIRECCION SELECCIONADA ${GetStorage().read('address')}');
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.findByUser(user.id ?? '');
    Address a = Address.fromMap(GetStorage().read('address') ??
        {}); //Direccion seleccionada ?Failed to encode a encodable object
    int index = address.indexWhere((element) => element.id == a.id);
    if (index != -1) {
      //La direccion de la sesion almacenada coincide con la lista de direcciones
      radioValue.value = index;
    }
    return address;
  }

  void createOrder() async {
    Get.toNamed('client/payments/create');
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    GetStorage().write('address', address[value].toMap());
    update(); //Actualizamos la data para guardar la nueva pagina
  }

  void goToCreateAdress() {
    Get.toNamed('/client/address/create');
  }
}
