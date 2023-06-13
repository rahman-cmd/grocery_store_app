import 'package:sixam_mart_store/controller/pos_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/cart_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/rating_bar.dart';
import 'package:sixam_mart_store/view/screens/pos/widget/product_bottom_sheet.dart';
import 'package:sixam_mart_store/view/screens/pos/widget/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  const PosProductWidget({Key? key, required this.cart, required this.cartIndex, required this.isAvailable, required this.addOns}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String addOnText = '';
    int index = 0;
    List<int?> ids = [];
    List<int?> qtys = [];
    for (var addOn in cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }
    for (var addOn in cart.item!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText = '$addOnText${(index == 0) ? '' : ',  '}${addOn.name} (${qtys[index]})';
        index = index + 1;
      }
    }

    String? variationText = '';
    if(cart.variation!.isNotEmpty) {
      List<String> variationTypes = cart.variation![0].type!.split('-');
      if(variationTypes.length == cart.item!.choiceOptions!.length) {
        int index = 0;
        for (var choice in cart.item!.choiceOptions!) {
          variationText = '${variationText!}${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
          index = index + 1;
        }
      }else {
        variationText = cart.item!.variations![0].type;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => ItemBottomSheet(item: cart.item, cartIndex: cartIndex, cart: cart),
          );
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          child: Stack(children: [
            const Positioned(
              top: 0, bottom: 0, right: 0, left: 0,
              child: Icon(Icons.delete, color: Colors.white, size: 50),
            ),
            Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) => Get.find<PosController>().removeFromCart(cartIndex),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  boxShadow: [BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                    blurRadius: 5, spreadRadius: 1,
                  )],
                ),
                child: Column(
                  children: [

                    Row(children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${cart.item!.image}',
                              height: 65, width: 70, fit: BoxFit.cover,
                            ),
                          ),
                          isAvailable ? const SizedBox() : Positioned(
                            top: 0, left: 0, bottom: 0, right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.black.withOpacity(0.6)),
                              child: Text('not_available_now_break'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                                color: Colors.white, fontSize: 8,
                              )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            cart.item!.name!,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          RatingBar(rating: cart.item!.avgRating, size: 12, ratingCount: cart.item!.ratingCount),
                          const SizedBox(height: 5),
                          Text(
                            PriceConverter.convertPrice(cart.discountedPrice!+cart.discountAmount!),
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                        ]),
                      ),

                      Row(children: [
                        QuantityButton(
                          onTap: () {
                            if (cart.quantity! > 1) {
                              Get.find<PosController>().setQuantity(false, cart);
                            }else {
                              Get.find<PosController>().removeFromCart(cartIndex);
                            }
                          },
                          isIncrement: false,
                        ),
                        Text(cart.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                        QuantityButton(
                          onTap: () => Get.find<PosController>().setQuantity(true, cart),
                          isIncrement: true,
                        ),
                      ]),

                      !ResponsiveHelper.isMobile(context) ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: IconButton(
                          onPressed: () {
                            Get.find<PosController>().removeFromCart(cartIndex);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ) : const SizedBox(),

                    ]),

                    addOnText.isNotEmpty ? Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        const SizedBox(width: 80),
                        Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Flexible(child: Text(
                          addOnText,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        )),
                      ]),
                    ) : const SizedBox(),

                    cart.item!.variations!.isNotEmpty ? Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        const SizedBox(width: 80),
                        Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Flexible(child: Text(
                          variationText!,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        )),
                      ]),
                    ) : const SizedBox(),

                    /*addOns.length > 0 ? SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                        itemCount: addOns.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(children: [
                              InkWell(
                                onTap: () {
                                  Get.find<CartController>().removeAddOn(cartIndex, index);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                                ),
                              ),
                              Text(addOns[index].name, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                              SizedBox(width: 2),
                              Text(
                                PriceConverter.convertPrice(addOns[index].price),
                                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '(${cart.addOnIds[index].quantity})',
                                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                            ]),
                          );
                        },
                      ),
                    ) : SizedBox(),*/

                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
