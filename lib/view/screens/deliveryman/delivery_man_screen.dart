import 'package:sixam_mart_store/controller/delivery_man_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/delivery_man_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryManScreen extends StatelessWidget {
  const DeliveryManScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<DeliveryManController>().getDeliveryManList();

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      appBar: CustomAppBar(title: 'delivery_man'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RouteHelper.getAddDeliveryManRoute(null)),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add_circle_outline, color: Theme.of(context).cardColor, size: 30),
      ),

      body: GetBuilder<DeliveryManController>(builder: (dmController) {
        return dmController.deliveryManList != null ? dmController.deliveryManList!.isNotEmpty ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: dmController.deliveryManList!.length,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            DeliveryManModel deliveryMan = dmController.deliveryManList![index];
            return InkWell(
              onTap: () => Get.toNamed(RouteHelper.getDeliveryManDetailsRoute(deliveryMan)),
              child: Column(children: [

                Row(children: [

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: deliveryMan.active == 1 ? Colors.green : Colors.red, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(child: CustomImage(
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${deliveryMan.image ?? ''}',
                      height: 50, width: 50, fit: BoxFit.cover,
                    )),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: Text(
                    '${deliveryMan.fName} ${deliveryMan.lName}', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: robotoMedium,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  IconButton(
                    onPressed: () => Get.toNamed(RouteHelper.getAddDeliveryManRoute(deliveryMan)),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),

                  IconButton(
                    onPressed: () {
                      Get.dialog(ConfirmationDialog(
                        icon: Images.warning, description: 'are_you_sure_want_to_delete_this_delivery_man'.tr,
                        onYesPressed: () => Get.find<DeliveryManController>().deleteDeliveryMan(deliveryMan.id),
                      ));
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  ),

                ]),

                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Divider(
                    color: index == dmController.deliveryManList!.length-1 ? Colors.transparent : Theme.of(context).disabledColor,
                  ),
                ),

              ]),
            );
          },
        ) : Center(child: Text('no_delivery_man_found'.tr)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
