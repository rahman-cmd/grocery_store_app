import 'package:sixam_mart_store/controller/pos_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/cart_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/discount_tag.dart';
import 'package:sixam_mart_store/view/base/rating_bar.dart';
import 'package:sixam_mart_store/view/screens/pos/widget/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemBottomSheet extends StatelessWidget {
  final Item? item;
  final bool isCampaign;
  final CartModel? cart;
  final int? cartIndex;
  const ItemBottomSheet({Key? key, required this.item, this.isCampaign = false, this.cart, this.cartIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool fromCart = cart != null;
    Get.find<PosController>().initData(item, cart);

    return Container(
      width: 550,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<PosController>(builder: (posController) {
        double? startingPrice;
        double? endingPrice;
        if (item!.choiceOptions!.isNotEmpty) {
          List<double?> priceList = [];
          for (var variation in item!.variations!) {
            priceList.add(variation.price);
          }
          priceList.sort((a, b) => a!.compareTo(b!));
          startingPrice = priceList[0];
          if (priceList[0]! < priceList[priceList.length - 1]!) {
            endingPrice = priceList[priceList.length - 1];
          }
        } else {
          startingPrice = item!.price;
        }

        List<String> variationList = [];
        for (int index = 0; index < item!.choiceOptions!.length; index++) {
          variationList.add(item!.choiceOptions![index].options![posController.variationIndex![index]].replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        for (var variation in variationList) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        }

        double? price = item!.price;
        Variation? variation;
        for (Variation variation in item!.variations!) {
          if (variation.type == variationType) {
            price = variation.price;
            variation = variation;
            break;
          }
        }

        double? discount = (isCampaign || item!.storeDiscount == 0) ? item!.discount : item!.storeDiscount;
        String? discountType = (isCampaign || item!.storeDiscount == 0) ? item!.discountType : 'percent';
        double priceWithDiscount = PriceConverter.convertWithDiscount(price, discount, discountType)!;
        double priceWithQuantity = priceWithDiscount * posController.quantity!;
        double addonsCost = 0;
        List<AddOn> addOnIdList = [];
        List<AddOns> addOnsList = [];
        for (int index = 0; index < item!.addOns!.length; index++) {
          if (posController.addOnActiveList[index]) {
            addonsCost = addonsCost + (item!.addOns![index].price! * posController.addOnQtyList[index]!);
            addOnIdList.add(AddOn(id: item!.addOns![index].id, quantity: posController.addOnQtyList[index]));
            addOnsList.add(item!.addOns![index]);
          }
        }
        double priceWithAddons = priceWithQuantity + addonsCost;
        bool isAvailable = DateConverter.isAvailable(item!.availableTimeStarts, item!.availableTimeEnds);

        CartModel cartModel = CartModel(
          price: price, discountedPrice: priceWithDiscount, variation: variation != null ? [variation] : [],
          discountAmount: (price! - PriceConverter.convertWithDiscount(price, discount, discountType)!), item: item,
          quantity: posController.quantity, addOnIds: addOnIdList, addOns: addOnsList, isCampaign: isCampaign,
        );
        //bool isExistInCart = Get.find<CartController>().isExistInCart(_cartModel, fromCart, cartIndex);

        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            ResponsiveHelper.isDesktop(context) ? InkWell(onTap: () => Get.back(), child: const Icon(Icons.close)) : const SizedBox(),
            Padding(
              padding: EdgeInsets.only(
                right: Dimensions.paddingSizeDefault, top: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault,
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                //Product
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image: '${isCampaign ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl
                            : Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${item!.image}',
                        width: ResponsiveHelper.isMobile(context) ? 100 : 140,
                        height: ResponsiveHelper.isMobile(context) ? 100 : 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    DiscountTag(discount: discount, discountType: discountType, fromTop: 20),
                  ]),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        item!.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      RatingBar(rating: item!.avgRating, size: 15, ratingCount: item!.ratingCount),
                      const SizedBox(height: 5),
                      Text(
                        '${PriceConverter.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                            '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice, discount: discount,
                            discountType: discountType)}' : ''}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(height: 5),
                      price > priceWithDiscount ? Text(
                        '${PriceConverter.convertPrice(startingPrice)}'
                            '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice)}' : ''}',
                        style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough),
                      ) : const SizedBox(),
                    ]),
                  ),
                ]),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                (item!.description != null && item!.description!.isNotEmpty) ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('description'.tr, style: robotoMedium),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(item!.description!, style: robotoRegular),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ],
                ) : const SizedBox(),

                // Variation
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: item!.choiceOptions!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item!.choiceOptions![index].title!, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context) ? 3 : 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                          childAspectRatio: (1 / 0.25),
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: item!.choiceOptions![index].options!.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              posController.setCartVariationIndex(index, i);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: posController.variationIndex![index] != i ? Theme.of(context).disabledColor.withOpacity(0.2)
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                border: posController.variationIndex![index] != i
                                    ? Border.all(color: Theme.of(context).disabledColor, width: 2) : null,
                              ),
                              child: Text(
                                item!.choiceOptions![index].options![i].trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                  color: posController.variationIndex![index] != i ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: index != item!.choiceOptions!.length - 1 ? Dimensions.paddingSizeLarge : 0),
                    ]);
                  },
                ),
                item!.choiceOptions!.isNotEmpty ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

                // Quantity
                Row(children: [
                  Text('quantity'.tr, style: robotoMedium),
                  const Expanded(child: SizedBox()),
                  Row(children: [
                    QuantityButton(
                      onTap: () {
                        if (posController.quantity! > 1) {
                          posController.setProductQuantity(false);
                        }
                      },
                      isIncrement: false,
                    ),
                    Text(posController.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    QuantityButton(
                      onTap: () => posController.setProductQuantity(true),
                      isIncrement: true,
                    ),
                  ]),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                // Addons
                item!.addOns!.isNotEmpty ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('addons'.tr, style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20, mainAxisSpacing: 10, childAspectRatio: (1 / 1.1),
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: item!.addOns!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (!posController.addOnActiveList[index]) {
                            posController.addAddOn(true, index);
                          } else if (posController.addOnQtyList[index] == 1) {
                            posController.addAddOn(false, index);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: posController.addOnActiveList[index] ? 2 : 20),
                          decoration: BoxDecoration(
                            color: posController.addOnActiveList[index] ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: posController.addOnActiveList[index] ? null : Border.all(color: Theme.of(context).disabledColor, width: 2),
                            boxShadow: posController.addOnActiveList[index]
                            ? [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)] : null,
                          ),
                          child: Column(children: [
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(item!.addOns![index].name!,
                                  maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(
                                    color: posController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  PriceConverter.convertPrice(item!.addOns![index].price),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    color: posController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                  ),
                                ),
                              ]),
                            ),
                            posController.addOnActiveList[index] ? Container(
                              height: 25,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).cardColor),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (posController.addOnQtyList[index]! > 1) {
                                        posController.setAddOnQuantity(false, index);
                                      } else {
                                        posController.addAddOn(false, index);
                                      }
                                    },
                                    child: const Center(child: Icon(Icons.remove, size: 15)),
                                  ),
                                ),
                                Text(
                                  posController.addOnQtyList[index].toString(),
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => posController.setAddOnQuantity(true, index),
                                    child: const Center(child: Icon(Icons.add, size: 15)),
                                  ),
                                ),
                              ]),
                            )
                                : const SizedBox(),
                          ]),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                ]) : const SizedBox(),

                Row(children: [
                  Text('${'total_amount'.tr}:', style: robotoMedium),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(PriceConverter.convertPrice(priceWithAddons), style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                //Add to cart Button

                isAvailable ? const SizedBox() : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Column(children: [
                    Text('not_available_now'.tr, style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                    )),
                    Text(
                      '${'available_will_be'.tr} ${DateConverter.convertStringTimeToTime(item!.availableTimeStarts!)} '
                          '- ${DateConverter.convertStringTimeToTime(item!.availableTimeEnds!)}',
                      style: robotoRegular,
                    ),
                  ]),
                ),

                (!item!.scheduleOrder! && !isAvailable) ? const SizedBox() : CustomButton(
                  width: ResponsiveHelper.isDesktop(context) ? size.width / 2.0 : null,
                  /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                      ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                  buttonText: isCampaign ? 'order_now'.tr : fromCart ? 'update'.tr : 'add'.tr,
                  onPressed: () {
                    Get.back();
                    if(isCampaign) {

                    }else {
                      Get.find<PosController>().addToCart(cartModel, cartIndex);
                      showCustomSnackBar(fromCart ? 'item_updated'.tr : 'item_added'.tr, isError: false);
                    }
                  },
                  /*onPressed: (!isExistInCart) ? () {
                    if (!isExistInCart) {
                      Get.back();
                      if(isCampaign) {
                        Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                          fromCart: false, cartList: [_cartModel],
                        ));
                      }else {
                        if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                          Get.dialog(ConfirmationDialog(
                            icon: Images.warning,
                            title: 'are_you_sure_to_reset'.tr,
                            description: 'if_you_continue'.tr,
                            onYesPressed: () {
                              Get.back();
                              Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                              _showCartSnackBar(context);
                            },
                          ), barrierDismissible: false);
                        } else {
                          Get.find<CartController>().addToCart(_cartModel, cartIndex);
                          _showCartSnackBar(context);
                        }
                      }
                    }
                  } : null,*/

                ),
              ]),
            ),
          ]),
        );
      }),
    );
  }
}

