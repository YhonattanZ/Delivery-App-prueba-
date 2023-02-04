import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:app_delivery/widgets/nodata_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientOrderCreatePage extends StatelessWidget {
  ClientOrderCreatePage({super.key});

  ClientOrdersCreateController ordersCreateController =
      Get.put(ClientOrdersCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          bottomNavigationBar: SizedBox(
            height: 100,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Total: ${ordersCreateController.total.value}\$',
                        style: GoogleFonts.lato(
                            fontSize: 22, fontStyle: FontStyle.italic),
                      ),
                      Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: kSecondaryColor),
                          child: TextButton(
                              onPressed: () {
                                ordersCreateController.goToAdressListPage();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Confirmar pedido',
                                      style: GoogleFonts.lato(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                              )))
                    ]),
              ],
            ),
          ),
          appBar: AppBar(
              backgroundColor: kSecondaryColor,
              title: Text(
                'Mis pedidos',
                style:
                    GoogleFonts.lato(fontStyle: FontStyle.italic, fontSize: 22),
              )),
          body: ordersCreateController.selectedProducts.isNotEmpty
              ? ListView(
                  children: ordersCreateController.selectedProducts
                      .map((Product product) {
                  return _cardProduct(product);
                }).toList())
              : NoDataWidget(
                  text: 'No hay ningun producto agregado aun',
                )),
    );
  }

  Widget imageProduct(Product product) {
    return Container(
      height: 85,
      width: 85,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : const AssetImage('assets/images/no-image.jpg') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          placeholder: const AssetImage('assets/images/no-image.jpg'),
        ),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        imageProduct(product),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name ?? '',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            _quantityButtons(product),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            _productPrice(product),
            _deleteIcon(product),
          ],
        ),
      ],
    );
  }

  Widget _deleteIcon(Product product) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: IconButton(
          onPressed: () {
            ordersCreateController.deleteItem(product);
          },
          icon: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          )),
    );
  }

  Widget _productPrice(Product product) {
    return Container(
      margin: const EdgeInsets.only(top: 15, right: 20),
      child: Text(
        '${product.price! * product.quantity!}\$',
        style: GoogleFonts.lato(color: kSecondaryColor, fontSize: 18),
      ),
    );
  }

  Widget _quantityButtons(Product product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            ordersCreateController.removeItem(product);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            decoration: const BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            child: Text(
              '-',
              style: GoogleFonts.lato(color: Colors.white),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: kSecondaryColor,
          child: Text('${product.quantity ?? 0}',
              style: GoogleFonts.lato(color: Colors.white)),
        ),
        GestureDetector(
          onTap: () {
            ordersCreateController.addItem(product);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            decoration: const BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            child: Text('+', style: GoogleFonts.lato(color: Colors.white)),
          ),
        )
      ],
    );
  }
}
