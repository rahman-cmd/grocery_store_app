import 'package:sixam_mart_store/data/model/response/language_model.dart';
import 'package:sixam_mart_store/util/images.dart';

class AppConstants {
  static const String appName = 'Aziz Shop';
  static const double appVersion = 2.6;

  static const String baseUrl = 'https://azizfood.com';
  static const String configUri = '/api/v1/config';
  static const String loginUri = '/api/v1/auth/vendor/login';
  static const String forgetPasswordUri = '/api/v1/auth/vendor/forgot-password';
  static const String verifyTokenUri = '/api/v1/auth/vendor/verify-token';
  static const String resetPasswordUri = '/api/v1/auth/vendor/reset-password';
  static const String tokenUri = '/api/v1/vendor/update-fcm-token';
  static const String allOrdersUri = '/api/v1/vendor/all-orders';
  static const String currentOrdersUri = '/api/v1/vendor/current-orders';
  static const String completedOrdersUri = '/api/v1/vendor/completed-orders';
  static const String orderDetailsUri =
      '/api/v1/vendor/order-details?order_id=';
  static const String updatedOrderStatusUri =
      '/api/v1/vendor/update-order-status';
  static const String notificationUri = '/api/v1/vendor/notifications';
  static const String profileUri = '/api/v1/vendor/profile';
  static const String updateProfileUri = '/api/v1/vendor/update-profile';
  static const String basicCampaignUri = '/api/v1/vendor/get-basic-campaigns';
  static const String joinCampaignUri = '/api/v1/vendor/campaign-join';
  static const String leaveCampaignUri = '/api/v1/vendor/campaign-leave';
  static const String withdrawListUri = '/api/v1/vendor/get-withdraw-list';
  static const String itemListUri = '/api/v1/vendor/get-items-list';
  static const String updateBankInfoUri = '/api/v1/vendor/update-bank-info';
  static const String withdrawRequestUri = '/api/v1/vendor/request-withdraw';
  static const String categoryUri = '/api/v1/vendor/categories';
  static const String subCategoryUri = '/api/v1/vendor/categories/childes/';
  static const String addonUri = '/api/v1/vendor/addon';
  static const String addAddonUri = '/api/v1/vendor/addon/store';
  static const String updateAddonUri = '/api/v1/vendor/addon/update';
  static const String deleteAddonUri = '/api/v1/vendor/addon/delete';
  static const String attributeUri = '/api/v1/vendor/attributes';
  static const String vendorUpdateUri = '/api/v1/vendor/update-business-setup';
  static const String addItemUri = '/api/v1/vendor/item/store';
  static const String updateItemUri = '/api/v1/vendor/item/update';
  static const String deleteItemUri = '/api/v1/vendor/item/delete';
  static const String vendorReviewUri = '/api/v1/vendor/item/reviews';
  static const String itemReviewUri = '/api/v1/items/reviews';
  static const String updateItemStatusUri = '/api/v1/vendor/item/status';
  static const String updateVendorStatusUri =
      '/api/v1/vendor/update-active-status';
  static const String searchItemListUri = '/api/v1/vendor/item/search';
  static const String placeOrderUri = '/api/v1/vendor/pos/place-order';
  static const String posOrderUri = '/api/v1/vendor/pos/orders';
  static const String searchCustomersUri = '/api/v1/vendor/pos/customers';
  static const String dmListUri = '/api/v1/vendor/delivery-man/list';
  static const String addDmUri = '/api/v1/vendor/delivery-man/store';
  static const String updateDmUri = '/api/v1/vendor/delivery-man/update/';
  static const String deleteDmUri = '/api/v1/vendor/delivery-man/delete';
  static const String updateDmStatusUri = '/api/v1/vendor/delivery-man/status';
  static const String dmReviewUri = '/api/v1/vendor/delivery-man/preview';
  static const String addSchedule = '/api/v1/vendor/schedule/store';
  static const String deleteSchedule = '/api/v1/vendor/schedule/';
  static const String unitListUri = '/api/v1/vendor/unit';
  static const String aboutUsUri = '/about-us';
  static const String privacyPolicyUri = '/privacy-policy';
  static const String termsAndConditionsUri = '/terms-and-conditions';
  static const String vendorRemoveUri = '/api/v1/vendor/remove-account';
  static const String zoneListUri = '/api/v1/zone/list';
  static const String searchLocationUri =
      '/api/v1/config/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/config/place-api-details';
  static const String zoneUri = '/api/v1/config/get-zone-id';
  static const String restaurantRegisterUri = '/api/v1/auth/vendor/register';
  static const String currentOrderDetailsUri = '/api/v1/vendor/order?order_id=';
  static const String modulesUri = '/api/v1/module';
  static const String updateOrderUri = '/api/v1/vendor/update-order-amount';
  static const String orderCancellationUri =
      '/api/v1/customer/order/cancellation-reasons';
  static const String addCouponUri = '/api/v1/vendor/coupon/store';
  static const String couponListUri = '/api/v1/vendor/coupon/list';
  static const String couponChangeStatusUri = '/api/v1/vendor/coupon/status';
  static const String couponDeleteUri = '/api/v1/vendor/coupon/delete';
  static const String couponUpdateUri = '/api/v1/vendor/coupon/update';
  static const String expenseListUri = '/api/v1/vendor/get-expense';
  static const String updateProductRecommendedUri =
      '/api/v1/vendor/item/recommended';

  //chat url
  static const String getConversationListUri = '/api/v1/vendor/message/list';
  static const String getMessageListUri = '/api/v1/vendor/message/details';
  static const String sendMessageUri = '/api/v1/vendor/message/send';
  static const String searchConversationListUri =
      '/api/v1/vendor/message/search-list';

  // Shared Key
  static const String theme = '6am_mart_store_theme';
  static const String intro = '6am_mart_store_intro';
  static const String token = '6am_mart_store_token';
  static const String type = '6am_mart_store_type';
  static const String countryCode = '6am_mart_store_country_code';
  static const String languageCode = '6am_mart_store_language_code';
  static const String cartList = '6am_mart_store_cart_list';
  static const String userPassword = '6am_mart_store_user_password';
  static const String userAddress = '6am_mart_store_user_address';
  static const String userNumber = '6am_mart_store_user_number';
  static const String userType = '6am_mart_store_user_type';
  static const String notification = '6am_mart_store_notification';
  static const String notificationCount = '6am_mart_store_notification_count';
  static const String searchHistory = '6am_mart_store_search_history';

  static const String topic = 'all_zone_store';
  static const String zoneTopic = 'zone_topic';
  static const String moduleId = 'moduleId';
  static const String localizationKey = 'X-localization';

  /// order Status..
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String accepted = 'accepted';
  static const String processing = 'processing';
  static const String handover = 'handover';
  static const String pickedUp = 'picked_up';
  static const String delivered = 'delivered';
  static const String canceled = 'canceled';
  static const String failed = 'failed';
  static const String refunded = 'refunded';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.english,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.arabic,
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: Images.arabic,
        languageName: 'Spanish',
        countryCode: 'ES',
        languageCode: 'es'),
  ];
}
