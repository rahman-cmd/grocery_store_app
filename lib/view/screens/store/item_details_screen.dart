import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/store/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Item item;
  const ItemDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<StoreController>().setAvailability(item.status == 1);
    Get.find<StoreController>().setRecommended(item.recommendedStatus == 1);
    if(Get.find<AuthController>().profileModel!.stores![0].reviewsSection!) {
      Get.find<StoreController>().getItemReviewList(item.id);
    }
    Module? module = Get.find<SplashController>().configModel!.moduleConfig!.module;

    return Scaffold(
      appBar: CustomAppBar(title: 'item_details'.tr),
      body: GetBuilder<StoreController>(builder: (storeController) {
        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getItemImagesRoute(item)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImage(
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${item.image}',
                      height: 70, width: 80, fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    item.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${'price'.tr}: ${item.price}', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular,
                  ),
                  Row(children: [
                    Expanded(child: Text(
                      '${'discount'.tr}: ${item.discount} ${item.discountType == 'percent' ? '%'
                          : Get.find<SplashController>().configModel!.currencySymbol}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: robotoRegular,
                    )),
                    (module!.unit! || Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Container(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        module.unit! ? item.unitType! : item.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
                      ),
                    ) : const SizedBox(),
                  ]),
                ])),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              module.itemAvailableTime! ? Row(children: [
                Text('daily_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Expanded(child: Text(
                  '${DateConverter.convertStringTimeToTime(item.availableTimeStarts!)}'
                      ' - ${DateConverter.convertStringTimeToTime(item.availableTimeEnds!)}',
                  maxLines: 1,
                  style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                )),
                // FlutterSwitch(
                //   width: 100, height: 30, valueFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, showOnOff: true,
                //   activeText: 'available'.tr, inactiveText: 'unavailable'.tr, activeColor: Theme.of(context).primaryColor,
                //   value: storeController.isAvailable, onToggle: (bool isActive) {
                //     storeController.toggleAvailable(item.id);
                //   },
                // ),
              ]) : const SizedBox(),

              Row(children: [
                Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
                Text(item.avgRating!.toStringAsFixed(1), style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: Text(
                  '${item.ratingCount} ${'ratings'.tr}',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                )),
                // _module.itemAvailableTime ? SizedBox() : FlutterSwitch(
                //   width: 100, height: 30, valueFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, showOnOff: true,
                //   activeText: 'available'.tr, inactiveText: 'unavailable'.tr, activeColor: Theme.of(context).primaryColor,
                //   value: storeController.isAvailable, onToggle: (bool isActive) {
                //     storeController.toggleAvailable(item.id);
                //   },
                // ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Expanded(
                  child: Text(
                    'available'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                ),

               FlutterSwitch(
                    width: 60, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
                    activeColor: Theme.of(context).primaryColor,
                    value: storeController.isAvailable, onToggle: (bool isActive) {
                  storeController.toggleAvailable(item.id);
                }),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(children: [
                Expanded(
                  child: Text(
                    'recommended'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                ),

                FlutterSwitch(
                  width: 60, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
                  activeColor: Theme.of(context).primaryColor,
                  value: storeController.isRecommended, onToggle: (bool isActive) {
                  storeController.toggleRecommendedProduct(item.id);
                },
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Get.find<SplashController>().getStoreModuleConfig().newVariation! ? FoodVariationView(
                item: item,
              ) : VariationView(item: item, stock: module.stock),

              Row(children: [
                module.stock! ? Text('${'total_stock'.tr}:', style: robotoMedium) : const SizedBox(),
                SizedBox(width: module.stock! ? Dimensions.paddingSizeExtraSmall : 0),
                module.stock! ? Text(
                  item.stock.toString(),
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                ) : const SizedBox(),
              ]),
              SizedBox(height: module.stock! ? Dimensions.paddingSizeLarge : 0),

              (item.addOns!.isNotEmpty && module.addOn!) ? Text('addons'.tr, style: robotoMedium) : const SizedBox(),
              SizedBox(height: (item.addOns!.isNotEmpty && module.addOn!) ? Dimensions.paddingSizeExtraSmall : 0),
              (item.addOns!.isNotEmpty && module.addOn!) ? ListView.builder(
                itemCount: item.addOns!.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(children: [

                    Text('${item.addOns![index].name!}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text(
                      PriceConverter.convertPrice(item.addOns![index].price),
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),

                  ]);
                },
              ) : const SizedBox(),
              SizedBox(height: item.addOns!.isNotEmpty ? Dimensions.paddingSizeLarge : 0),

              (item.description != null && item.description!.isNotEmpty) ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('description'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(item.description!, style: robotoRegular),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ],
              ) : const SizedBox(),

              Get.find<AuthController>().profileModel!.stores![0].reviewsSection! ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('reviews'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  storeController.itemReviewList != null ? storeController.itemReviewList!.isNotEmpty ? ListView.builder(
                    itemCount: storeController.itemReviewList!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ReviewWidget(
                        review: storeController.itemReviewList![index], fromStore: false,
                        hasDivider: index != storeController.itemReviewList!.length-1,
                      );
                    },
                  ) : Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    child: Center(child: Text('no_review_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                  ) : const Padding(
                    padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ) : const SizedBox(),

            ]),
          )),

          CustomButton(
            onPressed: () {
              if(Get.find<AuthController>().profileModel!.stores![0].itemSection!) {
                // TODO: add product
                Get.toNamed(RouteHelper.getItemRoute(item));
              }else {
                showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
              }
            },
            buttonText: 'update_item'.tr,
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ),

        ]);
      }),
    );
  }
}

