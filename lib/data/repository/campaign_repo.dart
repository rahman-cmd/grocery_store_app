import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CampaignRepo {
  final ApiClient apiClient;
  CampaignRepo({required this.apiClient});

  Future<Response> getCampaignList() async {
    return await apiClient.getData(AppConstants.basicCampaignUri);
  }

  Future<Response> joinCampaign(int? campaignID) async {
    return await apiClient.putData(AppConstants.joinCampaignUri, {'campaign_id': campaignID});
  }

  Future<Response> leaveCampaign(int? campaignID) async {
    return await apiClient.putData(AppConstants.leaveCampaignUri, {'campaign_id': campaignID});
  }

}