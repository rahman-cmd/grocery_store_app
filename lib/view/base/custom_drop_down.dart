import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomDropDown extends StatefulWidget {
  final String value;
  final String? title;
  final List<String?> dataList;
  final Function(String value) onChanged;
  const CustomDropDown({Key? key, required this.value, required this.title, required this.dataList, required this.onChanged}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  int? _value = 0;

  @override
  void initState() {
    super.initState();

    _value = (widget.dataList.isEmpty) ? 0 : (int.parse(widget.value));
  }

  @override
  Widget build(BuildContext context) {
    List<int> indexList = [];
    int length = 1;
    length = widget.dataList.length + 1;
    for(int index=0; index<length; index++) {
      indexList.add(index);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.title != null ? Text(
        widget.title!,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
      ) : const SizedBox(),
      SizedBox(height: widget.title != null ? Dimensions.paddingSizeExtraSmall : 0),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 5))],
        ),
        child: DropdownButton<int>(
          value: _value,
          items: indexList.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value != 0 ? widget.dataList[value-1]!.tr : 'select'.tr),
            );
          }).toList(),
          onChanged: (int? value) {
            widget.onChanged(value.toString());
            setState(() {
              _value = value;
            });
          },
          isExpanded: true,
          underline: const SizedBox(),
        ),
      ),
    ]);
  }
}
