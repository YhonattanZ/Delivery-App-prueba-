import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/restaurant/orders/list/restaurant_order_list_controller.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:app_delivery/widgets/nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/relative_time_util.dart';

class RestaurantOrderListPage extends StatefulWidget {
  const RestaurantOrderListPage({super.key});

  @override
  State<RestaurantOrderListPage> createState() =>
      _RestaurantOrderListPageState();
}

RestaurantOrderListController restaurantlistCtrl =
    Get.put(RestaurantOrderListController());

class _RestaurantOrderListPageState extends State<RestaurantOrderListPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Obx(() => DefaultTabController(
          length: restaurantlistCtrl.status.length,
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(height / 9),
                child: Container(
                  decoration: const BoxDecoration(
                    color: kSecondaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: []),
                      SizedBox(height: 25),
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
                              restaurantlistCtrl.status.length, (index) {
                            return Tab(
                              child: Text(restaurantlistCtrl.status[index]),
                            );
                          }),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
              body: TabBarView(
                  children: restaurantlistCtrl.status.map((String status) {
                return FutureBuilder(
                  future: restaurantlistCtrl.getOrders(status),
                  builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          padding: const EdgeInsets.only(top: 20),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, i) {
                            return _cardOrder(snapshot.data![i]);
                          });
                    } else {
                      return NoDataWidget(
                        text: 'No hay ordenes',
                      );
                    }
                  },
                );
              }).toList())),
        ));
  }

  Widget _cardOrder(Order order) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        restaurantlistCtrl.goToOrderDetail(order);
      },
      child: Container(
        height: size.height * 0.22,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 20),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Container(
                height: 40,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Orden #${order.id}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Pedido realizado: '
                            '${RelativeTimeUtil.getRelativeTime(order.timestamp!.toInt())}',
                            style: GoogleFonts.lato(
                                fontSize: 19,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600)),
                        Text(
                            'Cliente: ${order.client?.name} '
                            '${order.client?.lastname}',
                            style: GoogleFonts.lato(
                                fontSize: 19,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600)),
                        Text('Direcci??n de entrega:  ${order.address?.address}',
                            style: GoogleFonts.lato(
                                fontSize: 19,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600)),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
