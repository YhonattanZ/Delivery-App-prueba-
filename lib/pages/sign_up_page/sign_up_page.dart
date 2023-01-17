// ignore_for_file: non_constant_identifier_names

import 'package:app_delivery/pages/sign_up_page/sign_up_controller.dart';

import 'package:app_delivery/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final RegisterController registerCtrl = Get.put(RegisterController());

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(children: [
          _backgroundColor(context),
          _CreateNewAccountBox(context),
          Column(
            children: [
              _LogoCover(context),
              _AppName(),
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
    SafeArea(
      child: IconButton(
        padding: EdgeInsets.only(left: size.width * 0.010),
        iconSize: 30,
        icon: const Icon(Icons.arrow_back_rounded),
        color: Colors.white,
        onPressed: () {
          Get.back();
        },
      ),
    ),
    Container(
      margin: EdgeInsets.only(top: size.height * 0.23),
      width: double.infinity,
      height: size.height * 0.11,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35))),
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        child: Text(
          'Crea una nueva cuenta',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
    ),
    Container(
      margin: EdgeInsets.only(top: size.height * 0.30),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35))),
      width: double.infinity,
      height: size.height * 0.7,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(
                  size: size,
                  icon: FontAwesomeIcons.facebookF,
                  color: const Color(0xff3b5998)),
              SocialButton(
                  size: size,
                  icon: FontAwesomeIcons.twitter,
                  color: const Color(0xff00acee)),
              SocialButton(
                  size: size,
                  icon: FontAwesomeIcons.googlePlusG,
                  color: const Color(0xffEA4335))
            ],
          ),
          SizedBox(height: size.height * 0.012),
          Text(
            'O usa tu correo electronico',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: size.height * 0.02),
          SignUpForms(
              controller: registerCtrl.EmailCtrl,
              obstext: false,
              formTitle: 'Email',
              formIcon: const Icon(Icons.email_rounded,
                  color: Color.fromARGB(255, 43, 136, 134)),
              keyboardType: TextInputType.emailAddress),
          SizedBox(
            height: size.height * 0.02,
          ),
          SignUpForms(
              lines: 1,
              controller: registerCtrl.NameCtrl,
              obstext: false,
              formTitle: 'Nombre',
              formIcon: const Icon(Icons.account_circle_rounded,
                  color: Color.fromARGB(255, 43, 136, 134)),
              keyboardType: TextInputType.name),
          SizedBox(
            height: size.height * 0.02,
          ),
          SignUpForms(
              lines: 1,
              controller: registerCtrl.LastnameCtrl,
              obstext: false,
              formTitle: 'Apellido',
              formIcon: const Icon(Icons.account_circle_rounded,
                  color: Color.fromARGB(255, 43, 136, 134)),
              keyboardType: TextInputType.name),
          SizedBox(
            height: size.height * 0.02,
          ),
          SignUpForms(
              lines: 1,
              controller: registerCtrl.passwordCtrl,
              obstext: true,
              formTitle: 'Contraseña',
              formIcon: const Icon(Icons.lock_outline_rounded,
                  color: Color.fromARGB(255, 43, 136, 134)),
              keyboardType: TextInputType.text),
          SizedBox(
            height: size.height * 0.02,
          ),
          SignUpForms(
              lines: 1,
              controller: registerCtrl.PhoneCtrl,
              obstext: false,
              formTitle: 'Numero de telefono',
              formIcon: const Icon(Icons.phone,
                  color: Color.fromARGB(255, 43, 136, 134)),
              keyboardType: TextInputType.number),
          SizedBox(
            height: size.height * 0.02,
          ),
          SizedBox(
            height: size.height * 0.07,
            width: size.width * 0.6,
            child: ElevatedButton(
              onPressed: () {
                registerCtrl.registerUser(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 43, 136, 134),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Regístrate',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.010),
          SignUp(context),
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

Widget SignUp(BuildContext context) {
  final RegisterController registerCtrl = Get.put(RegisterController());
  final size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        '¿Ya posees una cuenta?',
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      SizedBox(width: size.width * 0.010),
      TextButton(
        onPressed: () => registerCtrl.goToLoginPage(),
        child: const Text(
          'Inicia sesión',
          style: TextStyle(
              color: Color.fromARGB(255, 43, 136, 134),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

Widget _AppName() {
  return Text(
    'Delivery App with MySQL',
    style: GoogleFonts.lato(
        color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
  );
}

Widget _LogoCover(BuildContext context) {
  return SafeArea(
    child: Center(
      child: GestureDetector(
          onTap: () {
            registerCtrl.showAlertDialog(context);
          },
          child: GetBuilder<RegisterController>(
            builder: (value) => CircleAvatar(
                backgroundColor: Colors.white70,
                radius: 70,
                backgroundImage: registerCtrl.imageFile != null
                    ? FileImage(registerCtrl.imageFile!)
                    : const AssetImage('assets/images/delivery 2.png')
                        as ImageProvider),
          )),
    ),
  );
}
