import 'package:sixam_mart_store/util/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit? fit;
  final String? placeholder;
  final bool isNotification;
  const CustomImage({Key? key, required this.image, this.height = 8, this.width = 9, this.fit, this.placeholder, this.isNotification = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      height: height, width: width, fit: fit,
      placeholder: isNotification ? Images.notificationPlaceholder : Images.placeholder,
      image: image,
      imageErrorBuilder: (c, o, s) => Image.asset(
        (placeholder != null && placeholder!.isNotEmpty) ? placeholder! : isNotification ? Images.notificationPlaceholder : Images.placeholder,
        height: height, width: width, fit: fit,
      ),
    );
  }
}
