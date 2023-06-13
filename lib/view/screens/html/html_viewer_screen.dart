import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';


class HtmlViewerScreen extends StatefulWidget {
  final bool isPrivacyPolicy;
  const HtmlViewerScreen({Key? key, required this.isPrivacyPolicy}) : super(key: key);

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<SplashController>().getHtmlText(widget.isPrivacyPolicy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.isPrivacyPolicy ? 'privacy_policy'.tr : 'terms_condition'.tr),
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).cardColor,
          child: splashController.htmlText != null ? SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            physics: const BouncingScrollPhysics(),
            child: Html(
              data: splashController.htmlText ?? '', shrinkWrap: true,
              key: Key(widget.isPrivacyPolicy ? 'privacy_policy' : 'terms_condition'),
              onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
                if(url!.startsWith('www.')) {
                  url = 'https://$url';
                }
                debugPrint('Redirect to url: $url');
                launchUrlString(url, mode: LaunchMode.externalApplication);
              },
            ),
          ) : const Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}