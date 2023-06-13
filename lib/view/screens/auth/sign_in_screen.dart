import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
    if(Get.find<AuthController>().getUserType() == 'employee'){
      Get.find<AuthController>().changeVendorType(1, isUpdate: false);
    }else{
      Get.find<AuthController>().changeVendorType(0, isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(child: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: GetBuilder<AuthController>(builder: (authController) {

                  return Column(children: [

                    Image.asset(Images.logo, width: 200),
                    // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Text('sign_in'.tr.toUpperCase(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    // Text(
                    //   Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
                    //       ? 'only_for_restaurant_owner'.tr : 'only_for_store_owner'.tr,
                    //   textAlign: TextAlign.center,
                    //   style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                    // ),
                    const SizedBox(height: 50),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => authController.changeVendorType(0),
                            child: Column(children: [
                              Expanded(
                                child: Center(child: Text(
                                  'store_owner'.tr,
                                  style: robotoMedium.copyWith(color: authController.vendorTypeIndex == 0
                                      ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3)),
                                )),
                              ),
                              Container(
                                height: 2,
                                color: authController.vendorTypeIndex == 0 ? Theme.of(context).primaryColor : Colors.transparent,
                              ),
                            ]),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => authController.changeVendorType(1),
                            child: Column(children: [
                              Expanded(
                                child: Center(child: Text(
                                  'store_employee'.tr,
                                  style: robotoMedium.copyWith(color: authController.vendorTypeIndex == 1
                                      ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3)),
                                )),
                              ),
                              Container(
                                height: 2,
                                color: authController.vendorTypeIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent,
                              ),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 50),

                    Column(children: [

                      CustomTextField(
                        hintText: 'email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Images.mail,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        hintText: 'password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Images.lock,
                        isPassword: true,
                        onSubmit: (text) => GetPlatform.isWeb ? _login(authController) : null,
                      ),

                    ]),
                    const SizedBox(height: 10),

                    Row(children: [
                      Expanded(
                        child: ListTile(
                          onTap: () => authController.toggleRememberMe(),
                          leading: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            value: authController.isActiveRememberMe,
                            onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                          ),
                          title: Text('remember_me'.tr),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 0,
                        ),
                      ),
                      authController.vendorTypeIndex == 1 ? const SizedBox() : TextButton(
                        onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                        child: Text('${'forgot_password'.tr}?'),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    // Row(children: [
                    //
                    //   Expanded(
                    //     child: RadioListTile(
                    //       value: authController.vendorTypeIndex,
                    //       groupValue: authController.vendorTypeIndex,
                    //       title: Text('Store Owner'),
                    //       onChanged: (value){
                    //         authController.changeVendorType(0);
                    //       },
                    //     ),
                    //   ),
                    //
                    //   Expanded(
                    //     child: RadioListTile(
                    //       value: authController.vendorTypeIndex,
                    //       groupValue: authController.vendorTypeIndex,
                    //       title: Text('Store Employee'),
                    //       onChanged: (value){
                    //         authController.changeVendorType(1);
                    //       },
                    //     ),
                    //   ),
                    //   // Expanded(
                    //   //   child: ListTile(
                    //   //     onTap: () => authController.toggleRememberMe(),
                    //   //     leading: ToggleButtons(children: , isSelected: (){})
                    //   //     title: Text('remember_me'.tr),
                    //   //     contentPadding: EdgeInsets.zero,
                    //   //     dense: true,
                    //   //     horizontalTitleGap: 0,
                    //   //   ),
                    //   // ),
                    //   // TextButton(
                    //   //   onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                    //   //   child: Text('${'forgot_password'.tr}?'),
                    //   // ),
                    // ]),
                    // SizedBox(height: 50),

                    !authController.isLoading ? CustomButton(
                      buttonText: 'sign_in'.tr,
                      onPressed: () => _login(authController),
                    ) : const Center(child: CircularProgressIndicator()),
                    SizedBox(height: Get.find<SplashController>().configModel != null && Get.find<SplashController>().configModel!.toggleStoreRegistration! ? Dimensions.paddingSizeSmall : 0),

                    Get.find<SplashController>().configModel != null && Get.find<SplashController>().configModel!.toggleStoreRegistration! ? TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(1, 40),
                      ),
                      onPressed: () async {
                        // if(await canLaunchUrlString('${AppConstants.BASE_URL}/store/apply')) {
                        //   launchUrlString('${AppConstants.BASE_URL}/store/apply', mode: LaunchMode.externalApplication);
                        // }
                        Get.toNamed(RouteHelper.getRestaurantRegistrationRoute());
                      },
                      child: RichText(text: TextSpan(children: [
                        TextSpan(text: '${'join_as'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                        TextSpan(
                          text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurant'.tr : 'store'.tr,
                          style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                      ])),
                    ) : const SizedBox(),

                  ]);
                }),
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _login(AuthController authController) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String type = authController.vendorTypeIndex == 0 ? 'owner' : 'employee';
    if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else {
      authController.login(email, password, type).then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(email, password, type);
          } else {
            authController.clearUserNumberAndPassword();
          }
          await Get.find<AuthController>().getProfile();
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }

    /*print('------------1');
    final _imageData = await Http.get(Uri.parse('https://cdn.dribbble.com/users/1622791/screenshots/11174104/flutter_intro.png'));
    print('------------2');
    String _stringImage = base64Encode(_imageData.bodyBytes);
    print('------------3 {$_stringImage}');
    SharedPreferences _sp = await SharedPreferences.getInstance();
    _sp.setString('image', _stringImage);
    print('------------4');
    Uint8List _uintImage = base64Decode(_sp.getString('image'));
    authController.setImage(_uintImage);
    //await _thetaImage.writeAsBytes(_imageData.bodyBytes);
    print('------------5');*/
  }
}
