import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/data/model/response/expense_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
class ExpenseCard extends StatelessWidget {
  final Expense expense;
  const ExpenseCard({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, offset: const Offset(0, 5), blurRadius: 10)]
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text('${'order_id'.tr}: #${expense.orderId}', style: robotoMedium),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        const Divider(),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            DateConverter.dateTimeStringToDateTime(expense.createdAt!),
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
          ),
          Text('amount'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Text('${'expense_type'.tr} - ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
            Text(expense.type!.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue)),
          ]),
          Text(PriceConverter.convertPrice(expense.amount), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,)),
        ]),
      ]),
    );
  }
}
