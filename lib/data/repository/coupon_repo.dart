import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class CouponRepo {
  final ApiClient apiClient;

  CouponRepo({required this.apiClient});

  Future<Response> addCoupon(Map<String, String?> data) async {
    return apiClient.postData(AppConstants.addCouponUri, data);
  }

  Future<Response> updateCoupon(Map<String, String?> data) async {
    return apiClient.postData(AppConstants.couponUpdateUri, data);
  }

  Future<Response> getCouponList(int offset) async {
    return apiClient.getData('${AppConstants.couponListUri}?limit=50&offset=$offset');
  }

  Future<Response> changeStatus(int? couponId, int status) async {
    return apiClient.postData(AppConstants.couponChangeStatusUri,{"coupon_id": couponId, "status": status});
  }

  Future<Response> deleteCoupon(int? couponId) async {
    return apiClient.postData(AppConstants.couponDeleteUri,{"coupon_id": couponId});
  }
}