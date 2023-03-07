import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/products/list/client_product_list_controller.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:app_delivery/widgets/widgets.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

//Pantalla por defecto para los usuarios, rol cliente

class ClientProductsListPage extends StatelessWidget {
  ClientProductsListPage({super.key});

  ClientProductListController productListCtrl =
      Get.put(ClientProductListController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Obx(() => DefaultTabController(
          length: productListCtrl.categories.length,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(height / 4.4),
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _searchBar(context),
                              _shoppingBag(),
                            ]),
                        SizedBox(height: 20),
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          isScrollable: true,
                          indicatorWeight: 1,
                          indicatorColor: Colors.white,
                          labelColor: kSecondaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.white),
                          tabs: [
                            ...List<Widget>.generate(
                                productListCtrl.categories.length, (index) {
                              return Tab(
                                child: Text(
                                    productListCtrl.categories[index].name ??
                                        ''),
                              );
                            }),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                  children: productListCtrl.categories.map((Category category) {
                return FutureBuilder(
                  future: productListCtrl.getProducts(
                      category.id ?? '1', productListCtrl.productName.value),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          padding: const EdgeInsets.only(top: 20),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, i) {
                            return _CardProduct(snapshot.data![i], context);
                          });
                    } else {
                      return SingleChildScrollView(
                        child: NoDataWidget(
                          text: 'No hay productos',
                        ),
                      );
                    }
                  },
                );
              }).toList())),
        ));
  }

  Widget _shoppingBag() {
    return SafeArea(
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black45, blurRadius: 10),
          ],
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
        ),
        child: productListCtrl.items.value > 0
            ? Stack(
                children: [
                  IconButton(
                      onPressed: () {
                        productListCtrl.goToClientOrderPage();
                      },
                      icon: const Icon(
                        color: kSecondaryColor,
                        Icons.shopping_bag_outlined,
                        size: 32,
                      )),
                  Positioned(
                      left: 30,
                      top: 32,
                      child: Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: kSecondaryColor,
                                    spreadRadius: 2,
                                    blurRadius: 2)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: Text(
                            '${productListCtrl.items.value}',
                            style: GoogleFonts.lato(
                                color: kSecondaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )))
                ],
              )
            : IconButton(
                onPressed: () {
                  productListCtrl.goToClientOrderPage();
                },
                icon: const Icon(
                  color: kSecondaryColor,
                  Icons.shopping_bag_outlined,
                  size: 28,
                )),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: SingleChildScrollView(
          child: TextField(
            autofocus: false,
            onChanged: productListCtrl.onChangeText,
            decoration: InputDecoration(
              hintText: 'Busca un producto',
              hintStyle: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.black38,
                  fontWeight: FontWeight.w400),
              suffixIcon: const Icon(
                Icons.search,
                color: kSecondaryColor,
                size: 30,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: kSecondaryColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: kSecondaryColor)),
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _CardProduct(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        productListCtrl.openModalBottomSheet(product, context);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListTile(
              title: Text(product.name ?? '',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    product.description ?? '',
                    maxLines: 2,
                    style: GoogleFonts.lato(fontSize: 15),
                  ),
                  const SizedBox(height: 5),
                  Text('Precio:${product.price}',
                      style: GoogleFonts.lato(fontSize: 13)),
                ],
              ),
              trailing: SizedBox(
                height: 100,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage(
                    image: product.image1 != null
                        ? NetworkImage(product.image1!)
                        : const AssetImage('assets/images/no-image.jpg')
                            as ImageProvider,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 50),
                    placeholder: const AssetImage('assets/images/no-image.jpg'),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            indent: 30,
            endIndent: 30,
            height: 1,
            color: Colors.grey[400],
          )
        ],
      ),
    );
  }
}
