import 'dart:io';

import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart' as profile;
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_drop_down.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:sixam_mart_store/view/base/switch_button.dart';
import 'package:sixam_mart_store/view/screens/store/widget/daily_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreSettingsScreen extends StatefulWidget {
  final profile.Store store;
  const StoreSettingsScreen({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _orderAmountController = TextEditingController();
  final TextEditingController _minimumDeliveryFeeController = TextEditingController();
  final TextEditingController _maximumDeliveryFeeController = TextEditingController();
  final TextEditingController _processingTimeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _minimumController = TextEditingController();
  final TextEditingController _maximumController = TextEditingController();
  final TextEditingController _deliveryChargePerKmController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _contactNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _orderAmountNode = FocusNode();
  final FocusNode _minimumDeliveryFeeNode = FocusNode();
  final FocusNode _maximumDeliveryFeeNode = FocusNode();
  final FocusNode _minimumNode = FocusNode();
  final FocusNode _maximumNode = FocusNode();
  final FocusNode _minimumProcessingTimeNode = FocusNode();
  final FocusNode _deliveryChargePerKmNode = FocusNode();
  late profile.Store _store;
  final Module? _module = Get.find<SplashController>().configModel!.moduleConfig!.module;

  @override
  void initState() {
    super.initState();

    Get.find<StoreController>().initStoreData(widget.store);

    _nameController.text = widget.store.name!;
    _contactController.text = widget.store.phone!;
    _addressController.text = widget.store.address!;
    _orderAmountController.text = widget.store.minimumOrder.toString();
    _minimumDeliveryFeeController.text = widget.store.minimumShippingCharge.toString();
    _maximumDeliveryFeeController.text = widget.store.maximumShippingCharge != null ? widget.store.maximumShippingCharge.toString() : '';
    _deliveryChargePerKmController.text = widget.store.perKmShippingCharge.toString();
    _gstController.text = widget.store.gstCode!;
    _processingTimeController.text = widget.store.orderPlaceToScheduleInterval.toString();
    if(widget.store.deliveryTime != null && widget.store.deliveryTime!.isNotEmpty) {
      try {
        List<String> typeList = widget.store.deliveryTime!.split(' ');
        List<String> timeList = typeList[0].split('-');
        _minimumController.text = timeList[0];
        _maximumController.text = timeList[1];
        Get.find<StoreController>().setDurationType(Get.find<StoreController>().durations.indexOf(typeList[1]) + 1, false);
      }catch(_) {}
    }
    _store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _module!.showRestaurantText! ? 'restaurant_settings'.tr : 'store_settings'.tr),
      body: GetBuilder<StoreController>(builder: (storeController) {
        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            physics: const BouncingScrollPhysics(),
            child: Column(children: [

              Row(children: [
                Text(
                  'logo'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  '(${'max_size_2_mb'.tr})',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Align(alignment: Alignment.center, child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: storeController.rawLogo != null ? GetPlatform.isWeb ? Image.network(
                    storeController.rawLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                  ) : Image.file(
                    File(storeController.rawLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                  ) : FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${widget.store.logo}',
                    height: 120, width: 150, fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, width: 150, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0, right: 0, top: 0, left: 0,
                  child: InkWell(
                    onTap: () => storeController.pickImage(true, false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ])),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              MyTextField(
                hintText: _module!.showRestaurantText! ? 'restaurant_name'.tr : 'store_name'.tr,
                controller: _nameController,
                focusNode: _nameNode,
                nextFocus: _contactNode,
                capitalization: TextCapitalization.words,
                inputType: TextInputType.name,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              MyTextField(
                hintText: 'contact_number'.tr,
                controller: _contactController,
                focusNode: _contactNode,
                nextFocus: _addressNode,
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              MyTextField(
                hintText: 'address'.tr,
                controller: _addressController,
                focusNode: _addressNode,
                nextFocus: _orderAmountNode,
                inputType: TextInputType.streetAddress,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Expanded(child: MyTextField(
                  hintText: 'minimum_order_amount'.tr,
                  controller: _orderAmountController,
                  focusNode: _orderAmountNode,
                  nextFocus: _store.selfDeliverySystem == 1 ? _deliveryChargePerKmNode : _minimumNode,
                  inputType: TextInputType.number,
                  isAmount: true,
                )),
                SizedBox(width: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeSmall : 0),
                _store.selfDeliverySystem == 1 ? Expanded(child: MyTextField(
                  hintText: 'delivery_charge_per_km'.tr,
                  controller: _deliveryChargePerKmController,
                  focusNode: _deliveryChargePerKmNode,
                  nextFocus: _minimumDeliveryFeeNode,
                  inputType: TextInputType.number,
                  isAmount: true,
                )) : const SizedBox(),
              ]),
              SizedBox(height: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeLarge : 0),

              _store.selfDeliverySystem == 1 ? Row(children: [
                  Expanded(
                    child: MyTextField(
                      hintText: 'minimum_delivery_charge'.tr,
                      controller: _minimumDeliveryFeeController,
                      focusNode: _minimumDeliveryFeeNode,
                      nextFocus: _maximumDeliveryFeeNode,
                      inputType: TextInputType.number,
                      isAmount: true,
                    ),
                  ),

                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                      child: MyTextField(
                      hintText: 'maximum_delivery_charge'.tr,
                      controller: _maximumDeliveryFeeController,
                      focusNode: _maximumDeliveryFeeNode,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.number,
                      nextFocus: _minimumNode,
                      isAmount: true,
                    ),
                  ),
                ],
              ) : const SizedBox(),
              SizedBox(height: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeLarge : 0),

              Align(alignment: Alignment.centerLeft, child: Text(
                'approximate_delivery_time'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              )),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(children: [
                Expanded(child: MyTextField(
                  hintText: 'minimum'.tr,
                  controller: _minimumController,
                  focusNode: _minimumNode,
                  nextFocus: _maximumNode,
                  inputType: TextInputType.number,
                  isNumber: true,
                  title: false,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: MyTextField(
                  hintText: 'maximum'.tr,
                  controller: _maximumController,
                  focusNode: _maximumNode,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.number,
                  isNumber: true,
                  title: false,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: CustomDropDown(
                  value: storeController.durationIndex.toString(), title: null,
                  dataList: storeController.durations, onChanged: (String value) {
                    storeController.setDurationType(int.parse(value), true);
                  },
                )),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              _module!.orderPlaceToScheduleInterval! ? MyTextField(
                hintText: 'minimum_processing_time'.tr,
                controller: _processingTimeController,
                focusNode: _minimumProcessingTimeNode,
                nextFocus: _deliveryChargePerKmNode,
                inputType: TextInputType.number,
                isAmount: true,
              ) : const SizedBox(),
              SizedBox(height: _module!.orderPlaceToScheduleInterval! ? Dimensions.paddingSizeLarge : 0),

              (_module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Align(alignment: Alignment.centerLeft, child: Text(
                'item_type'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              )) : const SizedBox(),
              (_module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Row(children: [
                Expanded(child: InkWell(
                  onTap: () => storeController.setStoreVeg(!storeController.isStoreVeg!, true),
                  child: Row(children: [
                    Checkbox(
                      value: storeController.isStoreVeg,
                      onChanged: (bool? isActive) => storeController.setStoreVeg(isActive, true),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    Text('veg'.tr),
                  ]),
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: InkWell(
                  onTap: () => storeController.setStoreNonVeg(!storeController.isStoreNonVeg!, true),
                  child: Row(children: [
                    Checkbox(
                      value: storeController.isStoreNonVeg,
                      onChanged: (bool? isActive) => storeController.setStoreNonVeg(isActive, true),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    Text('non_veg'.tr),
                  ]),
                )),
              ]) : const SizedBox(),
              SizedBox(height: (_module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                  ? Dimensions.paddingSizeLarge : 0),

              Row(children: [
                Expanded(child: Text(
                  'gst'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                )),
                Switch(
                  value: storeController.isGstEnabled!,
                  activeColor: Theme.of(context).primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (bool isActive) => storeController.toggleGst(),
                ),
              ]),
              MyTextField(
                hintText: 'gst'.tr,
                controller: _gstController,
                inputAction: TextInputAction.done,
                title: false,
                isEnabled: storeController.isGstEnabled,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              _module!.alwaysOpen! ? const SizedBox() : Align(alignment: Alignment.centerLeft, child: Text(
                'daily_schedule_time'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              )),
              SizedBox(height: _module!.alwaysOpen! ? 0 : Dimensions.paddingSizeExtraSmall),
              _module!.alwaysOpen! ? const SizedBox() : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return DailyTimeWidget(weekDay: index);
                },
              ),
              SizedBox(height: _module!.alwaysOpen! ? 0 : Dimensions.paddingSizeLarge),

              Get.find<SplashController>().configModel!.scheduleOrder! ? SwitchButton(
                icon: Icons.alarm_add, title: 'schedule_order'.tr, isButtonActive: widget.store.scheduleOrder, onTap: () {
                  _store.scheduleOrder = !_store.scheduleOrder!;
                },
              ) : const SizedBox(),
              SizedBox(height: Get.find<SplashController>().configModel!.scheduleOrder! ? Dimensions.paddingSizeSmall : 0),

              SwitchButton(icon: Icons.delivery_dining, title: 'delivery'.tr, isButtonActive: widget.store.delivery, onTap: () {
                _store.delivery = !_store.delivery!;
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SwitchButton(icon: Icons.house_siding, title: 'take_away'.tr, isButtonActive: widget.store.takeAway, onTap: () {
                _store.takeAway = !_store.takeAway!;
              }),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: storeController.rawCover != null ? GetPlatform.isWeb ? Image.network(
                    storeController.rawCover!.path, width: context.width, height: 170, fit: BoxFit.cover,
                  ) : Image.file(
                    File(storeController.rawCover!.path), width: context.width, height: 170, fit: BoxFit.cover,
                  ) : FadeInImage.assetNetwork(
                    placeholder: Images.restaurantCover,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.storeCoverPhotoUrl}/${widget.store.coverPhoto}',
                    height: 170, width: context.width, fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 170, width: context.width, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0, right: 0, top: 0, left: 0,
                  child: InkWell(
                    onTap: () => storeController.pickImage(false, false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                ),
              ]),

            ]),
          )),

          !storeController.isLoading ? CustomButton(
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            onPressed: () {
              String name = _nameController.text.trim();
              String contact = _contactController.text.trim();
              String address = _addressController.text.trim();
              String minimumOrder = _orderAmountController.text.trim();
              String deliveryFee = _minimumDeliveryFeeController.text.trim();
              String minimum = _minimumController.text.trim();
              String maximum = _maximumController.text.trim();
              String processingTime = _processingTimeController.text.trim();
              String deliveryChargePerKm = _deliveryChargePerKmController.text.trim();
              String gstCode = _gstController.text.trim();
              String maximumFee = _maximumDeliveryFeeController.text.trim();
              bool? showRestaurantText = _module!.showRestaurantText;
              if(name.isEmpty) {
                showCustomSnackBar(showRestaurantText! ? 'enter_your_restaurant_name'.tr : 'enter_your_store_name');
              }else if(contact.isEmpty) {
                showCustomSnackBar(showRestaurantText! ? 'enter_restaurant_contact_number'.tr : 'enter_store_contact_number'.tr);
              }else if(address.isEmpty) {
                showCustomSnackBar(showRestaurantText! ? 'enter_restaurant_address'.tr : 'enter_store_address'.tr);
              }else if(minimumOrder.isEmpty) {
                showCustomSnackBar('enter_minimum_order_amount'.tr);
              }else if(_store.selfDeliverySystem == 1 && deliveryFee.isEmpty && maximumFee.isNotEmpty) {
                showCustomSnackBar('enter_delivery_fee'.tr);
              }else if(_store.selfDeliverySystem == 1 && deliveryFee.isNotEmpty && maximumFee.isNotEmpty && double.parse(maximumFee) != 0 && (double.parse(deliveryFee) > double.parse(maximumFee))) {
                showCustomSnackBar('minimum_charge_can_not_be_more_then_maximum_charge'.tr);
              }else if(minimum.isEmpty) {
                showCustomSnackBar('enter_minimum_delivery_time'.tr);
              }else if(maximum.isEmpty) {
                showCustomSnackBar('enter_maximum_delivery_time'.tr);
              }else if(deliveryChargePerKm.isEmpty) {
                showCustomSnackBar('enter_delivery_charge_per_km'.tr);
              }else if(storeController.durationIndex == 0) {
                showCustomSnackBar('select_delivery_time_type'.tr);
              }else if(_module!.orderPlaceToScheduleInterval! && processingTime.isEmpty) {
                showCustomSnackBar('enter_minimum_processing_time'.tr);
              }else if((_module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) &&
                  !storeController.isStoreVeg! && !storeController.isStoreNonVeg!){
                showCustomSnackBar('select_at_least_one_item_type'.tr);
              }else if(_module!.orderPlaceToScheduleInterval! && processingTime.isEmpty) {
                showCustomSnackBar('enter_minimum_processing_time'.tr);
              }else if(storeController.isGstEnabled! && gstCode.isEmpty) {
                showCustomSnackBar('enter_gst_code'.tr);
              }else {
                _store.name = name;
                _store.phone = contact;
                _store.address = address;
                _store.minimumOrder = double.parse(minimumOrder);
                _store.gstStatus = storeController.isGstEnabled;
                _store.gstCode = gstCode;
                _store.orderPlaceToScheduleInterval = _module!.orderPlaceToScheduleInterval!
                    ? double.parse(_processingTimeController.text).toInt() : 0;
                _store.minimumShippingCharge = double.parse(deliveryFee);
                _store.maximumShippingCharge = maximumFee.isNotEmpty ? double.parse(maximumFee) : null;
                _store.perKmShippingCharge = double.parse(deliveryChargePerKm);
                _store.veg = (_module!.vegNonVeg! && storeController.isStoreVeg!) ? 1 : 0;
                _store.nonVeg = (!_module!.vegNonVeg! || storeController.isStoreNonVeg!) ? 1 : 0;

                storeController.updateStore(
                  _store, minimum, maximum, storeController.durations[storeController.durationIndex-1],
                );
              }
            },
            buttonText: 'update'.tr,
          ) : const Center(child: CircularProgressIndicator()),

        ]);
      }),
    );
  }
}
