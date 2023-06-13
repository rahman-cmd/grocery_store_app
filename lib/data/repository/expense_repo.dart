import 'package:get/get.dart';
import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class ExpenseRepo {
  final ApiClient apiClient;

  ExpenseRepo({required this.apiClient});

  Future<Response> getExpenseList({required int offset, required int? restaurantId, required String? from, required String? to,  required String? searchText}) async {
    return apiClient.getData('${AppConstants.expenseListUri}?limit=10&offset=$offset&restaurant_id=$restaurantId&from=$from&to=$to&search=${searchText ?? ''}');
  }
}