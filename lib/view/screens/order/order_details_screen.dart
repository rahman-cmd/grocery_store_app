import 'dart:async';
import 'package:photo_view/photo_view.dart';
import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/localization_controller.dart';
import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/body/notification_body.dart';
import 'package:sixam_mart_store/data/model/response/conversation_model.dart';
import 'package:sixam_mart_store/data/model/response/order_details_model.dart';
import 'package:sixam_mart_store/data/model/response/order_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/order/invoice_print_screen.dart';
import 'package:sixam_mart_store/view/screens/order/widget/amount_input_dialogue.dart';
import 'package:sixam_mart_store/view/screens/order/widget/cancellation_dialogue.dart';
import 'package:sixam_mart_store/view/screens/order/widget/order_item_widget.dart';
import 'package:sixam_mart_store/view/screens/order/widget/slider_button.dart';
import 'package:sixam_mart_store/view/screens/order/widget/verify_delivery_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final bool isRunningOrder;
  final bool fromNotification;
  const OrderDetailsScreen(
      {Key? key,
      required this.orderId,
      required this.isRunningOrder,
      this.fromNotification = false})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    with WidgetsBindingObserver {
  late Timer _timer;

  Future<void> loadData() async {
    await Get.find<OrderController>().getOrderDetails(widget.orderId);

    ///order

    Get.find<OrderController>().getOrderItemsDetails(widget.orderId);

    ///order details

    _startApiCalling();
  }

  void _startApiCalling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().getOrderDetails(widget.orderId);
    });
  }

  @override
  void initState() {
    super.initState();

    Get.find<OrderController>().clearPreviousData();
    loadData();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startApiCalling();
    } else if (state == AppLifecycleState.paused) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    bool? cancelPermission =
        Get.find<SplashController>().configModel!.canceledByStore;
    bool selfDelivery = Get.find<AuthController>()
            .profileModel!
            .stores![0]
            .selfDeliverySystem ==
        1;

    return WillPopScope(
      onWillPop: () async {
        if (widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
          return true;
        } else {
          Get.back();
          return true;
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'order_details'.tr,
            onTap: () {
              if (widget.fromNotification) {
                Get.offAllNamed(RouteHelper.getInitialRoute());
              } else {
                Get.back();
              }
            }),
        body: GetBuilder<OrderController>(builder: (orderController) {
          OrderModel? controllerOrderModer = orderController.orderModel;

          bool restConfModel = Get.find<SplashController>()
                  .configModel!
                  .orderConfirmationModel !=
              'deliveryman';
          bool showSlider = controllerOrderModer != null
              ? (controllerOrderModer.orderStatus == 'pending' &&
                      (controllerOrderModer.orderType == 'take_away' ||
                          restConfModel ||
                          selfDelivery)) ||
                  controllerOrderModer.orderStatus == 'confirmed' ||
                  controllerOrderModer.orderStatus == 'processing' ||
                  (controllerOrderModer.orderStatus == 'accepted' &&
                      controllerOrderModer.confirmed != null) ||
                  (controllerOrderModer.orderStatus == 'handover' &&
                      (selfDelivery ||
                          controllerOrderModer.orderType == 'take_away'))
              : false;
          bool showBottomView = controllerOrderModer != null
              ? showSlider ||
                  controllerOrderModer.orderStatus == 'picked_up' ||
                  widget.isRunningOrder
              : false;

          double? deliveryCharge = 0;
          double itemsPrice = 0;
          double? discount = 0;
          double? couponDiscount = 0;
          double? tax = 0;
          double addOns = 0;
          double? dmTips = 0;
          bool? isPrescriptionOrder = false;
          bool? taxIncluded = false;
          OrderModel? order = controllerOrderModer;
          if (order != null && orderController.orderDetailsModel != null) {
            if (order.orderType == 'delivery') {
              deliveryCharge = order.deliveryCharge;
              dmTips = order.dmTips;
              isPrescriptionOrder = order.prescriptionOrder;
            }
            discount = order.storeDiscountAmount;
            tax = order.totalTaxAmount;
            taxIncluded = order.taxStatus;
            couponDiscount = order.couponDiscountAmount;
            if (isPrescriptionOrder!) {
              double orderAmount = order.orderAmount ?? 0;
              itemsPrice = (orderAmount + discount!) - (tax! + deliveryCharge!);
            } else {
              for (OrderDetailsModel orderDetails
                  in orderController.orderDetailsModel!) {
                for (AddOn addOn in orderDetails.addOns!) {
                  addOns = addOns + (addOn.price! * addOn.quantity!);
                }
                itemsPrice =
                    itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              }
            }
          }
          double subTotal = itemsPrice + addOns;
          double total = itemsPrice +
              addOns -
              discount! +
              (taxIncluded! ? 0 : tax!) +
              deliveryCharge! -
              couponDiscount! +
              dmTips!;

          return (orderController.orderDetailsModel != null &&
                  controllerOrderModer != null)
              ? Column(children: [
                  Expanded(
                      child: Scrollbar(
                          child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Center(
                        child: SizedBox(
                            width: 1170,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text('${'order_id'.tr}:',
                                        style: robotoRegular),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(order!.id.toString(),
                                        style: robotoMedium),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    const Expanded(child: SizedBox()),
                                    const Icon(Icons.watch_later, size: 17),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(
                                      DateConverter.dateTimeStringToDateTime(
                                          order.createdAt!),
                                      style: robotoRegular,
                                    ),
                                  ]),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),

                                  order.scheduled == 1
                                      ? Row(children: [
                                          Text('${'scheduled_at'.tr}:',
                                              style: robotoRegular),
                                          const SizedBox(
                                              width: Dimensions
                                                  .paddingSizeExtraSmall),
                                          Text(
                                              DateConverter
                                                  .dateTimeStringToDateTime(
                                                      order.scheduleAt!),
                                              style: robotoMedium),
                                        ])
                                      : const SizedBox(),
                                  SizedBox(
                                      height: order.scheduled == 1
                                          ? Dimensions.paddingSizeSmall
                                          : 0),

                                  Row(children: [
                                    Text(order.orderType!.tr,
                                        style: robotoMedium),
                                    const Expanded(child: SizedBox()),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeSmall,
                                          vertical:
                                              Dimensions.paddingSizeExtraSmall),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                      ),
                                      child: Text(
                                        order.paymentMethod ==
                                                'cash_on_delivery'
                                            ? 'cash_on_delivery'.tr
                                            : order.paymentMethod == 'wallet'
                                                ? 'wallet_payment'
                                                : 'digital_payment'.tr,
                                        style: robotoMedium.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall),
                                      ),
                                    ),
                                  ]),
                                  const Divider(
                                      height: Dimensions.paddingSizeLarge),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.paddingSizeExtraSmall),
                                    child: Row(children: [
                                      Text('${'item'.tr}:',
                                          style: robotoRegular),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(
                                        orderController
                                            .orderDetailsModel!.length
                                            .toString(),
                                        style: robotoMedium.copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Container(
                                          height: 7,
                                          width: 7,
                                          decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle)),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(
                                        order.orderStatus == 'delivered'
                                            ? '${'delivered_at'.tr} ${order.delivered != null ? DateConverter.dateTimeStringToDateTime(order.delivered!) : ''}'
                                            : order.orderStatus!.tr,
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ]),
                                  ),
                                  const Divider(
                                      height: Dimensions.paddingSizeLarge),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),

                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: orderController
                                        .orderDetailsModel!.length,
                                    itemBuilder: (context, index) {
                                      return OrderItemWidget(
                                          order: order,
                                          orderDetails: orderController
                                              .orderDetailsModel![index]);
                                    },
                                  ),

                                  (order.orderNote != null &&
                                          order.orderNote!.isNotEmpty)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text('additional_note'.tr,
                                                  style: robotoRegular),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                              Container(
                                                width: 1170,
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusSmall),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                ),
                                                child: Text(
                                                  order.orderNote!,
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeLarge),
                                            ])
                                      : const SizedBox(),

                                  (Get.find<SplashController>()
                                              .getModuleConfig(order.moduleType)
                                              .orderAttachment! &&
                                          order.orderAttachment != null &&
                                          order.orderAttachment!.isNotEmpty)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text('prescription'.tr,
                                                  style: robotoRegular),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                              GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 1,
                                                    crossAxisCount:
                                                        ResponsiveHelper.isTab(
                                                                context)
                                                            ? 5
                                                            : 3,
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 5,
                                                  ),
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: order
                                                      .orderAttachment!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: InkWell(
                                                        onTap: () => openDialog(
                                                            context,
                                                            '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderAttachment![index]}'),
                                                        child: Center(
                                                            child: ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusSmall),
                                                          child: CustomImage(
                                                            image:
                                                                '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderAttachment![index]}',
                                                            width: 100,
                                                            height: 100,
                                                          ),
                                                        )),
                                                      ),
                                                    );
                                                  }),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeLarge),
                                            ])
                                      : const SizedBox(),

                                  Text('customer_details'.tr,
                                      style: robotoRegular),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeExtraSmall),

                                  order.deliveryAddress != null
                                      ? Row(children: [
                                          SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: ClipOval(
                                                child: CustomImage(
                                              image:
                                                  '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${order.customer != null ? order.customer!.image : ''}',
                                              height: 35,
                                              width: 35,
                                              fit: BoxFit.cover,
                                            )),
                                          ),
                                          const SizedBox(
                                              width:
                                                  Dimensions.paddingSizeSmall),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                Text(
                                                  order.deliveryAddress!
                                                      .contactPersonName!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall),
                                                ),
                                                Text(
                                                  order.deliveryAddress!
                                                          .address ??
                                                      '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                ),
                                                Wrap(children: [
                                                  (order.deliveryAddress!
                                                                  .streetNumber !=
                                                              null &&
                                                          order
                                                              .deliveryAddress!
                                                              .streetNumber!
                                                              .isNotEmpty)
                                                      ? Text(
                                                          '${'street_number'.tr}: ${order.deliveryAddress!.streetNumber!}, ',
                                                          style: robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : const SizedBox(),
                                                  (order.deliveryAddress!
                                                                  .house !=
                                                              null &&
                                                          order
                                                              .deliveryAddress!
                                                              .house!
                                                              .isNotEmpty)
                                                      ? Text(
                                                          '${'house'.tr}: ${order.deliveryAddress!.house!}, ',
                                                          style: robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : const SizedBox(),
                                                  (order.deliveryAddress!
                                                                  .floor !=
                                                              null &&
                                                          order
                                                              .deliveryAddress!
                                                              .floor!
                                                              .isNotEmpty)
                                                      ? Text(
                                                          '${'floor'.tr}: ${order.deliveryAddress!.floor!}',
                                                          style: robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : const SizedBox(),
                                                ]),
                                              ])),
                                          (order.orderType == 'take_away' &&
                                                  (order.orderStatus ==
                                                          'pending' ||
                                                      order.orderStatus ==
                                                          'confirmed' ||
                                                      order.orderStatus ==
                                                          'processing'))
                                              ? TextButton.icon(
                                                  onPressed: () async {
                                                    String url =
                                                        'https://www.google.com/maps/dir/?api=1&destination=${order.deliveryAddress!.latitude}'
                                                        ',${order.deliveryAddress!.longitude}&mode=d';
                                                    if (await canLaunchUrlString(
                                                        url)) {
                                                      await launchUrlString(url,
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    } else {
                                                      showCustomSnackBar(
                                                          'unable_to_launch_google_map'
                                                              .tr);
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.directions),
                                                  label: Text('direction'.tr),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                              width:
                                                  Dimensions.paddingSizeSmall),
                                          (order.orderStatus != 'delivered' &&
                                                  order.orderStatus !=
                                                      'failed' &&
                                                  Get.find<AuthController>()
                                                      .modulePermission!
                                                      .chat! &&
                                                  order.orderStatus !=
                                                      'canceled' &&
                                                  order.orderStatus !=
                                                      'refunded')
                                              ? TextButton.icon(
                                                  onPressed: () async {
                                                    _timer.cancel();
                                                    await Get.toNamed(
                                                        RouteHelper
                                                            .getChatRoute(
                                                      notificationBody:
                                                          NotificationBody(
                                                        orderId: order.id,
                                                        customerId:
                                                            order.customer!.id,
                                                      ),
                                                      user: User(
                                                        id: order.customer!.id,
                                                        fName: order
                                                            .customer!.fName,
                                                        lName: order
                                                            .customer!.lName,
                                                        image: order
                                                            .customer!.image,
                                                      ),
                                                    ));
                                                    _startApiCalling();
                                                  },
                                                  icon: Icon(Icons.message,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 20),
                                                  label: Text(
                                                    'chat'.tr,
                                                    style:
                                                        robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ])
                                      : const SizedBox(),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeLarge),

                                  order.deliveryMan != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text('delivery_man'.tr,
                                                  style: robotoRegular),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                              Row(children: [
                                                ClipOval(
                                                    child: CustomImage(
                                                  image: order.deliveryMan !=
                                                          null
                                                      ? '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${order.deliveryMan!.image}'
                                                      : '',
                                                  height: 35,
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                )),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall),
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                      Text(
                                                        '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                      ),
                                                      Text(
                                                        order.deliveryMan!
                                                            .email!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor),
                                                      ),
                                                    ])),
                                                (controllerOrderModer
                                                                .orderStatus !=
                                                            'delivered' &&
                                                        controllerOrderModer
                                                                .orderStatus !=
                                                            'failed' &&
                                                        controllerOrderModer
                                                                .orderStatus !=
                                                            'canceled' &&
                                                        controllerOrderModer
                                                                .orderStatus !=
                                                            'refunded')
                                                    ? TextButton.icon(
                                                        onPressed: () async {
                                                          if (await canLaunchUrlString(
                                                              'tel:${order.deliveryMan!.phone ?? ''}')) {
                                                            launchUrlString(
                                                                'tel:${order.deliveryMan!.phone ?? ''}',
                                                                mode: LaunchMode
                                                                    .externalApplication);
                                                          } else {
                                                            showCustomSnackBar(
                                                                '${'can_not_launch'.tr} ${order.deliveryMan!.phone ?? ''}');
                                                          }
                                                        },
                                                        icon: Icon(Icons.call,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 20),
                                                        label: Text(
                                                          'call'.tr,
                                                          style: robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                (controllerOrderModer
                                                                .orderStatus !=
                                                            'delivered' &&
                                                        controllerOrderModer
                                                                .orderStatus !=
                                                            'failed' &&
                                                        controllerOrderModer
                                                                .orderStatus !=
                                                            'canceled' &&
                                                        controllerOrderModer
                                                                .orderStatus !=
                                                            'refunded' &&
                                                        Get.find<
                                                                AuthController>()
                                                            .modulePermission!
                                                            .chat!)
                                                    ? TextButton.icon(
                                                        onPressed: () async {
                                                          _timer.cancel();
                                                          await Get.toNamed(
                                                              RouteHelper
                                                                  .getChatRoute(
                                                            notificationBody:
                                                                NotificationBody(
                                                              orderId:
                                                                  controllerOrderModer
                                                                      .id,
                                                              deliveryManId: order
                                                                  .deliveryMan!
                                                                  .id,
                                                            ),
                                                            user: User(
                                                              id: controllerOrderModer
                                                                  .deliveryMan!
                                                                  .id,
                                                              fName: controllerOrderModer
                                                                  .deliveryMan!
                                                                  .fName,
                                                              lName: controllerOrderModer
                                                                  .deliveryMan!
                                                                  .lName,
                                                              image: controllerOrderModer
                                                                  .deliveryMan!
                                                                  .image,
                                                            ),
                                                          ));
                                                          _startApiCalling();
                                                        },
                                                        icon: Icon(
                                                            Icons
                                                                .chat_bubble_outline,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 20),
                                                        label: Text(
                                                          'chat'.tr,
                                                          style: robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ]),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                            ])
                                      : const SizedBox(),

                                  // Total
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('item_price'.tr,
                                            style: robotoRegular),
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              order.prescriptionOrder!
                                                  ? IconButton(
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 36),
                                                      onPressed: () => Get.dialog(
                                                          AmountInputDialogue(
                                                              orderId: widget
                                                                  .orderId,
                                                              isItemPrice: true,
                                                              amount:
                                                                  itemsPrice),
                                                          barrierDismissible:
                                                              true),
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          size: 16),
                                                    )
                                                  : const SizedBox(),
                                              Text(
                                                  PriceConverter.convertPrice(
                                                      itemsPrice),
                                                  style: robotoRegular),
                                            ]),
                                      ]),
                                  const SizedBox(height: 10),

                                  Get.find<SplashController>()
                                          .getModuleConfig(order.moduleType)
                                          .addOn!
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('addons'.tr,
                                                style: robotoRegular),
                                            Text(
                                                '(+) ${PriceConverter.convertPrice(addOns)}',
                                                style: robotoRegular),
                                          ],
                                        )
                                      : const SizedBox(),

                                  Get.find<SplashController>()
                                          .getModuleConfig(order.moduleType)
                                          .addOn!
                                      ? Divider(
                                          thickness: 1,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.5),
                                        )
                                      : const SizedBox(),

                                  Get.find<SplashController>()
                                          .getModuleConfig(order.moduleType)
                                          .addOn!
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${'subtotal'.tr} ${taxIncluded ? '(${'tax_included'.tr})' : ''}',
                                                style: robotoMedium),
                                            Text(
                                                PriceConverter.convertPrice(
                                                    subTotal),
                                                style: robotoMedium),
                                          ],
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                      height: Get.find<SplashController>()
                                              .getModuleConfig(order.moduleType)
                                              .addOn!
                                          ? 10
                                          : 0),

                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('discount'.tr,
                                            style: robotoRegular),
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              order.prescriptionOrder!
                                                  ? IconButton(
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 36),
                                                      onPressed: () => Get.dialog(
                                                          AmountInputDialogue(
                                                              orderId: widget
                                                                  .orderId,
                                                              isItemPrice:
                                                                  false,
                                                              amount: discount),
                                                          barrierDismissible:
                                                              true),
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          size: 16),
                                                    )
                                                  : const SizedBox(),
                                              Text(
                                                  '(-) ${PriceConverter.convertPrice(discount)}',
                                                  style: robotoRegular),
                                            ]),
                                      ]),
                                  const SizedBox(height: 10),

                                  couponDiscount > 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                              Text('coupon_discount'.tr,
                                                  style: robotoRegular),
                                              Text(
                                                '(-) ${PriceConverter.convertPrice(couponDiscount)}',
                                                style: robotoRegular,
                                              ),
                                            ])
                                      : const SizedBox(),
                                  SizedBox(height: couponDiscount > 0 ? 10 : 0),

                                  !taxIncluded
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                              Text('vat_tax'.tr,
                                                  style: robotoRegular),
                                              Text(
                                                  '(+) ${PriceConverter.convertPrice(tax)}',
                                                  style: robotoRegular),
                                            ])
                                      : const SizedBox(),
                                  SizedBox(height: taxIncluded ? 0 : 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('delivery_man_tips'.tr,
                                          style: robotoRegular),
                                      Text(
                                          '(+) ${PriceConverter.convertPrice(dmTips)}',
                                          style: robotoRegular),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('delivery_fee'.tr,
                                            style: robotoRegular),
                                        Text(
                                            '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                                            style: robotoRegular),
                                      ]),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeSmall),
                                    child: Divider(
                                        thickness: 1,
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.5)),
                                  ),

                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('total_amount'.tr,
                                            style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )),
                                        Text(
                                          PriceConverter.convertPrice(total),
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ]),
                                ]))),
                  ))),
                  showBottomView
                      ? (controllerOrderModer.orderStatus == 'picked_up')
                          ? Container(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeDefault),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                border: Border.all(width: 1),
                              ),
                              alignment: Alignment.center,
                              child: Text('item_is_on_the_way'.tr,
                                  style: robotoMedium),
                            )
                          : showSlider
                              ? (controllerOrderModer.orderStatus ==
                                          'pending' &&
                                      (controllerOrderModer.orderType ==
                                              'take_away' ||
                                          restConfModel ||
                                          selfDelivery) &&
                                      cancelPermission!)
                                  ? Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      child: Row(children: [
                                        Expanded(
                                            child: TextButton(
                                          /*onPressed: () => Get.dialog(ConfirmationDialog(
                    icon: Images.warning, title: 'are_you_sure_to_cancel'.tr, description: 'you_want_to_cancel_this_order'.tr,
                    onYesPressed: () {
                      orderController.updateOrderStatus(widget.orderId, AppConstants.CANCELED, back: true);
                    },
                  ), barrierDismissible: false),*/
                                          onPressed: () {
                                            orderController
                                                .setOrderCancelReason('');
                                            Get.dialog(CancellationDialogue(
                                                orderId: order.id));
                                          },
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(1170, 40),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall),
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color!),
                                            ),
                                          ),
                                          child: Text('cancel'.tr,
                                              textAlign: TextAlign.center,
                                              style: robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                              )),
                                        )),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        Expanded(
                                            child: CustomButton(
                                          buttonText: 'confirm'.tr,
                                          height: 40,
                                          onPressed: () {
                                            Get.dialog(
                                                ConfirmationDialog(
                                                  icon: Images.warning,
                                                  title:
                                                      'are_you_sure_to_confirm'
                                                          .tr,
                                                  description:
                                                      'you_want_to_confirm_this_order'
                                                          .tr,
                                                  onYesPressed: () {
                                                    orderController
                                                        .updateOrderStatus(
                                                            widget.orderId,
                                                            AppConstants
                                                                .confirmed,
                                                            back: true);
                                                  },
                                                ),
                                                barrierDismissible: false);
                                          },
                                        )),
                                      ]),
                                    )
                                  : SliderButton(
                                      action: () {
                                        if (controllerOrderModer.orderStatus ==
                                                'pending' &&
                                            (controllerOrderModer.orderType ==
                                                    'take_away' ||
                                                restConfModel ||
                                                selfDelivery)) {
                                          Get.dialog(
                                              ConfirmationDialog(
                                                icon: Images.warning,
                                                title: 'are_you_sure_to_confirm'
                                                    .tr,
                                                description:
                                                    'you_want_to_confirm_this_order'
                                                        .tr,
                                                onYesPressed: () {
                                                  orderController
                                                      .updateOrderStatus(
                                                          widget.orderId,
                                                          AppConstants
                                                              .confirmed,
                                                          back: true);
                                                },
                                                onNoPressed: () {
                                                  if (cancelPermission!) {
                                                    orderController
                                                        .updateOrderStatus(
                                                            widget.orderId,
                                                            AppConstants
                                                                .canceled,
                                                            back: true);
                                                  } else {
                                                    Get.back();
                                                  }
                                                },
                                              ),
                                              barrierDismissible: false);
                                        } else if (controllerOrderModer
                                                .orderStatus ==
                                            'processing') {
                                          Get.find<OrderController>()
                                              .updateOrderStatus(widget.orderId,
                                                  AppConstants.handover);
                                        } else if (controllerOrderModer
                                                    .orderStatus ==
                                                'confirmed' ||
                                            (controllerOrderModer.orderStatus ==
                                                    'accepted' &&
                                                controllerOrderModer
                                                        .confirmed !=
                                                    null)) {
                                          debugPrint(
                                              'accepted & confirm call----------------');
                                          Get.find<OrderController>()
                                              .updateOrderStatus(
                                                  controllerOrderModer.id,
                                                  AppConstants.processing);
                                        } else if ((controllerOrderModer
                                                    .orderStatus ==
                                                'handover' &&
                                            (controllerOrderModer.orderType ==
                                                    'take_away' ||
                                                selfDelivery))) {
                                          if (Get.find<SplashController>()
                                                  .configModel!
                                                  .orderDeliveryVerification! ||
                                              controllerOrderModer
                                                      .paymentMethod ==
                                                  'cash_on_delivery') {
                                            Get.bottomSheet(
                                                VerifyDeliverySheet(
                                                  orderID:
                                                      controllerOrderModer.id,
                                                  verify: Get.find<
                                                          SplashController>()
                                                      .configModel!
                                                      .orderDeliveryVerification,
                                                  orderAmount:
                                                      controllerOrderModer
                                                          .orderAmount,
                                                  cod: controllerOrderModer
                                                          .paymentMethod ==
                                                      'cash_on_delivery',
                                                ),
                                                isScrollControlled: true);
                                          } else {
                                            Get.find<OrderController>()
                                                .updateOrderStatus(
                                                    controllerOrderModer.id,
                                                    AppConstants.delivered);
                                          }
                                        }
                                      },
                                      label: Text(
                                        (controllerOrderModer.orderStatus ==
                                                    'pending' &&
                                                (controllerOrderModer
                                                            .orderType ==
                                                        'take_away' ||
                                                    restConfModel ||
                                                    selfDelivery))
                                            ? 'swipe_to_confirm_order'.tr
                                            : (controllerOrderModer
                                                            .orderStatus ==
                                                        'confirmed' ||
                                                    (controllerOrderModer
                                                                .orderStatus ==
                                                            'accepted' &&
                                                        controllerOrderModer
                                                                .confirmed !=
                                                            null))
                                                ? Get.find<SplashController>()
                                                        .configModel!
                                                        .moduleConfig!
                                                        .module!
                                                        .showRestaurantText!
                                                    ? 'swipe_to_cooking'.tr
                                                    : 'swipe_to_process'.tr
                                                : (controllerOrderModer
                                                            .orderStatus ==
                                                        'processing')
                                                    ? 'swipe_if_ready_for_handover'
                                                        .tr
                                                    : (controllerOrderModer
                                                                    .orderStatus ==
                                                                'handover' &&
                                                            (controllerOrderModer
                                                                        .orderType ==
                                                                    'take_away' ||
                                                                selfDelivery))
                                                        ? 'swipe_to_deliver_order'
                                                            .tr
                                                        : '',
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      dismissThresholds: 0.5,
                                      dismissible: false,
                                      shimmer: true,
                                      width: 1170,
                                      height: 60,
                                      buttonSize: 50,
                                      radius: 10,
                                      icon: Center(
                                          child: Icon(
                                        Get.find<LocalizationController>().isLtr
                                            ? Icons.double_arrow_sharp
                                            : Icons.keyboard_arrow_left,
                                        color: Colors.white,
                                        size: 20.0,
                                      )),
                                      isLtr: Get.find<LocalizationController>()
                                          .isLtr,
                                      boxShadow: const BoxShadow(blurRadius: 0),
                                      buttonColor:
                                          Theme.of(context).primaryColor,
                                      backgroundColor: const Color(0xffF4F7FC),
                                      baseColor: Theme.of(context).primaryColor,
                                    )
                              : const SizedBox()
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CustomButton(
                      onPressed: () {
                        Get.dialog(Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSmall)),
                          child: InVoicePrintScreen(
                              order: order,
                              orderDetails: orderController.orderDetailsModel,
                              isPrescriptionOrder: isPrescriptionOrder),
                        ));
                      },
                      icon: Icons.local_print_shop,
                      buttonText: 'print_invoice'.tr,
                    ),
                  ),
                ])
              : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  void openDialog(BuildContext context, String imageUrl) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                child: PhotoView(
                  tightMode: true,
                  imageProvider: NetworkImage(imageUrl),
                  heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    splashRadius: 5,
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.cancel, color: Colors.red),
                  )),
            ]),
          );
        },
      );
}
