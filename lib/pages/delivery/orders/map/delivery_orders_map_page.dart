import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/delivery/orders/map/delivery_orders_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryOrdersMapPage extends StatelessWidget {
  DeliveryOrdersMapPage({super.key});

  DeliveryOrderMapController deliverymapController =
      Get.put(DeliveryOrderMapController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() => Scaffold(
          body: Stack(children: [
            SizedBox(height: size.height * 0.62, child: _googleMap()),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buttonBack(), _centerMyLocation()],
                ),
                const Spacer(),
                _CardOrderInfo(context),
              ],
            ),
          ]),
        ));
  }

  Widget _centerMyLocation() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.topRight,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Card(
          shape: const CircleBorder(),
          color: Colors.white,
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching_rounded,
              color: Colors.grey[600],
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonBack() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      alignment: Alignment.topLeft,
      child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          )),
    );
  }

  Widget _CardOrderInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2.6,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: Column(
        children: [
          _listTileAddressInfo(
              deliverymapController.order.address?.neighborhood ?? '',
              'Barrio',
              Icons.my_location),
          _listTileAddressInfo(
              deliverymapController.order.address?.address ?? '',
              'Direccion',
              Icons.location_on),
          const Divider(
            endIndent: 30,
            indent: 30,
            color: Colors.red,
          ),
          _clientInfo(),
          _buttonAccept(context)
        ],
      ),
    );
  }

  Widget _listTileAddressInfo(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(title,
            style: GoogleFonts.lato(fontSize: 20, fontStyle: FontStyle.italic)),
        subtitle: Text(subtitle,
            style: GoogleFonts.lato(fontSize: 17, fontStyle: FontStyle.italic)),
        trailing: Icon(
          icon,
          color: Colors.red[700],
          size: 28,
        ),
      ),
    );
  }

  Widget _clientInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Row(
        children: [
          _imageClient(),
          const SizedBox(width: 10),
          Text(
              '${deliverymapController.order.client?.name} ${deliverymapController.order.client?.lastname}',
              style:
                  GoogleFonts.lato(fontSize: 20, fontStyle: FontStyle.italic)),
          Spacer(),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.phone,
                color: Colors.red[700],
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageClient() {
    return SizedBox(
      height: 55,
      width: 55,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FadeInImage(
          image: deliverymapController.order.client!.image != null
              ? NetworkImage(deliverymapController.order.client!.image!)
              : const AssetImage('assets/images/no-image.jpg') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          placeholder: const AssetImage('assets/images/no-image.jpg'),
        ),
      ),
    );
  }

  Widget _buttonAccept(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height / 1.22,
      left: size.width / 5.1,
      child: SizedBox(
        height: size.height * 0.06,
        width: size.width * 0.8,
        child: ElevatedButton(
          onPressed: () {
            deliverymapController.selectRefPoint(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kSecondaryColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18))),
          ),
          child: Text(
            'Entregar pedido',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _cardAddress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(deliverymapController.addressName.value,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: FontStyle.italic)),
        ),
      ),
    );
  }

  Widget _iconMyLocation() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/marcador.png',
          width: 65,
          height: 65,
        ),
      ),
    );
  }

  Widget _googleMap() {
    return GoogleMap(
      initialCameraPosition: deliverymapController.initialPosition,
      mapType: MapType.normal,
      onMapCreated: deliverymapController.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(deliverymapController.markers.values),
    );
  }
}
