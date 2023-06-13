import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class OrderButton extends StatelessWidget {
  final String title;
  final int index;
  final OrderController orderController;
  final bool fromHistory;
  const OrderButton({Key? key, required this.title, required this.index, required this.orderController, required this.fromHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex;
    int length = 0;
    int titleLength = 0;
    if(fromHistory) {
      selectedIndex = orderController.historyIndex;
      titleLength = orderController.statusList.length;
      length = 0;
    }else {
      selectedIndex = orderController.orderIndex;
      titleLength = orderController.runningOrders!.length;
      length = orderController.runningOrders![index].orderList.length;
    }
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => fromHistory ? orderController.setHistoryIndex(index) : orderController.setOrderIndex(index),
      child: Row(children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          ),
          alignment: Alignment.center,
          child: Text(
            '$title${fromHistory ? '' : ' ($length)'}',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),

        (index != titleLength-1 && index != selectedIndex && index != selectedIndex-1) ? Container(
          height: 15, width: 1, color: Theme.of(context).disabledColor,
        ) : const SizedBox(),

      ]),
    );
  }
}
