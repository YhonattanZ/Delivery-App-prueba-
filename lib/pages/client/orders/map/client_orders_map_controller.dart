import 'dart:async';
import 'dart:developer';

import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/providers/orders_provider.dart';
import 'package:app_delivery/src/models/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';

class ClientOrderMapController extends GetxController {
  Socket socket = io('${Environment.API_URL}orders/delivery', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  Order order = Order.fromMap(Get.arguments['order'] ?? {});
  OrdersProvider _ordersProvider = OrdersProvider();
  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(10.5118637, -66.963071), zoom: 14);

  LatLng? addressLatLng;
  var addressName = ''.obs;

  Completer<GoogleMapController> googleMapController = Completer();
  Position? position;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  StreamSubscription? positionSub;

  Set<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> points = [];

//Polyline

  ClientOrderMapController() {
    print('ORDEN: ${order.toMap()}');

    checkGpsEnabled(); //Verifica el gps si esta activado
    connectSocketIO(); //Conecta con SOCKET IO
  }

  void connectSocketIO() {
    socket.connect();
    socket.onConnect(
        (data) => {print('Este dispositivo se conecto a Socket IO')});
    listenPosition();
    listenDelivered();
  }

  void listenPosition() {
    socket.on('position/${order.id}', (data) {
      addMarker('Delivery', data['lat'], data['lng'], 'Delivery asignado', '',
          deliveryMarker!);
    });
  }

  void listenDelivered() {
    socket.on('delivered/${order.id}', (data) {
      Fluttertoast.showToast(
          msg: 'El estado de la orden se ha actualizado',
          toastLength: Toast.LENGTH_LONG);
      Get.offNamedUntil('/client/home', (route) => false);
    });
  }

  Future setLocationInfo() async {
    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> placemark = await placemarkFromCoordinates(lat, lng);
    if (placemark.isNotEmpty) {
      String direction = placemark[0].thoroughfare ?? '';
      String street = placemark[0].subThoroughfare ?? '';
      String city = placemark[0].locality ?? '';
      String department = placemark[0].administrativeArea ?? '';
      String country = placemark[0].country ?? '';
      addressName.value = '$direction #$street, $city, $department';
      addressLatLng = LatLng(lat, lng);
    }
  }

  void selectRefPoint(BuildContext context) {
    if (addressLatLng != null) {
      Map<String, dynamic> data = {
        'address': addressName.value,
        'lat': addressLatLng!.latitude,
        'lng': addressLatLng!.longitude
      };
      Navigator.pop(context, data);
    }
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content));
    markers[id] = marker;
    update();
  }

  void checkGpsEnabled() async {
    deliveryMarker =
        await createMarkerFromAssets('assets/images/marcador2.png');
    homeMarker = await createMarkerFromAssets('assets/images/marcador2.png');
    bool isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (isGpsEnabled == true) {
      updateLocation();
    } else {
      Future<bool> locationGps = location.Location().requestService();
      // ignore: unrelated_type_equality_checks
      if (locationGps == true) {
        updateLocation();
      }
    }
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints()
        .getRouteBetweenCoordinates(Environment.apiKeyMaps, pointFrom, pointTo);

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: kSecondaryColor,
        points: points,
        width: 5);

    polylines.add(polyline);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();
      //Guardar coordenadas del delivery

      animateCameraPosition(order.lat ?? 10.5118637, order.lng ?? -66.963071);
      //Marcador Delivery
      addMarker('Delivery', order.lat ?? 10.5118637, order.lng ?? -66.963071,
          'Delivery asignado', '', deliveryMarker!);
      //Marcador Sitio de Entrega
      addMarker(
          'Home',
          order.address?.lat ?? 10.5118637,
          order.address?.lng ?? -66.963071,
          'Lugar de entrega',
          '',
          homeMarker!);

      LatLng from = LatLng(position!.latitude, position!.longitude);
      LatLng to = LatLng(
          order.address?.lat ?? 10.5118637, order.address?.lng ?? -66.963071);

      setPolylines(from, to);
    } catch (e) {
      print('Error: $e');
    }
  }

  void centerPosition() {
    animateCameraPosition(position!.latitude, position!.longitude);
  }

  void callNumber() async {
    String number = order.delivery?.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 14, bearing: 0)));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void onMapCreate(GoogleMapController controller) {
    if (!googleMapController.isCompleted) {
      print('Error en Google Map ');
    } else {}
  }

  @override
  void onClose() {
    super.onClose();
    positionSub?.cancel();
    socket.disconnect();
  }
}
