import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/body/bank_info_body.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class BankRepo {
  final ApiClient apiClient;
  BankRepo({required this.apiClient});
  
  Future<Response> updateBankInfo(BankInfoBody bankInfoBody) async {
    return await apiClient.putData(AppConstants.updateBankInfoUri, bankInfoBody.toJson());
  }

  Future<Response> getWithdrawList() async {
    return await apiClient.getData(AppConstants.withdrawListUri);
  }

  Future<Response> requestWithdraw(String amount) async {
    return await apiClient.postData(AppConstants.withdrawRequestUri, {'amount': amount});
  }

}