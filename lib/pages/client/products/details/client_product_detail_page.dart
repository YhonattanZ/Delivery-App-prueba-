import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/products/details/client_product_detail_controller.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

class ClientProductDetailPage extends StatelessWidget {
  Product? product;

  late ClientProductDetailController clientProductDetailCtrl;
  var counter = 0.obs;
  var price = 0.0.obs;

  ClientProductDetailPage({this.product}) {
    clientProductDetailCtrl = Get.put(ClientProductDetailController());
  }

  @override
  Widget build(BuildContext context) {
    clientProductDetailCtrl.checkAddedProducts(product!, price, counter);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Obx(() => Scaffold(
          bottomSheet: addToCarButton(),
          body: Stack(children: [
            Container(
              width: double.infinity,
              height: height / 2.2,
              decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.white, spreadRadius: 6, blurRadius: 20),
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: _imageSlideShow(context),
            ),
            SafeArea(
              child: optionsProductButtons(),
            ),
            FavButton(height, width),
            Positioned(
              top: height / 2.08,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.name ?? '',
                      style: GoogleFonts.lato(
                          fontStyle: FontStyle.italic,
                          color: kSecondaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.008),
                    Text('Clase de producto',
                        style: GoogleFonts.lato(
                            fontSize: 18, color: Colors.black54)),
                    SizedBox(height: height * 0.030),
                    AddQuantityButtons(width),
                    SizedBox(
                      height: height * 0.030,
                    ),
                    Text(
                      'Descripción:',
                      style: GoogleFonts.lato(
                          color: kSecondaryColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w800,
                          fontSize: 24),
                    ),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    SizedBox(
                      width: 350,
                      child: Text(
                        product?.description ?? '',
                        style: GoogleFonts.lato(
                            fontSize: 16, color: Colors.black45, height: 1.5),
                      ),
                    ),
                    SizedBox(height: height * 0.080),
                    Row(
                      children: [
                        Text(
                          'Total: ',
                          style: GoogleFonts.lato(
                              fontSize: 25, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(width: width * 0.48),
                        Text('${price.value}\$',
                            style: GoogleFonts.lato(
                                color: kSecondaryColor, fontSize: 25))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }

  Row AddQuantityButtons(double width) {
    return Row(
      children: [
        Text(
          'Precio: ',
          style: GoogleFonts.lato(
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
        Text(
          ' ${product?.price ?? ''}\$',
          style: GoogleFonts.lato(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: width * 0.22),
        SizedBox(
          height: 40,
          width: 40,
          child: ElevatedButton(
            onPressed: () {
              clientProductDetailCtrl.removeItem(product!, price, counter);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kSecondaryColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
            ),
            child: const Text('-'),
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: kSecondaryColor),
            child: Text('${counter.value}'),
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: ElevatedButton(
            onPressed: () {
              clientProductDetailCtrl.AddItem(product!, price, counter);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kSecondaryColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
            child: const Text('+'),
          ),
        )
      ],
    );
  }

  Widget _imageSlideShow(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        ImageSlideshow(
            indicatorRadius: 5,
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.1,
            initialPage: 0,
            indicatorColor: Colors.white,
            indicatorBackgroundColor: Colors.grey,
            children: [
              FadeInImage(
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 50),
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: product!.image1 != null
                      ? NetworkImage(product!.image1 ?? '')
                      : const AssetImage('assets/images/no-image.jpg')
                          as ImageProvider),
              FadeInImage(
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 50),
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: product!.image2 != null
                      ? NetworkImage(product!.image2 ?? '')
                      : const AssetImage('assets/images/no-image.jpg')
                          as ImageProvider),
              FadeInImage(
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 50),
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: product!.image3 != null
                      ? NetworkImage(product!.image3 ?? '')
                      : const AssetImage('assets/images/no-image.jpg')
                          as ImageProvider)
            ])
      ],
    ));
  }

  Container addToCarButton() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: kSecondaryColor),
        child: TextButton(
            onPressed: () {
              clientProductDetailCtrl.addToBag(product!, price, counter);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Agregar al carrito',
                    style: GoogleFonts.lato(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            )));
  }

  Stack FavButton(double height, double width) {
    return Stack(children: [
      Positioned(
        top: height / 2.4,
        left: width / 1.27,
        child: Container(
          margin: const EdgeInsets.only(left: 5),
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: kSecondaryColor, blurRadius: 5, spreadRadius: 3)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: LikeButton(
            circleColor:
                const CircleColor(start: Colors.grey, end: kPrimaryColor),
            bubblesColor: const BubblesColor(
                dotPrimaryColor: kPrimaryColor,
                dotSecondaryColor: kPrimaryColor),
            crossAxisAlignment: CrossAxisAlignment.center,
            size: 25,
            likeBuilder: (isLiked) {
              if (!isLiked) {
                return const Icon(
                  Icons.favorite_border,
                  color: kSecondaryColor,
                );
              }
              return Icon(
                Icons.favorite,
                color: isLiked ? kPrimaryColor : Colors.grey,
              );
            },
          ),
        ),
      ),
    ]);
  }

  Row optionsProductButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 16,
              )),
        ),
        Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: const BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 28,
              )),
        ),
      ],
    );
  }
}
