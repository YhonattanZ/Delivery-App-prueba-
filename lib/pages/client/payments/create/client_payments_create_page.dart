import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/payments/create/client_payment_create_controller.dart';
import 'package:app_delivery/src/models/mercado_pago_document_type.dart';
import 'package:app_delivery/widgets/sign_up_forms.dart';
import 'package:flutter/material.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientPaymentsCreatePage extends StatelessWidget {
  ClientPaymentsCreatePage({super.key});

  final ClientPaymentsCreateController _paymentsCreateCtrlr =
      Get.put(ClientPaymentsCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: buttonConfirm(context),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          appBar: AppBar(
            backgroundColor: kSecondaryColor,
            title: Text('Agrega tu metodo de pago', style: GoogleFonts.lato()),
          ),
          body: ListView(
            children: [
              card(context),
              //Formularios
              cardForm(),
              _dropDownDocument(_paymentsCreateCtrlr.documents),
              SignUpForms(
                  controller: _paymentsCreateCtrlr.documentCtrl,
                  autofocus: false,
                  obstext: false,
                  formTitle: 'Tipo de documento',
                  formIcon: Icon(Icons.document_scanner_outlined),
                  keyboardType: TextInputType.text),
            ],
          ),
        ));
  }

  CreditCardForm cardForm() {
    return CreditCardForm(
      formKey: _paymentsCreateCtrlr.keyform, // Required
      cardNumber: _paymentsCreateCtrlr.cardNumber.value,
      expiryDate: _paymentsCreateCtrlr.expireDate.value,
      cardHolderName: _paymentsCreateCtrlr.cardHolderName.value,
      cvvCode: _paymentsCreateCtrlr.cvvCode.value,
      onCreditCardModelChange:
          _paymentsCreateCtrlr.onCreditCardModelChange, // Required
      themeColor: kSecondaryColor,
      obscureCvv: true,
      obscureNumber: true,

      cardNumberValidator: (String? cardNumber) {},
      expiryDateValidator: (String? expiryDate) {},
      cvvValidator: (String? cvv) {},
      cardHolderValidator: (String? cardHolderName) {},
      onFormComplete: () {
        // callback to execute at the end of filling card data
      },
      cardNumberDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.credit_card),
        iconColor: kSecondaryColor,
        labelText: 'Numero de la tarjeta',
        hintText: 'XXXX XXXX XXXX XXXX',
      ),
      expiryDateDecoration: const InputDecoration(
        suffixIcon: Icon(Icons.date_range),
        iconColor: kSecondaryColor,
        border: OutlineInputBorder(),
        labelText: 'Vencimiento',
        hintText: 'MM/YY',
      ),
      cvvCodeDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.lock),
        iconColor: kSecondaryColor,
        labelText: 'CVV',
        hintText: 'XXX',
      ),
      cardHolderDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.person),
        iconColor: kSecondaryColor,
        labelText: 'Titular de la tarjeta',
      ),
    );
  }

  CreditCardWidget card(BuildContext context) {
    return CreditCardWidget(
      onCreditCardWidgetChange: (creditCard) {},
      cardNumber: _paymentsCreateCtrlr.cardNumber.value,
      expiryDate: _paymentsCreateCtrlr.expireDate.value,
      cardHolderName: _paymentsCreateCtrlr.cardHolderName.value,
      cvvCode: _paymentsCreateCtrlr.cvvCode.value,
      showBackView: _paymentsCreateCtrlr.isCvvFocused.value,
      cardBgColor: kSecondaryColor,
      glassmorphismConfig: Glassmorphism(
          blurX: 5,
          blurY: 5,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[kSecondaryColor, kMatchColor],
          )),
      labelCardHolder: 'NOMBRE Y APELLIDO',
      obscureCardNumber: true,
      obscureCardCvv: true,
      height: MediaQuery.of(context).size.height * 0.23,
      textStyle: GoogleFonts.lato(color: Colors.white),
      width: MediaQuery.of(context).size.width,
      animationDuration: const Duration(milliseconds: 1000),
    );
  }

  Widget buttonConfirm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SizedBox(
        height: size.height * 0.07,
        width: size.width * 0.6,
        child: ElevatedButton(
          onPressed: () {
            _paymentsCreateCtrlr.createCardToken();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 43, 136, 134),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          child: Text(
            'Continuar',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownitem(
      List<MercadoPagoDocumentType> categories) {
    List<DropdownMenuItem<String>> list = [];
    for (var item in categories) {
      list.add(DropdownMenuItem(
          value: item.id,
          child: Text(
            item.name.toString(),
            style: GoogleFonts.lato(fontSize: 18),
          )));
    }
    return list;
  }

  Widget _dropDownDocument(List<MercadoPagoDocumentType> documents) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 70),
      child: DropdownButton(
          underline: Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.arrow_drop_down_circle,
                  color: kPrimaryColor)),
          elevation: 2,
          isExpanded: true,
          hint: Text('Tipo de documento',
              style: GoogleFonts.lato(color: Colors.grey, fontSize: 16)),
          items: _dropDownitem(documents),
          value: _paymentsCreateCtrlr.idDocument.value == ''
              ? null
              : _paymentsCreateCtrlr.idDocument.value,
          onChanged: (value) {
            _paymentsCreateCtrlr.idDocument.value = value.toString();
          }),
    );
  }
}
