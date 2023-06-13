import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/category_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryModel? categoryModel;
  const CategoryScreen({Key? key, required this.categoryModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCategory = categoryModel == null;
    if(isCategory) {
      Get.find<StoreController>().getCategoryList(null);
    }else {
      Get.find<StoreController>().getSubCategoryList(categoryModel!.id, null);
    }

    return Scaffold(
      appBar: CustomAppBar(title: isCategory ? 'categories'.tr : categoryModel!.name),
      body: GetBuilder<StoreController>(builder: (storeController) {
        List<CategoryModel>? categories;
        if(isCategory && storeController.categoryList != null) {
          categories = [];
          categories.addAll(storeController.categoryList!);
        }else if(!isCategory && storeController.subCategoryList != null) {
          categories = [];
          categories.addAll(storeController.subCategoryList!);
        }
        return categories != null ? categories.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            if(isCategory) {
              await Get.find<StoreController>().getCategoryList(null);
            }else {
              await Get.find<StoreController>().getSubCategoryList(categoryModel!.id, null);
            }
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if(isCategory) {
                    Get.toNamed(RouteHelper.getSubCategoriesRoute(categories![index]));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Row(children: [

                    isCategory ? ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categories![index].image}',
                        height: 55, width: 65, fit: BoxFit.cover,
                      ),
                    ) : const SizedBox(),
                    SizedBox(width: isCategory ? Dimensions.paddingSizeSmall : 0),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(categories![index].name!, style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(
                        '${'id'.tr}: ${categories[index].id}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),
                    ])),

                  ]),
                ),
              );
            },
          ),
        ) : Center(
          child: Text(isCategory ? 'no_category_found'.tr : 'no_subcategory_found'.tr),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
