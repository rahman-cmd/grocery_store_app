import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRequestDialog extends StatefulWidget {
  final int orderId;

  const NewRequestDialog({Key? key, required this.orderId}) : super(key: key);

  @override
  State<NewRequestDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NewRequestDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  void _startAlarm() async {
    AudioCache audio = AudioCache();
    audio.play('notification.mp3');
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      audio.play('notification.mp3');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Image.asset(Images.notificationIn, height: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(
              'new_order_placed'.tr, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),

          CustomButton(
            height: 40,
            buttonText: 'ok'.tr,
            onPressed: () {
              _timer?.cancel();
              if(Get.isDialogOpen!) {
                Get.back();
              }

              Get.offAllNamed(RouteHelper.getOrderDetailsRoute(widget.orderId, fromNotification: true));

            },
          ),

        ]),
      ),
    );
  }
}
