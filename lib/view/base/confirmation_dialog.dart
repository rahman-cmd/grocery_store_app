import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/campaign_controller.dart';
import 'package:sixam_mart_store/controller/delivery_man_controller.dart';
import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final String? adminText;
  final Function onYesPressed;
  final Function? onNoPressed;
  final bool isLogOut;
  const ConfirmationDialog({Key? key, 
    required this.icon, this.title, required this.description, this.adminText, required this.onYesPressed,
    this.onNoPressed, this.isLogOut = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Image.asset(icon, width: 50, height: 50),
          ),

          title != null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              title!, textAlign: TextAlign.center,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
            ),
          ) : const SizedBox(),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(description, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          ),

          adminText != null && adminText!.isNotEmpty ? Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text('[$adminText]', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          ) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          GetBuilder<DeliveryManController>(builder: (dmController) {
            return GetBuilder<StoreController>(builder: (storeController) {
              return GetBuilder<CampaignController>(builder: (campaignController) {
                return GetBuilder<OrderController>(builder: (orderController) {
                    return GetBuilder<AuthController>(builder: (authController) {
                      return (orderController.isLoading || campaignController.isLoading || storeController.isLoading
                      || dmController.isLoading || authController.isLoading) ? const Center(child: CircularProgressIndicator()) : Row(children: [

                        Expanded(child: TextButton(
                          onPressed: () => isLogOut ? onYesPressed() : onNoPressed != null ? onNoPressed!() : Get.back(),
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                          ),
                          child: Text(
                            isLogOut ? 'yes'.tr : 'no'.tr, textAlign: TextAlign.center,
                            style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                          ),
                        )),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(child: CustomButton(
                          buttonText: isLogOut ? 'no'.tr : 'yes'.tr,
                          onPressed: () => isLogOut ? Get.back() : onYesPressed(),
                          height: 40,
                        )),

                      ]);
                    });
                  }
                );
              });
            });
          }),

        ]),
      )),
    );
  }
}