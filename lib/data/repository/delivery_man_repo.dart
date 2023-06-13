import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/response/delivery_man_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeliveryManRepo {
  final ApiClient apiClient;
  DeliveryManRepo({required this.apiClient});
  
  Future<Response> getDeliveryManList() async {
    return await apiClient.getData(AppConstants.dmListUri);
  }

  Future<Response> addDeliveryMan(DeliveryManModel deliveryMan, String pass, XFile? image, List<XFile> identities, String token, bool isAdd) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('${AppConstants.baseUrl}${isAdd ? AppConstants.addDmUri : '${AppConstants.updateDmUri}${deliveryMan.id}'}',
    ));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(GetPlatform.isMobile && image != null) {
      File file = File(image.path);
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
    if(GetPlatform.isMobile && identities.isNotEmpty) {
      for (var identity in identities) {
        File file = File(identity.path);
        request.files.add(http.MultipartFile('identity_image[]', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
      }
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'f_name': deliveryMan.fName!, 'l_name': deliveryMan.lName!, 'email': deliveryMan.email!, 'password': pass,
      'phone': deliveryMan.phone!, 'identity_type': deliveryMan.identityType!, 'identity_number': deliveryMan.identityNumber!,
    });
    request.fields.addAll(fields);
    debugPrint('=====> ${request.url.path}\n${request.fields}');
    http.StreamedResponse response = await request.send();
    return Response(statusCode: response.statusCode, statusText: response.reasonPhrase);
  }

  Future<Response> updateDeliveryMan(DeliveryManModel deliveryManModel) async {
    return await apiClient.postData('${AppConstants.updateDmUri}${deliveryManModel.id}', deliveryManModel.toJson());
  }

  Future<Response> deleteDeliveryMan(int? deliveryManID) async {
    return await apiClient.postData(AppConstants.deleteDmUri, {'_method': 'delete', 'delivery_man_id': deliveryManID});
  }

  Future<Response> updateDeliveryManStatus(int? deliveryManID, int status) async {
    return await apiClient.getData('${AppConstants.updateDmStatusUri}?delivery_man_id=$deliveryManID&status=$status');
  }

  Future<Response> getDeliveryManReviews(int? deliveryManID) async {
    return await apiClient.getData('${AppConstants.dmReviewUri}?delivery_man_id=$deliveryManID');
  }

}