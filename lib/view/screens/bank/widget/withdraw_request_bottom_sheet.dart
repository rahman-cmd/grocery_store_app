import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/bank_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class WithdrawRequestBottomSheet extends StatelessWidget {
  const WithdrawRequestBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Text('withdraw'.tr, style: robotoMedium),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        Image.asset(Images.bank, height: 30, width: 30),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(Get.find<AuthController>().profileModel!.bankName!, style: robotoRegular),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(
          Get.find<AuthController>().profileModel!.branch!,
          style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(
          Get.find<AuthController>().profileModel!.accountNo!,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        Text('enter_amount'.tr, style: robotoRegular),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        TextField(
          controller: amountController,
          textAlign: TextAlign.center,
          style: robotoMedium,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          decoration: InputDecoration(
            hintText: 'enter_amount'.tr,
            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
            prefixIcon: Text(
              Get.find<SplashController>().configModel!.currencySymbol!,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        GetBuilder<BankController>(builder: (bankController) {
          return !bankController.isLoading ? CustomButton(
            buttonText: 'withdraw'.tr,
            onPressed: () {
              String amount = amountController.text.trim();
              if(amount.isEmpty) {
                showCustomSnackBar('enter_amount'.tr);
              } else if(double.parse(amount) > 999999){
                showCustomSnackBar('you_cant_withdraw_more_then_1000000'.tr);
              }
              else {
                bankController.requestWithdraw(amount);
              }
            },
          ) : const Center(child: CircularProgressIndicator());
        }),

      ]),
    );
  }
}
