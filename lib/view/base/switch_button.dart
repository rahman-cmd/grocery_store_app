import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool? isButtonActive;
  final Function onTap;
  const SwitchButton({Key? key, required this.icon, required this.title, required this.onTap, this.isButtonActive}) : super(key: key);

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool? _buttonActive;

  @override
  void initState() {
    super.initState();

    _buttonActive = widget.isButtonActive;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(_buttonActive != null) {
          setState(() {
            _buttonActive = !_buttonActive!;
          });
        }
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: _buttonActive != null ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [
          Icon(widget.icon, size: 25),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(child: Text(widget.title, style: robotoRegular)),
         _buttonActive != null ? Switch(
            value: _buttonActive!,
            onChanged: (bool isActive) {
              if(_buttonActive != null) {
                setState(() {
                  _buttonActive = !_buttonActive!;
                });
              }
              widget.onTap();
            },
            activeColor: Theme.of(context).primaryColor,
            activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
          ) : const SizedBox(),
        ]),
      ),
    );
  }
}