class VariationView extends StatelessWidget {
  final Item item;
  final bool? stock;
  const VariationView({Key? key, required this.item, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      (item.variations != null && item.variations!.isNotEmpty) ? Text('variations'.tr, style: robotoMedium) : const SizedBox(),
      SizedBox(height: (item.variations != null && item.variations!.isNotEmpty) ? Dimensions.paddingSizeExtraSmall : 0),

      (item.variations != null && item.variations!.isNotEmpty) ? ListView.builder(
        itemCount: item.variations!.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Row(children: [

            Text('${item.variations![index].type!}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              PriceConverter.convertPrice(item.variations![index].price),
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            SizedBox(width: stock! ? Dimensions.paddingSizeExtraSmall : 0),
            stock! ? Text(
              '(${item.variations![index].stock})',
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            ) : const SizedBox(),

          ]);
        },
      ) : const SizedBox(),

      SizedBox(height: (item.variations != null && item.variations!.isNotEmpty) ? Dimensions.paddingSizeLarge : 0),

    ]);
  }
}

class FoodVariationView extends StatelessWidget {
  final Item item;
  const FoodVariationView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      (item.foodVariations != null && item.foodVariations!.isNotEmpty) ? Text('variations'.tr, style: robotoMedium) : const SizedBox(),
      SizedBox(height: (item.foodVariations != null && item.foodVariations!.isNotEmpty) ? Dimensions.paddingSizeExtraSmall : 0),

      (item.foodVariations != null && item.foodVariations!.isNotEmpty) ? ListView.builder(
        itemCount: item.foodVariations!.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Text('${item.foodVariations![index].name!} - ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                Text(
                  ' ${item.foodVariations![index].type == 'multi' ? 'multiple_select'.tr : 'single_select'.tr}'
                    ' (${item.foodVariations![index].required == 'on' ? 'required'.tr : 'optional'.tr})',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
              ]),

              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              ListView.builder(
                itemCount: item.foodVariations![index].variationValues!.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 20),
                shrinkWrap: true,
                itemBuilder: (context, i){
                  return Text(
                    '${item.foodVariations![index].variationValues![i].level}'
                        ' - ${PriceConverter.convertPrice(double.parse(item.foodVariations![index].variationValues![i].optionPrice!))}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                  );
                },
              ),

            ]),
          );
        },
      ) : const SizedBox(),

      SizedBox(height: (item.foodVariations != null && item.foodVariations!.isNotEmpty) ? Dimensions.paddingSizeLarge : 0),

    ]);
  }
}

