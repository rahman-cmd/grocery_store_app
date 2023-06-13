import 'dart:convert';

import 'package:sixam_mart_store/data/model/body/notification_body.dart';
import 'package:sixam_mart_store/data/model/response/campaign_model.dart';
import 'package:sixam_mart_store/data/model/response/category_model.dart';
import 'package:sixam_mart_store/data/model/response/conversation_model.dart';
import 'package:sixam_mart_store/data/model/response/delivery_man_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart';
import 'package:sixam_mart_store/view/screens/addon/addon_screen.dart';
import 'package:sixam_mart_store/view/screens/auth/sign_in_screen.dart';
import 'package:sixam_mart_store/view/screens/auth/store_registration_screen.dart';
import 'package:sixam_mart_store/view/screens/bank/bank_info_screen.dart';
import 'package:sixam_mart_store/view/screens/bank/wallet_screen.dart';
import 'package:sixam_mart_store/view/screens/bank/withdraw_history_screen.dart';
import 'package:sixam_mart_store/view/screens/campaign/campaign_details_screen.dart';
import 'package:sixam_mart_store/view/screens/campaign/campaign_screen.dart';
import 'package:sixam_mart_store/view/screens/category/category_screen.dart';
import 'package:sixam_mart_store/view/screens/chat/chat_screen.dart';
import 'package:sixam_mart_store/view/screens/chat/conversation_screen.dart';
import 'package:sixam_mart_store/view/screens/coupon/coupon_screen.dart';
import 'package:sixam_mart_store/view/screens/dashboard/dashboard_screen.dart';
import 'package:sixam_mart_store/view/screens/deliveryman/add_delivery_man_screen.dart';
import 'package:sixam_mart_store/view/screens/deliveryman/delivery_man_details_screen.dart';
import 'package:sixam_mart_store/view/screens/deliveryman/delivery_man_screen.dart';
import 'package:sixam_mart_store/view/screens/expence/expense_screen.dart';
import 'package:sixam_mart_store/view/screens/forget/forget_pass_screen.dart';
import 'package:sixam_mart_store/view/screens/forget/new_pass_screen.dart';
import 'package:sixam_mart_store/view/screens/forget/verification_screen.dart';
import 'package:sixam_mart_store/view/screens/html/html_viewer_screen.dart';
import 'package:sixam_mart_store/view/screens/language/language_screen.dart';
import 'package:sixam_mart_store/view/screens/notification/notification_screen.dart';
import 'package:sixam_mart_store/view/screens/order/order_details_screen.dart';
import 'package:sixam_mart_store/view/screens/pos/pos_screen.dart';
import 'package:sixam_mart_store/view/screens/profile/profile_screen.dart';
import 'package:sixam_mart_store/view/screens/profile/update_profile_screen.dart';
import 'package:sixam_mart_store/view/screens/store/add_name_screen.dart';
import 'package:sixam_mart_store/view/screens/store/add_item_screen.dart';
import 'package:sixam_mart_store/view/screens/store/image_viewer_screen.dart';
import 'package:sixam_mart_store/view/screens/store/item_details_screen.dart';
import 'package:sixam_mart_store/view/screens/store/store_screen.dart';
import 'package:sixam_mart_store/view/screens/store/store_settings_screen.dart';
import 'package:sixam_mart_store/view/screens/splash/splash_screen.dart';
import 'package:sixam_mart_store/view/screens/update/update_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String signIn = '/sign-in';
  static const String verification = '/verification';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String notification = '/notification';
  static const String bankInfo = '/bank-info';
  static const String wallet = '/wallet';
  static const String withdrawHistory = '/withdraw-history';
  static const String store = '/store';
  static const String campaign = '/campaign';
  static const String campaignDetails = '/campaign-details';
  static const String item = '/item';
  static const String addItem = '/add-item';
  static const String categories = '/categories';
  static const String subCategories = '/sub-categories';
  static const String storeSettings = '/store-settings';
  static const String addons = '/addons';
  static const String itemDetails = '/item-details';
  static const String pos = '/pos';
  static const String deliveryMan = '/delivery-man';
  static const String addDeliveryMan = '/add-delivery-man';
  static const String deliveryManDetails = '/delivery-man-details';
  static const String terms = '/terms-and-condition';
  static const String privacy = '/privacy-policy';
  static const String update = '/update';
  static String itemImages = '/item-images';
  static const String chatScreen = '/chat-screen';
  static const String conversationListScreen = '/chat-list-screen';
  static const String restaurantRegistration = '/restaurant-registration';
  static const String coupon = '/coupon';
  static const String expense = '/expense';

  static String getInitialRoute() => initial;
  static String getSplashRoute(NotificationBody? body) {
    String data = 'null';
    if(body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body.toJson()));
      data = base64Encode(encoded);
    }
    return '$splash?data=$data';
  }
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getSignInRoute() => signIn;
  static String getVerificationRoute(String email) => '$verification?email=$email';
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute() => forgotPassword;
  static String getResetPasswordRoute(String? phone, String token, String page) => '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getOrderDetailsRoute(int? orderID, {bool? fromNotification}) => '$orderDetails?id=$orderID&from=${fromNotification.toString()}';
  static String getProfileRoute() => profile;
  static String getUpdateProfileRoute() => updateProfile;
  static String getNotificationRoute({bool? fromNotification}) => '$notification?from=${fromNotification.toString()}';
  static String getBankInfoRoute() => bankInfo;
  static String getWalletRoute() => wallet;
  static String getWithdrawHistoryRoute() => withdrawHistory;
  static String getStoreRoute() => store;
  static String getCampaignRoute() => campaign;
  static String getCampaignDetailsRoute(int? id) => '$campaignDetails?id=$id';
  static String getUpdateRoute(bool isUpdate) => '$update?update=${isUpdate.toString()}';
  static String getItemRoute(Item? itemModel) {
    if(itemModel == null) {
      return '$item?data=null';
    }
    List<int> encoded = utf8.encode(jsonEncode(itemModel.toJson()));
    String data = base64Encode(encoded);
    return '$item?data=$data';
  }
  static String getAddItemRoute(Item? itemModel, List<Translation> translations) {
    String translations0 = base64Encode(utf8.encode(jsonEncode(translations)));
    if(itemModel == null) {
      return '$addItem?data=null&translations=$translations0';
    }
    String data = base64Encode(utf8.encode(jsonEncode(itemModel.toJson())));
    return '$addItem?data=$data&translations=$translations0';
  }
  static String getCategoriesRoute() => categories;
  static String getSubCategoriesRoute(CategoryModel categoryModel) {
    List<int> encoded = utf8.encode(jsonEncode(categoryModel.toJson()));
    String data = base64Encode(encoded);
    return '$subCategories?data=$data';
  }
  static String getStoreSettingsRoute(Store store) {
    List<int> encoded = utf8.encode(jsonEncode(store.toJson()));
    String data = base64Encode(encoded);
    return '$storeSettings?data=$data';
  }
  static String getAddonsRoute() => addons;
  static String getItemDetailsRoute(Item itemModel) {
    List<int> encoded = utf8.encode(jsonEncode(itemModel.toJson()));
    String data = base64Encode(encoded);
    return '$itemDetails?data=$data';
  }
  static String getPosRoute() => pos;
  static String getDeliveryManRoute() => deliveryMan;
  static String getAddDeliveryManRoute(DeliveryManModel? deliveryMan) {
    if(deliveryMan == null) {
      return '$addDeliveryMan?data=null';
    }
    List<int> encoded = utf8.encode(jsonEncode(deliveryMan.toJson()));
    String data = base64Encode(encoded);
    return '$addDeliveryMan?data=$data';
  }
  static String getDeliveryManDetailsRoute(DeliveryManModel deliveryMan) {
    List<int> encoded = utf8.encode(jsonEncode(deliveryMan.toJson()));
    String data = base64Encode(encoded);
    return '$deliveryManDetails?data=$data';
  }
  static String getTermsRoute() => terms;
  static String getPrivacyRoute() => privacy;
  static String getItemImagesRoute(Item item) {
    String data = base64Url.encode(utf8.encode(jsonEncode(item.toJson())));
    return '$itemImages?item=$data';
  }
  static String getChatRoute({required NotificationBody? notificationBody, User? user, int? conversationId, bool? fromNotification}) {
    String notificationBody0 = 'null';
    String user0 = 'null';

    if(notificationBody != null) {
      notificationBody0 = base64Encode(utf8.encode(jsonEncode(notificationBody)));
    }
    if(user != null) {
      user0 = base64Encode(utf8.encode(jsonEncode(user.toJson())));
    }
    return '$chatScreen?notification_body=$notificationBody0&user=$user0&conversation_id=$conversationId&from=${fromNotification.toString()}';
  }
  static String getConversationListRoute() => conversationListScreen;
  static String getRestaurantRegistrationRoute() => restaurantRegistration;
  static String getCouponRoute() => coupon;
  static String getExpenseRoute() => expense;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const DashboardScreen(pageIndex: 0)),
    GetPage(name: splash, page: () {
      NotificationBody? data;
      if(Get.parameters['data'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
        data = NotificationBody.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return SplashScreen(body: data);
    }),
    GetPage(name: language, page: () => LanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: signIn, page: () => const SignInScreen()),
    GetPage(name: verification, page: () => VerificationScreen(email: Get.parameters['email'])),
    GetPage(name: main, page: () => DashboardScreen(
      pageIndex: Get.parameters['page'] == 'home' ? 0 : Get.parameters['page'] == 'favourite' ? 1
          : Get.parameters['page'] == 'cart' ? 2 : Get.parameters['page'] == 'order' ? 3 : Get.parameters['page'] == 'menu' ? 4 : 0,
    )),
    GetPage(name: forgotPassword, page: () => const ForgetPassScreen()),
    GetPage(name: resetPassword, page: () => NewPassScreen(
      resetToken: Get.parameters['token'], email: Get.parameters['phone'], fromPasswordChange: Get.parameters['page'] == 'password-change',
    )),
    GetPage(name: orderDetails, page: () {
      return Get.arguments ?? OrderDetailsScreen(
        orderId: int.parse(Get.parameters['id']!), isRunningOrder: false, fromNotification: Get.parameters['from'] == 'true',
      );
    }),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: updateProfile, page: () => UpdateProfileScreen()),
    GetPage(name: notification, page: () => NotificationScreen(fromNotification: Get.parameters['from'] == 'true')),
    GetPage(name: bankInfo, page: () => const BankInfoScreen()),
    GetPage(name: wallet, page: () => const WalletScreen()),
    GetPage(name: withdrawHistory, page: () => const WithdrawHistoryScreen()),
    GetPage(name: store, page: () => const StoreScreen()),
    GetPage(name: campaign, page: () => const CampaignScreen()),
    GetPage(name: campaignDetails, page: () {
      return Get.arguments ?? CampaignDetailsScreen(
        campaignModel: CampaignModel(id: int.parse(Get.parameters['id']!)),
      );
    }),
    GetPage(name: item, page: () {
      if(Get.parameters['data'] == 'null') {
        return const AddNameScreen(item: null);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Item data = Item.fromJson(jsonDecode(utf8.decode(decode)));
      return AddNameScreen(item: data);
    }),
    GetPage(name: addItem, page: () {
      List<Translation> translations = [];
      jsonDecode(utf8.decode(base64Decode(Get.parameters['translations']!.replaceAll(' ', '+')))).forEach((data) {
        translations.add(Translation.fromJson(data));
      });
      if(Get.parameters['data'] == 'null') {
        return AddItemScreen(item: null, translations: translations);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Item data = Item.fromJson(jsonDecode(utf8.decode(decode)));
      return AddItemScreen(item: data, translations: translations);
    }),
    GetPage(name: categories, page: () => const CategoryScreen(categoryModel: null)),
    GetPage(name: subCategories, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      CategoryModel data = CategoryModel.fromJson(jsonDecode(utf8.decode(decode)));
      return CategoryScreen(categoryModel: data);
    }),
    GetPage(name: storeSettings, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Store data = Store.fromJson(jsonDecode(utf8.decode(decode)));
      return StoreSettingsScreen(store: data);
    }),
    GetPage(name: addons, page: () => const AddonScreen()),
    GetPage(name: itemDetails, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Item data = Item.fromJson(jsonDecode(utf8.decode(decode)));
      return ItemDetailsScreen(item: data);
    }),
    GetPage(name: pos, page: () => const PosScreen()),
    GetPage(name: deliveryMan, page: () => const DeliveryManScreen()),
    GetPage(name: addDeliveryMan, page: () {
      if(Get.parameters['data'] == 'null') {
        return const AddDeliveryManScreen(deliveryMan: null);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      DeliveryManModel data = DeliveryManModel.fromJson(jsonDecode(utf8.decode(decode)));
      return AddDeliveryManScreen(deliveryMan: data);
    }),
    GetPage(name: deliveryManDetails, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      DeliveryManModel data = DeliveryManModel.fromJson(jsonDecode(utf8.decode(decode)));
      return DeliveryManDetailsScreen(deliveryMan: data);
    }),
    GetPage(name: terms, page: () => const HtmlViewerScreen(isPrivacyPolicy: false)),
    GetPage(name: privacy, page: () => const HtmlViewerScreen(isPrivacyPolicy: true)),
    GetPage(name: update, page: () => UpdateScreen(isUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: itemImages, page: () => ImageViewerScreen(
      item: Item.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['item']!.replaceAll(' ', '+'))))),
    )),
    GetPage(name: chatScreen, page: () {
      NotificationBody? notificationBody;
      if(Get.parameters['notification_body'] != 'null') {
        notificationBody = NotificationBody.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['notification_body']!.replaceAll(' ', '+')))));
      }
      User? user;
      if(Get.parameters['user'] != 'null') {
        user = User.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['user']!.replaceAll(' ', '+')))));
      }
      return ChatScreen(
        notificationBody : notificationBody, user: user, fromNotification: Get.parameters['from'] == 'true',
        conversationId: Get.parameters['conversation_id'] != null && Get.parameters['conversation_id'] != 'null' ? int.parse(Get.parameters['conversation_id']!) : null,
      );
    }),
    GetPage(name: conversationListScreen, page: () => const ConversationScreen()),
    GetPage(name: restaurantRegistration, page: () => const StoreRegistrationScreen()),
    GetPage(name: coupon, page: () => const CouponScreen()),
    GetPage(name: expense, page: () => const ExpenseScreen()),
  ];
}