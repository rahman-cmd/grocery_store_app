import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class AddonRepo {
  final ApiClient apiClient;
  AddonRepo({required this.apiClient});

  Future<Response> getAddonList() {
    return apiClient.getData(AppConstants.addonUri);
  }

  Future<Response> addAddon(AddOns addonModel) {
    return apiClient.postData(AppConstants.addAddonUri, addonModel.toJson());
  }

  Future<Response> updateAddon(AddOns addonModel) {
    return apiClient.putData(AppConstants.updateAddonUri, addonModel.toJson());
  }

  Future<Response> deleteAddon(int? addonID) {
    return apiClient.deleteData('${AppConstants.deleteAddonUri}?id=$addonID');
  }

}