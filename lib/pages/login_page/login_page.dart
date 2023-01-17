// ignore_for_file: non_constant_identifier_names

import 'package:app_delivery/pages/login_page/login_controller.dart';
import 'package:app_delivery/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(children: [
          _backgroundColor(context),
          _LoginAccountBox(context),
          Column(
            children: [
              _LogoCover(),
              _AppName(),
            ],
          ),
        ]),
      ),
    );
  }
}

Widget _LoginAccountBox(BuildContext context) {
  final LoginController loginCtrl = Get.put(LoginController());
  final size = MediaQuery.of(context).size;
  return Stack(children: [
    Container(
      margin: EdgeInsets.only(top: size.height * 0.25),
      width: double.infinity,
      height: size.height * 0.11,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35))),
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        child: Text(
          'Inicia Sesión',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
    ),
    Container(
      margin: EdgeInsets.only(top: size.height * 0.32),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35))),
      width: double.infinity,
      height: size.height * 0.7,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),
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
          SizedBox(height: size.height * 0.12),
          SignUpForms(
              lines: 1,
              controller: loginCtrl.emailCtrl,
              obstext: false,
              formTitle: 'Email',
              formIcon: const Icon(Icons.email_rounded,
                  color: Color.fromARGB(255, 43, 136, 134)),
              keyboardType: TextInputType.emailAddress),
          SizedBox(
            height: size.height * 0.02,
          ),
          SignUpForms(
              obstext: true,
              lines: 1,
              controller: loginCtrl.passwordCtrl,
              formTitle: 'Contraseña',
              formIcon: const Icon(Icons.lock_outline_rounded,
                  color: Color.fromARGB(255, 43, 136, 134)),
              keyboardType: TextInputType.text),
          SizedBox(height: size.height * 0.12),
          SizedBox(
            height: size.height * 0.07,
            width: size.width * 0.6,
            child: ElevatedButton(
              onPressed: () {
                loginCtrl.login();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 43, 136, 134),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.030),
          Register(context),
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

Widget Register(BuildContext context) {
  final LoginController loginCtrl = Get.put(LoginController());
  final size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        '¿No posees una cuenta?',
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      SizedBox(width: size.width * 0.010),
      GestureDetector(
        onTap: () => loginCtrl.goToRegisterPage(),
        child: const Text(
          'Registrate ahora',
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

Widget _LogoCover() {
  return Center(
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.zero,
      child: Image.asset(
        'assets/images/delivery 2.png',
        width: 200,
        height: 150,
      ),
    ),
  );
}
