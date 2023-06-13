
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/expense_model.dart';
import 'package:sixam_mart_store/data/repository/expense_repo.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';

class ExpenseController extends GetxController implements GetxService {
  final ExpenseRepo expenseRepo;

  ExpenseController({required this.expenseRepo});

  int? _pageSize;
  List<String> _offsetList = [];
  int _offset = 1;
  bool _isLoading = false;
  List<Expense>? _expenses;
  late DateTimeRange _selectedDateRange;
  String? _from;
  String? _to;
  String? _searchText;
  bool _searchMode = false;

  int? get pageSize => _pageSize;
  int get offset => _offset;
  bool get isLoading => _isLoading;
  List<Expense>? get expenses => _expenses;
  String? get from => _from;
  String? get to => _to;
  String? get searchText => _searchText;
  bool get searchMode => _searchMode;

  void initSetDate(){
    _from = DateConverter.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 30)));
    _to = DateConverter.dateTimeForCoupon(DateTime.now());
    _searchText = '';
  }

  void setSearchText({required String offset, required String? from, required String? to, required String searchText}){
    _searchText = searchText;
    _searchMode = !_searchMode;
    getExpenseList(offset: offset.toString(), from: from, to: to, searchText: searchText);
  }

  Future<void> getExpenseList({required String offset, required String? from, required String? to, required String? searchText}) async {

    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _expenses = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      Response response = await expenseRepo.getExpenseList(
          offset: int.parse(offset), from: from, to: to,
          restaurantId: Get.find<AuthController>().profileModel!.stores![0].id, searchText: searchText);
      if (response.statusCode == 200) {
        if (offset == '1') {
          _expenses = [];
        }
        _expenses!.addAll(ExpenseBody.fromJson(response.body).expense!);
        _pageSize = ExpenseBody.fromJson(response.body).totalSize;
        _isLoading = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    }else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void showDatePicker(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      if (kDebugMode) {
        print(result.start.toString());
      }
      _selectedDateRange = result;

      _from = _selectedDateRange.start.toString().split(' ')[0];
      _to = _selectedDateRange.end.toString().split(' ')[0];
      update();
      getExpenseList(offset: '1', from: _from, to: _to, searchText: searchText);
      if (kDebugMode) {
        print('============$from / ==========$to');
      }
    }
  }

}