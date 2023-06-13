import 'package:flutter/foundation.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNameScreen extends StatefulWidget {
  final Item? item;
  const AddNameScreen({Key? key, required this.item}) : super(key: key);

  @override
  AddNameScreenState createState() => AddNameScreenState();
}

class AddNameScreenState extends State<AddNameScreen> {
  final List<TextEditingController> _nameControllerList = [];
  final List<TextEditingController> _descriptionControllerList = [];
  final List<FocusNode> _nameFocusList = [];
  final List<FocusNode> _descriptionFocusList = [];
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;

  @override
  void initState() {
    super.initState();

    if(widget.item != null) {
      for(int index=0; index<_languageList!.length; index++) {
        _nameControllerList.add(TextEditingController(
          text: widget.item!.translations![widget.item!.translations!.length-2].value,
        ));
        _descriptionControllerList.add(TextEditingController(
          text: widget.item!.translations![widget.item!.translations!.length-1].value,
        ));
        _nameFocusList.add(FocusNode());
        _descriptionFocusList.add(FocusNode());
        for (var translation in widget.item!.translations!) {
          if(_languageList![index].key == translation.locale && translation.key == 'name') {
            _nameControllerList[index] = TextEditingController(text: translation.value);
          }else if(_languageList![index].key == translation.locale && translation.key == 'description') {
            _descriptionControllerList[index] = TextEditingController(text: translation.value);
          }
        }
      }
    }else {
      for (var language in _languageList!) {
        if (kDebugMode) {
          print(language);
        }
        _nameControllerList.add(TextEditingController());
        _descriptionControllerList.add(TextEditingController());
        _nameFocusList.add(FocusNode());
        _descriptionFocusList.add(FocusNode());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.item != null ? 'update_item'.tr : 'add_item'.tr),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(children: [

          Expanded(child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _languageList!.length,
            itemBuilder: (context, index) {
              return Column(children: [

                Text(_languageList![index].value!, style: robotoBold),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                MyTextField(
                  hintText: 'item_name'.tr,
                  controller: _nameControllerList[index],
                  capitalization: TextCapitalization.words,
                  focusNode: _nameFocusList[index],
                  nextFocus: _descriptionFocusList[index],
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                MyTextField(
                  hintText: 'description'.tr,
                  controller: _descriptionControllerList[index],
                  focusNode: _descriptionFocusList[index],
                  capitalization: TextCapitalization.sentences,
                  maxLines: 5,
                  inputAction: index != _languageList!.length-1 ? TextInputAction.next : TextInputAction.done,
                  nextFocus: index != _languageList!.length-1 ? _nameFocusList[index+1] : null,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

              ]);
            },
          )),

          CustomButton(
            buttonText: 'next'.tr,
            onPressed: () {
              bool defaultDataNull = false;
              for(int index=0; index<_languageList!.length; index++) {
                if(_languageList![index].key == 'en') {
                  if (_nameControllerList[index].text.trim().isEmpty || _descriptionControllerList[index].text.trim().isEmpty) {
                    defaultDataNull = true;
                  }
                  break;
                }
              }
              if(defaultDataNull) {
                showCustomSnackBar('enter_data_for_english'.tr);
              }else {
                List<Translation> translations = [];
                for(int index=0; index<_languageList!.length; index++) {
                  translations.add(Translation(
                    locale: _languageList![index].key, key: 'name',
                    value: _nameControllerList[index].text.trim().isNotEmpty ? _nameControllerList[index].text.trim()
                        : _nameControllerList[0].text.trim(),
                  ));
                  translations.add(Translation(
                    locale: _languageList![index].key, key: 'description',
                    value: _descriptionControllerList[index].text.trim().isNotEmpty ? _descriptionControllerList[index].text.trim()
                        : _descriptionControllerList[0].text.trim(),
                  ));
                }
                Get.toNamed(RouteHelper.getAddItemRoute(widget.item, translations));
              }
            },
          ),

        ]),
      ),
    );
  }
}
