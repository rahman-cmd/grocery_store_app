import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/discount_tag.dart';
import 'package:sixam_mart_store/view/base/not_available_widget.dart';
import 'package:sixam_mart_store/view/base/rating_bar.dart';
import 'package:sixam_mart_store/view/screens/store/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final int index;
  final int length;
  final bool inStore;
  final bool isCampaign;
  const ItemWidget({Key? key, required this.item, required this.index,
   required this.length, this.inStore = false, this.isCampaign = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    discount = (item.storeDiscount == 0 || isCampaign) ? item.discount : item.storeDiscount;
    discountType = (item.storeDiscount == 0 || isCampaign) ? item.discountType : 'percent';
    isAvailable = DateConverter.isAvailable(item.availableTimeStarts, item.availableTimeEnds);

    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getItemDetailsRoute(item), arguments: ItemDetailsScreen(item: item)),
      child: Container(
        padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
          boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
            color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5,
          )] : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
            child: Row(children: [

              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImage(
                    image: '${isCampaign ? baseUrls!.campaignImageUrl : baseUrls!.itemImageUrl}/${item.image}',
                    height: desktop ? 120 : 65, width: desktop ? 120 : 80, fit: BoxFit.cover,
                  ),
                ),
                DiscountTag(
                  discount: discount, discountType: discountType,
                  freeDelivery: false,
                ),
                isAvailable ? const SizedBox() : const NotAvailableWidget(isStore: false),
              ]),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text(
                    item.name!,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  RatingBar(
                    rating: item.avgRating, size: desktop ? 15 : 12,
                    ratingCount: item.ratingCount,
                  ),

                  Row(children: [

                    Text(
                      PriceConverter.convertPrice(item.price, discount: discount, discountType: discountType),
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                    discount > 0 ? Text(
                      PriceConverter.convertPrice(item.price),
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).disabledColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ) : const SizedBox(),

                  ]),

                ]),
              ),

              IconButton(
                onPressed: () {
                  if(Get.find<AuthController>().profileModel!.stores![0].itemSection!) {
                    Get.toNamed(RouteHelper.getItemRoute(item));
                  }else {
                    showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                  }
                },
                icon: const Icon(Icons.edit, color: Colors.blue),
              ),

              IconButton(
                onPressed: () {
                  if(Get.find<AuthController>().profileModel!.stores![0].itemSection!) {
                    Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: 'are_you_sure_want_to_delete_this_product'.tr,
                      onYesPressed: () => Get.find<StoreController>().deleteItem(item.id),
                    ));
                  }else {
                    showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                  }
                },
                icon: const Icon(Icons.delete_forever, color: Colors.red),
              ),

            ]),
          )),

          desktop ? const SizedBox() : Padding(
            padding: EdgeInsets.only(left: desktop ? 130 : 90),
            child: Divider(color: index == length-1 ? Colors.transparent : Theme.of(context).disabledColor),
          ),

        ]),
      ),
    );
  }
}
