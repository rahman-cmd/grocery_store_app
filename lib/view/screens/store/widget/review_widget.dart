import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/review_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  final bool fromStore;
  const ReviewWidget({Key? key, required this.review, required this.hasDivider, required this.fromStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Row(children: [

        ClipOval(
          child: CustomImage(
            image: '${fromStore ? Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl
                : Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${fromStore
                ? review.itemImage : review.customer != null ? review.customer!.image : ''}',
            height: 60, width: 60, fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(
            fromStore ? review.itemName! : review.customer != null ?'${ review.customer!.fName} ${ review.customer!.lName}' : 'customer_not_found'.tr,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: review.customerName != null ? Theme.of(context).textTheme.displayLarge!.color : Theme.of(context).disabledColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          RatingBar(rating: review.rating!.toDouble(), ratingCount: null, size: 15),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          fromStore ? Text(
            review.customerName != null ? review.customerName! : 'customer_not_found'.tr,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                color: review.customerName != null ? Theme.of(context).textTheme.displayLarge!.color : Theme.of(context).disabledColor),
          ) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(review.comment!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor)),

        ])),

      ]),

      hasDivider ? Padding(
        padding: const EdgeInsets.only(left: 70),
        child: Divider(color: Theme.of(context).disabledColor),
      ) : const SizedBox(),

    ]);
  }
}
