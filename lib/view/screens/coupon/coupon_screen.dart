import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/controller/coupon_controller.dart';
import 'package:sixam_mart_store/controller/localization_controller.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/screens/coupon/add_coupon_screen.dart';

import 'widgets/coupon_card_dialogue.dart';
class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CouponController>().getCouponList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'coupon'.tr),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddCouponScreen()),
        child: Icon(Icons.add_circle_outline, size: 30, color: Theme.of(context).cardColor),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          await Get.find<CouponController>().getCouponList();
        },
        child: GetBuilder<CouponController>(
          builder: (couponController) {
            return couponController.coupons != null ? couponController.coupons!.isNotEmpty ? ListView.builder(
              shrinkWrap: true,
                itemCount: couponController.coupons!.length,
                itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    Get.dialog(CouponCardDialogue(couponBody: couponController.coupons![index], index: index), barrierDismissible: true, useSafeArea: true);
                  },
                  child: SizedBox(
                    height: 150,
                    // margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(image: AssetImage(Images.coupon_bg_dark))
                    // ),
                    child: Stack(
                      children: [
                        Transform.rotate(
                          angle: Get.find<LocalizationController>().isLtr ? 0 : pi,
                          child: SizedBox(
                            height: 150,
                            // margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            child: Image.asset(Images.couponBgDark, fit: BoxFit.fill),
                          ),
                        ),
                        Row(children: [
                          Expanded(
                            flex: 3, child: Container(
                            height: 50, width: 50, alignment: Alignment.center,
                            padding: EdgeInsets.only(left: Get.find<LocalizationController>().isLtr ? 50.0 : 0, bottom: Get.find<LocalizationController>().isLtr ? 10 : 0, right: 0),
                            child: Stack(
                              children: [
                                Center(child: Image.asset(Images.couponVertical, color: Theme.of(context).primaryColor)),
                                Center(
                                  child: Text(couponController.coupons![index].discountType == 'percent' ? '%' : '\$',
                                    style: robotoBold.copyWith(fontSize: 18, color: Theme.of(context).cardColor),
                                  ),
                                ),
                              ],
                            ),
                          )
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                // SizedBox(height: 10),
                                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text('${'${couponController.coupons![index].couponType == 'free_delivery' ? 'free_delivery'.tr : couponController.coupons![index].discountType != 'percent' ?
                                  PriceConverter.convertPrice(double.parse(couponController.coupons![index].discount.toString())) :
                                  couponController.coupons![index].discount}'} ${couponController.coupons![index].couponType == 'free_delivery' ? '' : couponController.coupons![index].discountType == 'percent' ? ' %' : ''}'
                                      '${couponController.coupons![index].couponType == 'free_delivery' ? '' : 'off'.tr}',
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                  ),

                                  Row(
                                    children: [
                                      Switch(
                                        activeColor: Theme.of(context).primaryColor,
                                        value: couponController.coupons![index].status == 1 ? true : false,
                                        onChanged: (bool status){
                                          couponController.changeStatus(couponController.coupons![index].id, status).then((success) {
                                            if(success){
                                              Get.find<CouponController>().getCouponList();
                                            }
                                          });
                                        },
                                      ),

                                      PopupMenuButton(
                                          itemBuilder: (context) {
                                            return <PopupMenuEntry>[
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: Text('edit'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Text('delete'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red)),
                                              ),
                                            ];
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                          offset: const Offset(-20, 20),
                                          child: const Padding(
                                            padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                            child: Icon(Icons.more_vert, size: 25),
                                          ),
                                          onSelected: (dynamic value) {
                                            if (value == 'delete') {
                                              Get.dialog(ConfirmationDialog(
                                                icon: Images.warning, title: 'are_you_sure_to_delete'.tr, description: 'you_want_to_delete_this_coupon'.tr,
                                                onYesPressed: () {
                                                  couponController.deleteCoupon(couponController.coupons![index].id).then((success) {
                                                    if(success){
                                                      Get.find<CouponController>().getCouponList();
                                                    }
                                                  });
                                                },
                                              ), barrierDismissible: false);

                                            }else{
                                              Get.to(()=> AddCouponScreen(coupon: couponController.coupons![index]));
                                            }
                                          }
                                      ),
                                    ],
                                  ),
                                ]),

                                Text('${'code'.tr}: ${couponController.coupons![index].code!}', style: robotoMedium),
                                const SizedBox(height: 5),

                                Text('${'total_users'.tr}: ${couponController.coupons![index].totalUses}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                const SizedBox(height: 5),

                                Text('${'valid_until'.tr} ${couponController.coupons![index].startDate!} ${'to'.tr} ${couponController.coupons![index].expireDate!}',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                ),

                              ]),
                            ),
                          ),

                        ]),
                      ],
                    ),
                  ),
                )
              /*return ListTile(
                minVerticalPadding: 10,
                title: Row(
                  children: [
                    Text(couponController.coupons[index].title, style: robotoMedium),
                    Text(' (${'code'.tr + ': ' + couponController.coupons[index].code})'),
                  ],
                ),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text('${'start_date'.tr + ': ' + couponController.coupons[index].startDate} / ${'expire_date'.tr + ': ' + couponController.coupons[index].expireDate}',
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                  ),

                  Row(children: [

                  ]),
                  Text('${'discount'.tr + ': '} ${'${couponController.coupons[index].discountType != 'percent' ?
                  PriceConverter.convertPrice(double.parse(couponController.coupons[index].discount.toString())) :
                  couponController.coupons[index].discount}'} ${couponController.coupons[index].discountType == 'percent' ? ' %' : ''}',
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                  ),

                  Text('${'total_users'.tr + ': ' + couponController.coupons[index].totalUses.toString()}', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),

                  Text('${'max_discount'.tr + ': ' + couponController.coupons[index].maxDiscount.toString()} / ${'min_purchase'.tr + ': ' + couponController.coupons[index].minPurchase.toString()}',
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                  ),

                ]),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Switch(
                        activeColor: Theme.of(context).primaryColor,
                        value: couponController.coupons[index].status == 1 ? true : false,
                        onChanged: (bool status){
                          couponController.changeStatus(couponController.coupons[index].id, status).then((success) {
                            if(success){
                              Get.find<CouponController>().getCouponList();
                            }
                          });
                        },
                      ),

                      PopupMenuButton(
                        itemBuilder: (context) {
                          return <PopupMenuEntry>[
                            PopupMenuItem(
                              child: Text('edit'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('delete'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.red)),
                              value: 'delete',
                            ),
                          ];
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                        offset: Offset(-20, 20),
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.more_vert, size: 25),
                        ),
                        onSelected: (value) {
                          if (value == 'delete') {
                            Get.dialog(ConfirmationDialog(
                              icon: Images.warning, title: 'are_you_sure_to_delete'.tr, description: 'you_want_to_delete_this_coupon'.tr,
                              onYesPressed: () {
                                couponController.deleteCoupon(couponController.coupons[index].id).then((success) {
                                  if(success){
                                    Get.find<CouponController>().getCouponList();
                                    if(Get.isDialogOpen) {
                                      Get.back();
                                    }
                                  }
                                });
                              },
                            ), barrierDismissible: false);

                          }else{
                            Get.to(()=> AddCouponScreen(coupon: couponController.coupons[index]));
                          }
                        }
                      ),
                    ],
                  ),
                ),
              )*/;
            }) : Center(child: Text('no_coupon_found'.tr)) : const Center(child: CircularProgressIndicator());
          }
        ),
      ),

    );
  }
}
