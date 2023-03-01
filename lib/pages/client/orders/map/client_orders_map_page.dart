import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/orders/map/client_orders_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientOrdersMapPage extends StatelessWidget {
  ClientOrdersMapPage({super.key});

  ClientOrderMapController clientmapController =
      Get.put(ClientOrderMapController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<ClientOrderMapController>(
        builder: (value) => Scaffold(
              body: Stack(children: [
                SizedBox(height: size.height * 0.64, child: _googleMap()),
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
      onTap: () {
        clientmapController.centerPosition();
      },
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
      height: size.height / 2.75,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: [
            _listTileAddressInfo(
                clientmapController.order.address?.neighborhood ?? '',
                'Barrio',
                Icons.my_location),
            _listTileAddressInfo(
                clientmapController.order.address?.address ?? '',
                'Direccion',
                Icons.location_on),
            const Divider(
              endIndent: 20,
              indent: 20,
              color: Colors.red,
            ),
            _deliveryInfo(),
          ],
        ),
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

  Widget _deliveryInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Row(
        children: [
          _imageClient(),
          const SizedBox(width: 15),
          Text(
              '${clientmapController.order.delivery?.name} ${clientmapController.order.delivery?.lastname}',
              style:
                  GoogleFonts.lato(fontSize: 20, fontStyle: FontStyle.italic)),
          Spacer(),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white),
            child: IconButton(
              onPressed: () {
                clientmapController.callNumber();
              },
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
          image: clientmapController.order.delivery!.image != null
              ? NetworkImage(clientmapController.order.delivery!.image!)
              : const AssetImage('assets/images/no-image.jpg') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          placeholder: const AssetImage('assets/images/no-image.jpg'),
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
          child: Text(clientmapController.addressName.value,
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
        initialCameraPosition: clientmapController.initialPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          clientmapController.googleMapController.complete(controller);
        },
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        markers: Set<Marker>.of(clientmapController.markers.values),
        polylines: clientmapController.polylines);
  }
}
