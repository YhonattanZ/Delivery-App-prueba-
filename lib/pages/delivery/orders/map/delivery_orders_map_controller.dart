import 'dart:async';
import 'package:app_delivery/providers/orders_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class DeliveryOrderMapController extends GetxController {
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

  DeliveryOrderMapController() {
    print('ORDEN: ${order.toMap()}');

    checkGpsEnabled(); //Verifica el gps si esta activado
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

  void updateLocation() async {
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();
      //Guardar coordenadas del delivery
      saveLocation();

      animateCameraPosition(
          position?.latitude ?? 10.5118637, position?.longitude ?? -66.963071);
      //Marcador Delivery
      addMarker('Delivery', position!.latitude, position!.longitude,
          'Posicion actual', '', deliveryMarker!);
      //Marcador Sitio de Entrega
      addMarker(
          'Home',
          order.address?.lat ?? 10.5118637,
          order.address?.lng ?? -66.963071,
          'Lugar de entrega',
          '',
          homeMarker!);

      LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.best, distanceFilter: 1);

      positionSub =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position pos) {
        //Posicion en tiempo real
        position = pos;
        addMarker('Delivery', position!.latitude, position!.longitude,
            'Posicion actual', '', deliveryMarker!);
        animateCameraPosition(position?.latitude ?? 10.5118637,
            position?.longitude ?? -66.963071);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void saveLocation() async {
    if (position != null) {
      order.lat = position?.latitude;
      order.lng = position?.longitude;
      await _ordersProvider.updateLatLng(order);
    }
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
      print('Error en Google Map');
    } else {}
  }

  @override
  void onClose() {
    super.onClose();
    positionSub?.cancel();
  }
}
