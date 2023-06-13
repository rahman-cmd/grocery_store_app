import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttributeView extends StatefulWidget {
  final StoreController storeController;
  final Item? product;
  const AttributeView({Key? key, required this.storeController, required this.product}) : super(key: key);

  @override
  State<AttributeView> createState() => _AttributeViewState();
}

class _AttributeViewState extends State<AttributeView> {
  @override
  Widget build(BuildContext context) {
    bool? stock = Get.find<SplashController>().configModel!.moduleConfig!.module!.stock;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text(
        'attribute'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.storeController.attributeList!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => widget.storeController.toggleAttribute(index, widget.product),
              child: Container(
                width: 100, alignment: Alignment.center,
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: widget.storeController.attributeList![index].active ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(
                  widget.storeController.attributeList![index].attribute.name!, maxLines: 2, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: widget.storeController.attributeList![index].active ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(height: widget.storeController.attributeList!.where((element) => element.active).isNotEmpty ? Dimensions.paddingSizeLarge : 0),

      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.storeController.attributeList!.length,
        itemBuilder: (context, index) {
          return widget.storeController.attributeList![index].active ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [

              Container(
                width: 100, height: 50, alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(
                  widget.storeController.attributeList![index].attribute.name!, maxLines: 2, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeLarge),

              Expanded(child: MyTextField(
                controller: widget.storeController.attributeList![index].controller,
                inputAction: TextInputAction.done,
                capitalization: TextCapitalization.words,
                title: false,
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              CustomButton(
                onPressed: () {
                  String variant = widget.storeController.attributeList![index].controller.text.trim();
                  if(variant.isEmpty) {
                    showCustomSnackBar('enter_a_variant_name'.tr);
                  }else {
                    widget.storeController.attributeList![index].controller.text = '';
                    widget.storeController.addVariant(index, variant, widget.product);
                  }
                },
                buttonText: 'add'.tr,
                width: 70, height: 50,
              ),

            ]),

            Container(
              height: 30, margin: const EdgeInsets.only(left: 120),
              child: widget.storeController.attributeList![index].variants.isNotEmpty ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                itemCount: widget.storeController.attributeList![index].variants.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Row(children: [
                      Text(widget.storeController.attributeList![index].variants[i], style: robotoRegular),
                      InkWell(
                        onTap: () => widget.storeController.removeVariant(index, i, widget.product),
                        child: const Padding(
                          padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: Icon(Icons.close, size: 15),
                        ),
                      ),
                    ]),
                  );
                },
              ) : Align(alignment: Alignment.centerLeft, child: Text('no_variant_added_yet'.tr)),
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),

          ]) : const SizedBox();
        },
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge),

      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.storeController.variantTypeList!.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
            ),
            child: Column(children: [

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${'variant'.tr}:',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(
                  widget.storeController.variantTypeList![index].variantType,
                  style: robotoRegular, textAlign: TextAlign.center, maxLines: 1,
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(children: [

                Expanded(child: MyTextField(
                  hintText: 'price'.tr,
                  controller: widget.storeController.variantTypeList![index].priceController,
                  focusNode: widget.storeController.variantTypeList![index].priceNode,
                  nextFocus: stock! ? widget.storeController.variantTypeList![index].stockNode : index != widget.storeController.variantTypeList!.length-1
                      ? widget.storeController.variantTypeList![index+1].priceNode : null,
                  inputAction: (stock && index != widget.storeController.variantTypeList!.length-1) ? TextInputAction.next : TextInputAction.done,
                  isAmount: true,
                  amountIcon: true,
                )),
                SizedBox(width: stock ? Dimensions.paddingSizeSmall : 0),

                stock ? Expanded(child: MyTextField(
                  hintText: 'stock'.tr,
                  controller: widget.storeController.variantTypeList![index].stockController,
                  focusNode: widget.storeController.variantTypeList![index].stockNode,
                  nextFocus: index != widget.storeController.variantTypeList!.length-1 ? widget.storeController.variantTypeList![index+1].priceNode : null,
                  inputAction: index != widget.storeController.variantTypeList!.length-1 ? TextInputAction.next : TextInputAction.done,
                  isNumber: true,
                  onChanged: (String text) => Get.find<StoreController>().setTotalStock(),
                )) : const SizedBox(),

              ]),

            ]),
          );
        },
      ),
      SizedBox(height: widget.storeController.hasAttribute() ? Dimensions.paddingSizeLarge : 0),

    ]);
  }
}
