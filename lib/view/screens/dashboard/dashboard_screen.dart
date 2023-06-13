import 'dart:async';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/view/screens/bank/wallet_screen.dart';
import 'package:sixam_mart_store/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:sixam_mart_store/view/screens/home/home_screen.dart';
import 'package:sixam_mart_store/view/screens/menu/menu_screen.dart';
import 'package:sixam_mart_store/view/screens/order/order_history_screen.dart';
import 'package:sixam_mart_store/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({Key? key, required this.pageIndex}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  // Timer _timer;
  // int _orderCount;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const OrderHistoryScreen(),
      const StoreScreen(),
      const WalletScreen(),
      Container(),
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

    /*var androidInitialize = AndroidInitializationSettings('notification_icon');
    var iOSInitialize = IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if(Get.find<OrderController>().runningOrders != null) {
      //   _orderCount = Get.find<OrderController>().runningOrders.length;
      // }
      print("onMessage: ${message.data}");
      String _type = message.notification.bodyLocKey;
      String _body = message.notification.body;
      Get.find<OrderController>().getPaginatedOrders(1, true);
      Get.find<OrderController>().getCurrentOrders();
      if(_type == 'new_order' || _body == 'New order placed') {
        // _orderCount = _orderCount + 1;
        Get.dialog(NewRequestDialog());
      }else {
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
      }
    });*/

    // _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
    //   await Get.find<OrderController>().getCurrentOrders();
    //   int _count = Get.find<OrderController>().runningOrders.length;
    //   if(_orderCount != null && _orderCount < _count) {
    //     Get.dialog(NewRequestDialog());
    //   }else {
    //     _orderCount = Get.find<OrderController>().runningOrders.length;
    //   }
    // });

  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer?.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          return true;
        }
      },
      child: Scaffold(

        floatingActionButton: !GetPlatform.isMobile ? null : FloatingActionButton(
          elevation: 5,
          backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          onPressed: () {
            _setPage(2);
          },
          child: Image.asset(
            Images.restaurant, height: 20, width: 20,
            color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
          ),
        ),
        floatingActionButtonLocation: !GetPlatform.isMobile ? null : FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: !GetPlatform.isMobile ? const SizedBox() : BottomAppBar(
          elevation: 5,
          notchMargin: 5,
          shape: const CircularNotchedRectangle(),

          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              BottomNavItem(iconData: Icons.home, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
              BottomNavItem(iconData: Icons.shopping_bag, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
              const Expanded(child: SizedBox()),
              BottomNavItem(iconData: Icons.monetization_on, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
              BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () {
                Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
              }),
            ]),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
