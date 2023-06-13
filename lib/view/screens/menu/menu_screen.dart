import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/menu_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MenuModel> menuList = [];

    menuList.add(MenuModel(icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()));

    if(Get.find<AuthController>().modulePermission!.item!) {
      menuList.add(MenuModel(
        icon: Images.addFood, title: 'add_item'.tr, route: RouteHelper.getItemRoute(null),
        isBlocked: !Get.find<AuthController>().profileModel!.stores![0].itemSection!,
      ));
    }
    if(Get.find<AuthController>().modulePermission!.item!) {
      menuList.add(MenuModel(icon: Images.categories, title: 'categories'.tr, route: RouteHelper.getCategoriesRoute()));
    }
    if(Get.find<AuthController>().modulePermission!.bankInfo!) {
      menuList.add(MenuModel(icon: Images.creditCard, title: 'bank_info'.tr, route: RouteHelper.getBankInfoRoute()));
    }
    if(Get.find<AuthController>().modulePermission!.campaign!) {
      menuList.add(MenuModel(icon: Images.campaign, title: 'campaign'.tr, route: RouteHelper.getCampaignRoute()));
    }
    if(Get.find<AuthController>().profileModel!.stores![0].selfDeliverySystem == 1 && Get.find<AuthController>().getUserType() == 'owner') {
      menuList.add(MenuModel(icon: Images.deliveryMan, title: 'delivery_man'.tr, route: RouteHelper.getDeliveryManRoute()));
    }
    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.addOn! && Get.find<AuthController>().modulePermission!.addon!) {
      menuList.add(MenuModel(icon: Images.addon, title: 'addons'.tr, route: RouteHelper.getAddonsRoute()));
    }
    if(Get.find<AuthController>().modulePermission!.chat!) {
      menuList.add(MenuModel(icon: Images.chat, title: 'conversation'.tr, route: RouteHelper.getConversationListRoute()));
    }
    menuList.add(MenuModel(icon: Images.language, title: 'language'.tr, route: RouteHelper.getLanguageRoute('menu')));
    menuList.add(MenuModel(icon: Images.coupon, title: 'coupon'.tr, route: RouteHelper.getCouponRoute()));
    menuList.add(MenuModel(icon: Images.expense, title: 'expense_report'.tr, route: RouteHelper.getExpenseRoute()));
    menuList.add(MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, route: RouteHelper.getPrivacyRoute()));
    menuList.add(MenuModel(icon: Images.terms, title: 'terms_condition'.tr, route: RouteHelper.getTermsRoute()));
    menuList.add(MenuModel(icon: Images.logOut, title: 'logout'.tr, route: ''));

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
        color: Theme.of(context).cardColor,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: (1/1.2),
            crossAxisSpacing: Dimensions.paddingSizeExtraSmall, mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
          ),
          itemCount: menuList.length,
          itemBuilder: (context, index) {
            return MenuButton(menu: menuList[index], isProfile: index == 0, isLogout: index == menuList.length-1);
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

      ]),
    );
  }
}
