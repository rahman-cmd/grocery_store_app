import 'package:flutter/foundation.dart';
import 'package:sixam_mart_store/controller/addon_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddonBottomSheet extends StatefulWidget {
  final AddOns? addon;
  const AddAddonBottomSheet({Key? key, required this.addon}) : super(key: key);

  @override
  State<AddAddonBottomSheet> createState() => _AddAddonBottomSheetState();
}

class _AddAddonBottomSheetState extends State<AddAddonBottomSheet> {
  final List<TextEditingController> _nameControllers = [];
  final TextEditingController _priceController = TextEditingController();
  final List<FocusNode> _nameNodes = [];
  final FocusNode _priceNode = FocusNode();
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;

  @override
  void initState() {
    super.initState();

    if(widget.addon != null) {
      for(int index=0; index<_languageList!.length; index++) {
        _nameControllers.add(TextEditingController(text: widget.addon!.translations![widget.addon!.translations!.length-1].value));
        _nameNodes.add(FocusNode());
        for(Translation translation in widget.addon!.translations!) {
          if(_languageList![index].key == translation.locale && translation.key == 'name') {
            _nameControllers[index] = TextEditingController(text: translation.value);
            break;
          }
        }
      }
      _priceController.text = widget.addon!.price.toString();
    }else {
      for (var language in _languageList!) {
        if (kDebugMode) {
          print(language);
        }
        _nameControllers.add(TextEditingController());
        _nameNodes.add(FocusNode());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
      ),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [

        ListView.builder(
          itemCount: _languageList!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              child: MyTextField(
                hintText: '${'addon_name'.tr} (${_languageList![index].value})',
                controller: _nameControllers[index],
                focusNode: _nameNodes[index],
                nextFocus: index != _languageList!.length-1 ? _nameNodes[index+1] : _priceNode,
                inputType: TextInputType.name,
                capitalization: TextCapitalization.words,
              ),
            );
          },
        ),

        MyTextField(
          hintText: 'price'.tr,
          controller: _priceController,
          focusNode: _priceNode,
          inputAction: TextInputAction.done,
          inputType: TextInputType.number,
          isAmount: true,
          amountIcon: true,
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        GetBuilder<AddonController>(builder: (addonController) {
          return !addonController.isLoading ? CustomButton(
            onPressed: () {
              String name = _nameControllers[0].text.trim();
              String price = _priceController.text.trim();
              if(name.isEmpty) {
                showCustomSnackBar('enter_addon_name'.tr);
              }else if(price.isEmpty) {
                showCustomSnackBar('enter_addon_price'.tr);
              }else {
                List<Translation> nameList = [];
                for(int index=0; index<_languageList!.length; index++) {
                  nameList.add(Translation(
                    locale: _languageList![index].key, key: 'name',
                    value: _nameControllers[index].text.trim().isNotEmpty ? _nameControllers[index].text.trim()
                        : _nameControllers[0].text.trim(),
                  ));
                }
                AddOns addon = AddOns(name: name, price: double.parse(price), translations: nameList);
                if(widget.addon != null) {
                  addon.id = widget.addon!.id;
                  addonController.updateAddon(addon);
                }else {
                  addonController.addAddon(addon);
                }
              }
            },
            buttonText: widget.addon != null ? 'update'.tr : 'submit'.tr,
          ) : const Center(child: CircularProgressIndicator());
        }),

      ])),
    );
  }
}
