import 'dart:convert';
import 'dart:developer';

import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OrdersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/orders';

  final User _user = User.fromJson(GetStorage().read('user') ?? {});

//Listar categorias
  Future<List<Order>> findByStatus(String status) async {
    Response res = await get('$url/findByStatus/$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada', 'No posee autorizacion');
      return [];
    }

    List<Order> orders = Order.fromJsonList(res.body);

    return orders;
  }

  Future<List<Order>> findByDeliveryAndStatus(
      String idDelivery, String status) async {
    Response res = await get('$url/findByDeliveryAndStatus/$idDelivery/$status',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _user.sessionToken ?? ''
        });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada', 'No posee autorizacion');
      return [];
    }

    List<Order> orders = Order.fromJsonList(res.body);

    return orders;
  }

  Future<List<Order>> findByClientAndStatus(
      String idClient, String status) async {
    Response res = await get('$url/findByClientAndStatus/$idClient/$status',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _user.sessionToken ?? ''
        });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada', 'No posee autorizacion');
      return [];
    }

    List<Order> orders = Order.fromJsonList(res.body);

    return orders;
  }

//Crear categorias
  Future<ResponseApi> createOrder(Order order) async {
    Response res = await post('$url/create', order.toMap(), headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(res.body);
    return responseApi;
  }

  Future<ResponseApi> updateToDispatched(Order order) async {
    Response res = await put('$url/updateToDispatched', order.toMap(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _user.sessionToken ?? ''
        });
    ResponseApi responseApi = ResponseApi.fromJson(res.body);
    return responseApi;
  }

  Future<ResponseApi> updateToOnTheWay(Order order) async {
    Response res = await put('$url/updateToOnTheWay', order.toMap(), headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(res.body);
    return responseApi;
  }

  Future<ResponseApi> updateLatLng(Order order) async {
    Response res = await put('$url/updateLatLng', order.toMap(), headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(res.body);

    return responseApi;
  }
}
