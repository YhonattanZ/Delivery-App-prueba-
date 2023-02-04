import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/adress/list/client_address_list_controller.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:app_delivery/widgets/nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientAddressListPage extends StatelessWidget {
  ClientAddressListPage({super.key});

  ClientAddressListController addressListController =
      Get.put(ClientAddressListController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
            'Mis direcciones',
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 21, fontStyle: FontStyle.italic),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  addressListController.goToCreateAdress();
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        body: GetBuilder<ClientAddressListController>(
            builder: (value) => Stack(
                  children: [_textSelectAddress(), _listAddress()],
                )));
  }

  Widget _listAddress() {
    return FutureBuilder(
      future: addressListController.getAddress(),
      builder: (context, AsyncSnapshot<List<Address>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              itemBuilder: (_, index) {
                return _radioSelectorAddress(snapshot.data![index], index);
              },
            );
          } else {
            return Center(
                child: NoDataWidget(text: 'No hay direcciones agregadas'));
          }
        } else {
          return Center(
              child: NoDataWidget(text: 'No hay direcciones agregadas'));
        }
      },
    );
  }

  Widget _radioSelectorAddress(Address address, int index) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Radio(
                      value: index,
                      groupValue: addressListController.radioValue.value,
                      activeColor: const Color(0xff477AAA),
                      onChanged: addressListController.handleRadioValueChange),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    address.address ?? '',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    address.neighborhood ?? '',
                    style: GoogleFonts.lato(
                        fontSize: 19,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal),
                  ),
                ])
              ],
            ),
          ],
        ));
  }

  Widget _textSelectAddress() {
    return Container(
      margin: const EdgeInsets.only(left: 25, top: 20),
      child: Text(
        'Elige donde recibir tu pedido',
        style: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            fontSize: 21,
            color: Colors.black),
      ),
    );
  }
}
