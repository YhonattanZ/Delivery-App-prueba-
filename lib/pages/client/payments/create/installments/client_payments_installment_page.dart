import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/payments/create/installments/client_payments_installments_controller.dart';
import 'package:app_delivery/src/models/mercadopago_models/mercado_pago_installment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientPaymentsInstallmentsPage extends StatelessWidget {
  ClientPaymentsInstallmentsPage({super.key});

  ClientPaymentsInstallmentsController _clientPaymentsInstallCtrl =
      Get.put(ClientPaymentsInstallmentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: buttonConfirm(context),
          appBar: AppBar(
              backgroundColor: kSecondaryColor,
              title: Text(
                'Cuotas',
                style:
                    GoogleFonts.lato(fontStyle: FontStyle.italic, fontSize: 22),
              )),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textDescription(),
              _dropDownInstallments(_clientPaymentsInstallCtrl.installmentList)
            ],
          ),
        ));
  }

  List<DropdownMenuItem<String>> _dropDownitem(
      List<MercadoPagoInstallment> installment) {
    List<DropdownMenuItem<String>> list = [];
    for (var item in installment) {
      list.add(DropdownMenuItem(
          value: item.installments.toString(),
          child: Text(
            item.installments.toString(),
            style: GoogleFonts.lato(fontSize: 18),
          )));
    }
    return list;
  }

  Widget _dropDownInstallments(List<MercadoPagoInstallment> installments) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: DropdownButton(
          underline: Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.arrow_drop_down_circle,
                  color: kPrimaryColor)),
          elevation: 2,
          isExpanded: true,
          hint: Text('Selecciona la cantidad de cuotas',
              style: GoogleFonts.lato(color: Colors.grey, fontSize: 16)),
          items: _dropDownitem(installments),
          value: _clientPaymentsInstallCtrl.installments.value == ''
              ? null
              : _clientPaymentsInstallCtrl.installments.value,
          onChanged: (value) {
            _clientPaymentsInstallCtrl.installments.value = value.toString();
          }),
    );
  }

  Widget textDescription() {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Text(
        'Cantidad de cuotas a pagar: ',
        style: GoogleFonts.lato(fontSize: 20),
      ),
    );
  }

  Widget buttonConfirm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Total: ${_clientPaymentsInstallCtrl.total.value}\$',
          style: GoogleFonts.lato(fontSize: 22, fontStyle: FontStyle.italic),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 35),
          child: SizedBox(
            height: size.height * 0.080,
            width: size.width * 0.6,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 43, 136, 134),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              child: Text(
                'Confirmar pago',
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
}
