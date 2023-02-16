import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/restaurant/orders/detail/restaurant_order_detail_controller.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:app_delivery/widgets/nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/relative_time_util.dart';

class RestaurantOrderDetailPage extends StatelessWidget {
  RestaurantOrderDetailPage({super.key});

  final RestaurantOrdersDetailController _ordersDetailController =
      Get.put(RestaurantOrdersDetailController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: kSecondaryColor,
                    blurRadius: 20,
                    offset: Offset(5, 5))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          height: size.height / 2.2,
          child: Column(children: [
            const SizedBox(height: 10),
            _ordersDetailController.order.status == 'PAGADO'
                ? Text('Repartidores disponibles',
                    style: GoogleFonts.lato(
                        color: kSecondaryColor,
                        fontSize: 20,
                        fontStyle: FontStyle.italic))
                : Container(),
            _ordersDetailController.order.status == 'PAGADO'
                ? _dropDownDelivery(_ordersDetailController.users)
                : Container(),
            _dataClient(),
            _addressClient(),
            _dateClient(),
            _dataDelivery(),
            const SizedBox(height: 10),
            _orderButton(context)
          ]),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kSecondaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          title: Text(
            'Orden #${_ordersDetailController.order.id}',
            style: GoogleFonts.lato(
                fontSize: 23,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: _ordersDetailController.order.products!.isNotEmpty
            ? ListView(
                children: _ordersDetailController.order.products!
                    .map((Product product) {
                return _cardProduct(product);
              }).toList())
            : NoDataWidget(
                text: 'No hay ningun producto agregado aun',
              )));
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
            const SizedBox(height: 5),
            Text(
              'Cantidad: ${product.quantity}',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  Widget imageProduct(Product product) {
    return Container(
      height: 55,
      width: 55,
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

  Widget _orderButton(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
              mainAxisAlignment:
                  _ordersDetailController.order.status == 'PAGADO'
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.center,
              children: [
                Text(
                  'Total: ${_ordersDetailController.total.value}\$',
                  style: GoogleFonts.lato(
                      fontSize: 24, fontStyle: FontStyle.italic),
                ),
                SizedBox(width: 10),
                _ordersDetailController.order.status == 'PAGADO'
                    ? Container(
                        height: 50,
                        width: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: kSecondaryColor),
                        child: TextButton(
                            onPressed: () {
                              _ordersDetailController.updateOrder();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Despachar pedido',
                                    style: GoogleFonts.lato(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            )))
                    : Container()
              ]),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> user) {
    List<DropdownMenuItem<String>> list = [];
    for (var element in user) {
      list.add(DropdownMenuItem(
        value: element.id,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: FadeInImage(
                  image: element.image != null
                      ? NetworkImage(element.image!)
                      : const AssetImage('assets/images/no-image.jpg')
                          as ImageProvider,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 50),
                  placeholder: const AssetImage('assets/images/no-image.jpg')),
            ),
            const SizedBox(width: 15),
            Text(element.name ?? '', style: GoogleFonts.lato())
          ],
        ),
      ));
    }
    return list;
  }

  Widget _dropDownDelivery(List<User> user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: DropdownButton(
          underline: Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.arrow_drop_down_circle,
                  color: kPrimaryColor)),
          elevation: 2,
          isExpanded: true,
          hint: Text('Selecciona el repartidor',
              style: GoogleFonts.lato(color: Colors.grey, fontSize: 16)),
          items: _dropDownItems(user),
          value: _ordersDetailController.idDelivery.value == ''
              ? null
              : _ordersDetailController.idDelivery.value,
          onChanged: (value) {
            print('Delivery seleccionado: ${value}');
            _ordersDetailController.idDelivery.value = value.toString();
          }),
    );
  }

  Widget _dataClient() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ListTile(
        title: Text(
          'Información del Cliente',
          style: GoogleFonts.lato(fontSize: 20, fontStyle: FontStyle.italic),
        ),
        subtitle: Text(
          '${_ordersDetailController.order.client?.name} '
          '${_ordersDetailController.order.client?.lastname} - ${_ordersDetailController.order.client?.phone}',
          style: GoogleFonts.lato(
              fontSize: 19,
              fontStyle: FontStyle.italic,
              color: kSecondaryColor),
        ),
        trailing: const Icon(
          Icons.person,
          color: kSecondaryColor,
          size: 32,
        ),
      ),
    );
  }

  Widget _dataDelivery() {
    return _ordersDetailController.order.status != 'PAGADO'
        ? Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: ListTile(
              title: Text(
                'Repartidor asignado',
                style:
                    GoogleFonts.lato(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              subtitle: Text(
                '${_ordersDetailController.order.delivery?.name} '
                '${_ordersDetailController.order.delivery?.lastname} - ${_ordersDetailController.order.delivery?.phone}',
                style: GoogleFonts.lato(
                    fontSize: 19,
                    fontStyle: FontStyle.italic,
                    color: kSecondaryColor),
              ),
              trailing: const Icon(
                Icons.delivery_dining,
                color: kSecondaryColor,
                size: 32,
              ),
            ),
          )
        : Container();
  }

  Widget _addressClient() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        title: Text(
          'Dirección',
          style: GoogleFonts.lato(fontSize: 20, fontStyle: FontStyle.italic),
        ),
        subtitle: Text(
          '${_ordersDetailController.order.address?.address} '
          '${_ordersDetailController.order.address?.neighborhood}',
          style: GoogleFonts.lato(
              fontSize: 19,
              fontStyle: FontStyle.italic,
              color: kSecondaryColor),
        ),
        trailing: const Icon(
          Icons.location_on,
          size: 32,
          color: kSecondaryColor,
        ),
      ),
    );
  }

  Widget _dateClient() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        title: Text(
          'Fecha del pedido',
          style: GoogleFonts.lato(fontSize: 20, fontStyle: FontStyle.italic),
        ),
        subtitle: Text(
          '${RelativeTimeUtil.getRelativeTime(_ordersDetailController.order.timestamp ?? 0)} ',
          style: GoogleFonts.lato(
              fontSize: 19,
              fontStyle: FontStyle.italic,
              color: kSecondaryColor),
        ),
        trailing: const Icon(
          Icons.timer,
          size: 32,
          color: kSecondaryColor,
        ),
      ),
    );
  }
}
