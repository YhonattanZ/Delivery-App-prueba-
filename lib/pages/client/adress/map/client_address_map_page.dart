import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/adress/map/client_address_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatelessWidget {
  ClientAddressMapPage({super.key});

  ClientAddressMapController mapController =
      Get.put(ClientAddressMapController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
              titleSpacing: 25,
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              backgroundColor: kSecondaryColor,
              shadowColor: kPrimaryColor,
              title: Text(
                'Ubica tu dirección en el mapa',
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 21,
                    fontStyle: FontStyle.italic),
              )),
          body: Stack(children: [
            _googleMap(),
            _iconMyLocation(),
            _cardAddress(),
            _buttonAccept(context)
          ]),
        ));
  }

  Widget _buttonAccept(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height / 1.22,
      left: size.width / 5.1,
      child: SizedBox(
        height: size.height * 0.06,
        width: size.width * 0.6,
        child: ElevatedButton(
          onPressed: () {
            mapController.selectRefPoint(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            shape: const StadiumBorder(),
          ),
          child: Text(
            'Confirmar dirección',
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
          child: Text(mapController.addressName.value,
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
      initialCameraPosition: mapController.initialPosition,
      mapType: MapType.normal,
      onMapCreated: mapController.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        mapController.initialPosition = position;
      },
      onCameraIdle: () async {
        await mapController
            .setLocationInfo(); // Obtiene lat y lng de position central del mapa
      },
    );
  }
}
