import 'package:sixam_mart_store/controller/campaign_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/campaign_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/screens/campaign/campaign_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignWidget extends StatelessWidget {
  final CampaignModel campaignModel;
  const CampaignWidget({Key? key, required this.campaignModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        RouteHelper.getCampaignDetailsRoute(campaignModel.id),
        arguments: CampaignDetailsScreen(campaignModel: campaignModel),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: CustomImage(
              image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}/${campaignModel.image}',
              height: 85, width: 100, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

            Text(campaignModel.title!, style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              campaignModel.description ?? 'no_description_found'.tr, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(children: [

              InkWell(
                onTap: () {
                  if(campaignModel.vendorStatus == null){
                    Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: campaignModel.isJoined! ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
                      adminText: '' ,
                      onYesPressed: () {
                        Get.find<CampaignController>().joinCampaign(campaignModel.id, false);
                      },
                    ));
                  }else if(campaignModel.vendorStatus == 'confirmed'){
                    Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: campaignModel.isJoined! ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
                      adminText: '' ,
                      onYesPressed: () {
                        Get.find<CampaignController>().leaveCampaign(campaignModel.id, false);
                      },
                    ));
                  }

                },
                child: Container(
                  height: 25, width: 70, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: campaignModel.vendorStatus == null ? Theme.of(context).primaryColor : campaignModel.vendorStatus == 'rejected' ? Theme.of(context).colorScheme.error : Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(campaignModel.vendorStatus == null ? 'join_now'.tr : campaignModel.vendorStatus != 'confirmed'
                      ? campaignModel.vendorStatus!.tr : 'leave_now'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(
                    color: Theme.of(context).cardColor,
                    fontSize: Dimensions.fontSizeExtraSmall,
                  )),
                ),
              ),
              const Expanded(child: SizedBox()),

              Icon(Icons.date_range, size: 15, color: Theme.of(context).disabledColor),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                DateConverter.convertDateToDate(campaignModel.availableDateStarts!),
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
              ),

            ]),

          ])),

        ]),
      ),
    );
  }
}
