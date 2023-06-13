import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';

class AmountInputDialogue extends StatefulWidget {
  final int orderId;
  final bool isItemPrice;
  final double? amount;
  const AmountInputDialogue({Key? key, required this.orderId, required this.isItemPrice, required this.amount}) : super(key: key);

  @override
  State<AmountInputDialogue> createState() => _AmountInputDialogueState();
}

class _AmountInputDialogueState extends State<AmountInputDialogue> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _amountController.text = widget.amount.toString();
  }
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
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              widget.isItemPrice ? 'update_order_amount'.tr : 'update_discount_amount'.tr, textAlign: TextAlign.center,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          MyTextField(
            hintText: widget.isItemPrice ? 'order_amount'.tr : 'discount_amount'.tr,
            controller: _amountController,
            focusNode: _amountNode,
            inputAction: TextInputAction.done,
            isAmount: true,
            amountIcon: true,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          GetBuilder<OrderController>(
            builder: (orderController) {
              return !orderController.isLoading ? CustomButton(
                buttonText: 'submit'.tr,
                onPressed: (){
                  orderController.updateOrderAmount(widget.orderId, _amountController.text.trim(), widget.isItemPrice);
                },
              ) : const CircularProgressIndicator();
            }
          )

        ]),
      )),
    );
  }
}