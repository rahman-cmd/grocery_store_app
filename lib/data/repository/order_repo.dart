import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/body/update_status_body.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAllOrders() {
    return apiClient.getData(AppConstants.allOrdersUri);
  }

  Future<Response> getCurrentOrders() {
    return apiClient.getData(AppConstants.currentOrdersUri);
  }

  Future<Response> getCompletedOrders() {
    return apiClient.getData(AppConstants.completedOrdersUri);
  }

  Future<Response> getPaginatedOrderList(int offset, String status) async {
    return await apiClient.getData('${AppConstants.completedOrdersUri}?status=$status&offset=$offset&limit=10');
  }

  Future<Response> updateOrderStatus(UpdateStatusBody updateStatusBody) {
    return apiClient.postData(AppConstants.updatedOrderStatusUri, updateStatusBody.toJson());
  }

  Future<Response> getOrderDetails(int orderID) {
    return apiClient.getData('${AppConstants.orderDetailsUri}$orderID');
  }

  Future<Response> getOrderWithId(int orderId) {
    return apiClient.getData('${AppConstants.currentOrderDetailsUri}$orderId');
  }

  Future<Response> updateOrderAmount(Map<String, String> body) {
    return apiClient.postData(AppConstants.updateOrderUri, body);
  }

  Future<Response> getCancelReasons() async {
    return await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=store');
  }

}