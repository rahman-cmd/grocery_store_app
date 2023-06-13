class ConfigModel {
  String? businessName;
  String? footerText;
  String? logo;
  String? address;
  String? phone;
  String? email;
  BaseUrls? baseUrls;
  String? country;
  DefaultLocation? defaultLocation;
  String? currencySymbol;
  String? currencySymbolDirection;
  double? appMinimumVersionAndroid;
  String? appUrlAndroid;
  double? appMinimumVersionIos;
  String? appUrlIos;
  bool? customerVerification;
  bool? scheduleOrder;
  bool? orderDeliveryVerification;
  bool? cashOnDelivery;
  bool? digitalPayment;
  double? perKmShippingCharge;
  double? minimumShippingCharge;
  double? freeDeliveryOver;
  bool? demo;
  bool? maintenanceMode;
  String? orderConfirmationModel;
  bool? showDmEarning;
  bool? canceledByDeliveryman;
  String? timeformat;
  List<Language>? language;
  bool? toggleVegNonVeg;
  bool? toggleDmRegistration;
  bool? toggleStoreRegistration;
  int? scheduleOrderSlotDuration;
  int? digitAfterDecimalPoint;
  bool? canceledByStore;
  ModuleConfig? moduleConfig;

  ConfigModel(
      {this.businessName,
        this.footerText,
        this.logo,
        this.address,
        this.phone,
        this.email,
        this.baseUrls,
        this.country,
        this.defaultLocation,
        this.currencySymbol,
        this.currencySymbolDirection,
        this.appMinimumVersionAndroid,
        this.appUrlAndroid,
        this.appMinimumVersionIos,
        this.appUrlIos,
        this.customerVerification,
        this.scheduleOrder,
        this.orderDeliveryVerification,
        this.cashOnDelivery,
        this.digitalPayment,
        this.perKmShippingCharge,
        this.minimumShippingCharge,
        this.freeDeliveryOver,
        this.demo,
        this.maintenanceMode,
        this.orderConfirmationModel,
        this.showDmEarning,
        this.canceledByDeliveryman,
        this.timeformat,
        this.language,
        this.toggleVegNonVeg,
        this.toggleDmRegistration,
        this.toggleStoreRegistration,
        this.scheduleOrderSlotDuration,
        this.digitAfterDecimalPoint,
        this.moduleConfig,
        this.canceledByStore,
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    footerText = json['footer_text'];
    logo = json['logo'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    baseUrls = json['base_urls'] != null
        ? BaseUrls.fromJson(json['base_urls'])
        : null;
    country = json['country'];
    defaultLocation = json['default_location'] != null
        ? DefaultLocation.fromJson(json['default_location'])
        : null;
    currencySymbol = json['currency_symbol'];
    currencySymbolDirection = json['currency_symbol_direction'];
    appMinimumVersionAndroid = json['app_minimum_version_android_store'] != null ? json['app_minimum_version_android_store'].toDouble() : 0.0;
    appUrlAndroid = json['app_url_android_store'];
    appMinimumVersionIos = json['app_minimum_version_ios_store'] != null ? json['app_minimum_version_ios_store'].toDouble() : 0.0;
    appUrlIos = json['app_url_ios_store'];
    customerVerification = json['customer_verification'];
    scheduleOrder = json['schedule_order'];
    orderDeliveryVerification = json['order_delivery_verification'];
    cashOnDelivery = json['cash_on_delivery'];
    digitalPayment = json['digital_payment'];
    perKmShippingCharge = json['per_km_shipping_charge'].toDouble();
    minimumShippingCharge = json['minimum_shipping_charge'].toDouble();
    freeDeliveryOver = json['free_delivery_over']?.toDouble();
    demo = json['demo'];
    maintenanceMode = json['maintenance_mode'];
    orderConfirmationModel = json['order_confirmation_model'];
    showDmEarning = json['show_dm_earning'];
    canceledByDeliveryman = json['canceled_by_deliveryman'];
    timeformat = json['timeformat'];
    if (json['language'] != null) {
      language = <Language>[];
      json['language'].forEach((v) {
        language!.add(Language.fromJson(v));
      });
    }
    toggleVegNonVeg = json['toggle_veg_non_veg'];
    toggleDmRegistration = json['toggle_dm_registration'];
    toggleStoreRegistration = json['toggle_store_registration'];
    scheduleOrderSlotDuration = json['schedule_order_slot_duration'] == 0 ? 30 : json['schedule_order_slot_duration'];
    digitAfterDecimalPoint = json['digit_after_decimal_point'];
    canceledByStore = json['canceled_by_store'];
    moduleConfig = json['module_config'] != null
        ? ModuleConfig.fromJson(json['module_config'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_name'] = businessName;
    data['logo'] = logo;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    if (baseUrls != null) {
      data['base_urls'] = baseUrls!.toJson();
    }
    data['country'] = country;
    if (defaultLocation != null) {
      data['default_location'] = defaultLocation!.toJson();
    }
    data['currency_symbol'] = currencySymbol;
    data['currency_symbol_direction'] = currencySymbolDirection;
    data['app_minimum_version_android'] = appMinimumVersionAndroid;
    data['app_url_android'] = appUrlAndroid;
    data['app_minimum_version_ios'] = appMinimumVersionIos;
    data['app_url_ios'] = appUrlIos;
    data['customer_verification'] = customerVerification;
    data['schedule_order'] = scheduleOrder;
    data['order_delivery_verification'] = orderDeliveryVerification;
    data['cash_on_delivery'] = cashOnDelivery;
    data['digital_payment'] = digitalPayment;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['free_delivery_over'] = freeDeliveryOver;
    data['demo'] = demo;
    data['maintenance_mode'] = maintenanceMode;
    data['order_confirmation_model'] = orderConfirmationModel;
    data['show_dm_earning'] = showDmEarning;
    data['canceled_by_deliveryman'] = canceledByDeliveryman;
    data['timeformat'] = timeformat;
    if (language != null) {
      data['language'] = language!.map((v) => v.toJson()).toList();
    }
    data['toggle_veg_non_veg'] = toggleVegNonVeg;
    data['toggle_dm_registration'] = toggleDmRegistration;
    data['toggle_store_registration'] = toggleStoreRegistration;
    data['schedule_order_slot_duration'] = scheduleOrderSlotDuration;
    data['digit_after_decimal_point'] = digitAfterDecimalPoint;
    data['canceled_by_store'] = canceledByStore;
    if (moduleConfig != null) {
      data['module_config'] = moduleConfig!.toJson();
    }
    return data;
  }
}

class BaseUrls {
  String? itemImageUrl;
  String? customerImageUrl;
  String? bannerImageUrl;
  String? categoryImageUrl;
  String? reviewImageUrl;
  String? notificationImageUrl;
  String? vendorImageUrl;
  String? storeImageUrl;
  String? storeCoverPhotoUrl;
  String? deliveryManImageUrl;
  String? chatImageUrl;
  String? campaignImageUrl;
  String? moduleImageUrl;
  String? orderAttachmentUrl;

  BaseUrls(
      {this.itemImageUrl,
        this.customerImageUrl,
        this.bannerImageUrl,
        this.categoryImageUrl,
        this.reviewImageUrl,
        this.notificationImageUrl,
        this.vendorImageUrl,
        this.storeImageUrl,
        this.storeCoverPhotoUrl,
        this.deliveryManImageUrl,
        this.chatImageUrl,
        this.campaignImageUrl,
        this.moduleImageUrl,
        this.orderAttachmentUrl,
      });

  BaseUrls.fromJson(Map<String, dynamic> json) {
    itemImageUrl = json['item_image_url'];
    customerImageUrl = json['customer_image_url'];
    bannerImageUrl = json['banner_image_url'];
    categoryImageUrl = json['category_image_url'];
    reviewImageUrl = json['review_image_url'];
    notificationImageUrl = json['notification_image_url'];
    vendorImageUrl = json['vendor_image_url'];
    storeImageUrl = json['store_image_url'];
    storeCoverPhotoUrl = json['store_cover_photo_url'];
    deliveryManImageUrl = json['delivery_man_image_url'];
    chatImageUrl = json['chat_image_url'];
    campaignImageUrl = json['campaign_image_url'];
    moduleImageUrl = json['module_image_url'];
    orderAttachmentUrl = json['order_attachment_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_image_url'] = itemImageUrl;
    data['customer_image_url'] = customerImageUrl;
    data['banner_image_url'] = bannerImageUrl;
    data['category_image_url'] = categoryImageUrl;
    data['review_image_url'] = reviewImageUrl;
    data['notification_image_url'] = notificationImageUrl;
    data['vendor_image_url'] = vendorImageUrl;
    data['store_image_url'] = storeImageUrl;
    data['store_cover_photo_url'] = storeCoverPhotoUrl;
    data['delivery_man_image_url'] = deliveryManImageUrl;
    data['chat_image_url'] = chatImageUrl;
    data['campaign_image_url'] = campaignImageUrl;
    data['module_image_url'] = moduleImageUrl;
    data['order_attachment_url'] = orderAttachmentUrl;
    return data;
  }
}

class DefaultLocation {
  String? lat;
  String? lng;

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Language {
  String? key;
  String? value;

  Language({this.key, this.value});

  Language.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}

class ModuleConfig {
  List<String>? moduleType;
  Module? module;

  ModuleConfig({this.moduleType, this.module});

  ModuleConfig.fromJson(Map<String, dynamic> json) {
    moduleType = json['module_type'].cast<String>();
    module = json[moduleType![0]] != null ? Module.fromJson(json[moduleType![0]]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_type'] = moduleType;
    if (module != null) {
      data[moduleType![0]] = module!.toJson();
    }
    return data;
  }
}

class Module {
  OrderStatus? orderStatus;
  bool? orderPlaceToScheduleInterval;
  bool? addOn;
  bool? stock;
  bool? vegNonVeg;
  bool? unit;
  bool? orderAttachment;
  bool? alwaysOpen;
  bool? itemAvailableTime;
  bool? showRestaurantText;
  bool? isParcel;
  bool? newVariation;
  String? description;

  Module(
      {this.orderStatus,
        this.orderPlaceToScheduleInterval,
        this.addOn,
        this.stock,
        this.vegNonVeg,
        this.unit,
        this.orderAttachment,
        this.alwaysOpen,
        this.itemAvailableTime,
        this.showRestaurantText,
        this.isParcel,
        this.newVariation,
        this.description,
      });

  Module.fromJson(Map<String, dynamic> json) {
    orderStatus = json['order_status'] != null ? OrderStatus.fromJson(json['order_status']) : null;
    orderPlaceToScheduleInterval = json['order_place_to_schedule_interval'];
    addOn = json['add_on'];
    stock = json['stock'];
    vegNonVeg = json['veg_non_veg'];
    unit = json['unit'];
    orderAttachment = json['order_attachment'];
    alwaysOpen = json['always_open'];
    itemAvailableTime = json['item_available_time'];
    showRestaurantText = json['show_restaurant_text'];
    isParcel = json['is_parcel'];
    newVariation = json['new_variation'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderStatus != null) {
      data['order_status'] = orderStatus!.toJson();
    }
    data['order_place_to_schedule_interval'] = orderPlaceToScheduleInterval;
    data['add_on'] = addOn;
    data['stock'] = stock;
    data['veg_non_veg'] = vegNonVeg;
    data['unit'] = unit;
    data['order_attachment'] = orderAttachment;
    data['always_open'] = alwaysOpen;
    data['item_available_time'] = itemAvailableTime;
    data['show_restaurant_text'] = showRestaurantText;
    data['is_parcel'] = isParcel;
    data['new_variation'] = newVariation;
    data['description'] = description;
    return data;
  }
}

class OrderStatus {
  bool? accepted;

  OrderStatus({this.accepted});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    accepted = json['accepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accepted'] = accepted;
    return data;
  }
}