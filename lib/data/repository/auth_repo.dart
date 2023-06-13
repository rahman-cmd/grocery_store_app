import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/body/store_body.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(String? email, String password, String type) async {
    return await apiClient.postData(AppConstants.loginUri, {"email": email, "password": password, 'vendor_type': type});
  }

  Future<Response> getProfileInfo() async {
    return await apiClient.getData(AppConstants.profileUri);
  }

  Future<Response> updateProfile(ProfileModel userInfoModel, XFile? data, String token) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!,
      'phone': userInfoModel.phone!, 'token': getUserToken()
    });
    return await apiClient.postMultipartData(
      AppConstants.updateProfileUri, fields, [MultipartBody('image', data)],
    );
  }

  Future<Response> changePassword(ProfileModel userInfoModel, String password) async {
    return await apiClient.postData(AppConstants.updateProfileUri, {'_method': 'put', 'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName, 'phone': userInfoModel.phone, 'password': password, 'token': getUserToken()});
  }

  Future<Response> updateToken() async {
    String? deviceToken;
    if (GetPlatform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
    }
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      FirebaseMessaging.instance.subscribeToTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
    }
    return await apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": getUserToken(), "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '';
    if(!GetPlatform.isWeb) {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    }
    if (kDebugMode) {
      print('--------Device Token---------- $deviceToken');
    }
    return deviceToken;
  }

  Future<Response> forgetPassword(String? email) async {
    return await apiClient.postData(AppConstants.forgetPasswordUri, {"email": email});
  }

  Future<Response> verifyToken(String? email, String token) async {
    return await apiClient.postData(AppConstants.verifyTokenUri, {"email": email, "reset_token": token});
  }

  Future<Response> resetPassword(String? resetToken, String? email, String password, String confirmPassword) async {
    return await apiClient.postData(
      AppConstants.resetPasswordUri,
      {"_method": "put", "email": email, "reset_token": resetToken, "password": password, "confirm_password": confirmPassword},
    );
  }

  Future<bool> saveUserToken(String token, String zoneTopic, String type) async {
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.languageCode), null, type);
    sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    sharedPreferences.setString(AppConstants.type, type);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  // Future<bool> saveUserModulePermission(String permissionList) async {
  //   return await sharedPreferences.setString(AppConstants.MODULE_PERMISSION, permissionList);
  // }

  void updateHeader(int? moduleID) {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), sharedPreferences.getString(AppConstants.languageCode), moduleID,
      sharedPreferences.getString(AppConstants.type),
    );
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    if(!GetPlatform.isWeb) {
      apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": getUserToken(), "fcm_token": '@'});
      FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
    }
    await sharedPreferences.remove(AppConstants.token);
    await sharedPreferences.remove(AppConstants.userAddress);
    await sharedPreferences.remove(AppConstants.type);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password, String type) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(AppConstants.userType, type);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  String getUserType() {
    return sharedPreferences.getString(AppConstants.type) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userType);
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  Future<Response> toggleStoreClosedStatus() async {
    return await apiClient.postData(AppConstants.updateVendorStatusUri, {});
  }

  Future<Response> deleteVendor() async {
    return await apiClient.deleteData(AppConstants.vendorRemoveUri);
  }

  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.zoneListUri);
  }

  Future<Response> registerRestaurant(StoreBody store, XFile? logo, XFile? cover) async {
    return apiClient.postMultipartData(
      AppConstants.restaurantRegisterUri, store.toJson(), [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)],
    );
  }

  Future<Response> searchLocation(String text) async {
    return await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  Future<Response> getPlaceDetails(String? placeID) async {
    return await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng');
  }

  Future<bool> saveUserAddress(String address, List<int>? zoneIDs) async {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      sharedPreferences.getString(AppConstants.languageCode), null,
        sharedPreferences.getString(AppConstants.type)
    );
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
  }

  Future<Response> getModules(int? zoneId) async {
    return await apiClient.getData('${AppConstants.modulesUri}?zone_id=$zoneId');
  }

}
