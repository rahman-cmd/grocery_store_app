import 'package:sixam_mart_store/controller/bank_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/screens/bank/widget/withdraw_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawHistoryScreen extends StatelessWidget {
  const WithdrawHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar(title: 'withdraw_history'.tr, menuWidget: PopupMenuButton(
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            getMenuItem(Get.find<BankController>().statusList[0], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<BankController>().statusList[1], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<BankController>().statusList[2], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<BankController>().statusList[3], context),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        offset: const Offset(-25, 25),
        child: Container(
          width: 40, height: 40,
          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: const Icon(Icons.arrow_drop_down, size: 30),
        ),
        onSelected: (dynamic value) {
          int index = Get.find<BankController>().statusList.indexOf(value);
          Get.find<BankController>().filterWithdrawList(index);
        },
      )),

      body: GetBuilder<BankController>(builder: (bankController) {
        return bankController.withdrawList!.isNotEmpty ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: bankController.withdrawList!.length,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            return WithdrawWidget(
              withdrawModel: bankController.withdrawList![index],
              showDivider: index != bankController.withdrawList!.length - 1,
            );
          },
        ) : Center(child: Text('no_withdraw_history_found'.tr));
      }),

    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      value: status,
      height: 30,
      child: Text(status.toLowerCase().tr, style: robotoRegular.copyWith(
        color: status == 'Pending' ? Theme.of(context).primaryColor : status == 'Approved' ? Colors.green
            : status == 'Denied' ? Colors.red : null,
      )),
    );
  }

}
