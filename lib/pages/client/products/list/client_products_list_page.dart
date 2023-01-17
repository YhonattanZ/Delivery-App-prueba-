import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/products/list/client_product_list_controller.dart';
import 'package:app_delivery/src/models/models.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

//Pantalla por defecto para los usuarios, rol cliente

class ClientProductsListPage extends StatelessWidget {
  ClientProductsListPage({super.key});

  ClientProductListController productListCtrl =
      Get.put(ClientProductListController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: productListCtrl.categories.length,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: AppBar(
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: kPrimaryColor,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  ...List<Widget>.generate(productListCtrl.categories.length,
                      (index) {
                    return Tab(
                        child:
                            Text(productListCtrl.categories[index].name ?? ''));
                  }),
                ],
              ),
            ),
          ),
          body: TabBarView(
              children: productListCtrl.categories.map((Category category) {
            return Container();
          }).toList())),
    );
  }
}
