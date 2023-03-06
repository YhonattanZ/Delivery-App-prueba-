import 'package:app_delivery/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final ClientPaymentStatusControllers _statusControllers =
    Get.put(ClientPaymentStatusControllers());

class ClientPaymentStatusPage extends StatelessWidget {
  const ClientPaymentStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(children: [
          _backgroundColor(context),
          _CreateNewAccountBox(context),
          Column(
            children: [
              SizedBox(height: size.height * 0.050),
              _statusControllers.mercadoPagoPayment.status == 'approved'
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 100,
                    )
                  : const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 100,
                    ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                    _statusControllers.mercadoPagoPayment.status == 'approved'
                        ? 'Transacción exitosa'
                        : 'Transacción fallida',
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 26))
              ]),
            ],
          ),
        ]),
      ),
    );
  }
}

Widget _CreateNewAccountBox(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Stack(children: [
    //Container blanco
    Container(
      margin: EdgeInsets.only(top: size.height * 0.25),
      decoration: BoxDecoration(boxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black38, spreadRadius: 3, blurRadius: 10)
      ], color: Colors.white, borderRadius: BorderRadius.circular(40)),
      width: double.infinity,
      height: size.height * 0.5,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: size.height * 0.030),
            child: Text('Detalles de la transacción:',
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w400)),
          ),
          _transactionDetail(context),
          _transactionStatus(context),
          SizedBox(height: size.height * 0.060),
          _actualizarCategoriaButton(context),
        ],
      ),
    ),
  ]);
}

Widget _backgroundColor(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.30,
    color: const Color.fromARGB(255, 43, 136, 134),
  );
}

Widget _actualizarCategoriaButton(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: size.height / 50),
        child: SizedBox(
          height: size.height * 0.07,
          width: size.width * 0.6,
          child: ElevatedButton(
            onPressed: () {
              _statusControllers.finishShopping();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 43, 136, 134),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'Finalizar compra',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _transactionDetail(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return Container(
      margin: EdgeInsets.only(
          top: size.height / 25,
          right: size.width * 0.05,
          left: size.width * 0.05),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Text(
              _statusControllers.mercadoPagoPayment.status == 'approved'
                  ? 'Orden procesada con éxito usando : ${_statusControllers.mercadoPagoPayment.paymentMethodId?.toUpperCase()} **** ${_statusControllers.mercadoPagoPayment.card?.lastFourDigits}'
                  : 'Tu pago fue rechazado',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic)),
        ],
      ));
}

Widget _transactionStatus(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return Container(
      margin: EdgeInsets.symmetric(
          vertical: size.height / 25, horizontal: size.width * 0.05),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Text(
              _statusControllers.mercadoPagoPayment.status == 'approved'
                  ? 'Chequea el estado de tu compra en el apartado Mis pedidos'
                  : _statusControllers.errorMessage.value,
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic)),
        ],
      ));
}
