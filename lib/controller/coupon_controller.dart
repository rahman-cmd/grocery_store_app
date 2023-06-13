import 'package:get/get.dart';
import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/coupon_body.dart';
import 'package:sixam_mart_store/data/repository/coupon_repo.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';

class CouponController extends GetxController implements GetxService {
  final CouponRepo couponRepo;
  CouponController({required this.couponRepo});

  int _couponTypeIndex = 0;
  int _discountTypeIndex = 0;
  bool _isLoading = false;
  List<CouponBody>? _coupons;


  int get couponTypeIndex => _couponTypeIndex;
  int get discountTypeIndex => _discountTypeIndex;
  bool get isLoading => _isLoading;
  List<CouponBody>? get coupons => _coupons;


  void setCouponTypeIndex(int index, bool notify) {
    _couponTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getCouponList() async {
    Response response = await couponRepo.getCouponList(1);
    if(response.statusCode == 200) {
      _coupons = [];
      response.body.forEach((coupon){
        _coupons!.add(CouponBody.fromJson(coupon));
      });
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<bool> changeStatus(int? couponId, bool status) async {
    bool success = false;
    Response response = await couponRepo.changeStatus(couponId, status ? 1 : 0);
    if(response.statusCode == 200) {
      success = true;
      showCustomSnackBar(response.body['message'], isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    return success;
  }

  Future<bool> deleteCoupon(int? couponId) async {
    _isLoading = true;
    update();
    bool success = false;
    Response response = await couponRepo.deleteCoupon(couponId);
    if(response.statusCode == 200) {
      success = true;
      getCouponList();
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
    }else {
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();

    return success;
  }

  Future<void> addCoupon({
    String? code, String? title, String? startDate, String? expireDate, String? discount,
    String? couponType, String? discountType, String? limit, String? maxDiscount, String? minPurches,
  }) async {
    _isLoading = true;
    update();
    Map<String, String?> data = {
      "code": code,
      "title": title,
      "start_date": startDate,
      "expire_date": expireDate,
      "discount": discount != null && discount.isNotEmpty ? discount : '0',
      "coupon_type": couponType,
      "discount_type": discountType,
      "limit": limit,
      "max_discount": maxDiscount,
      "min_purchase": minPurches,
    };

    Response response = await couponRepo.addCoupon(data);
    if(response.statusCode == 200) {
      getCouponList();
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateCoupon({
    String? couponId, String? code, String? title, String? startDate, String? expireDate, String? discount,
    String? couponType, String? discountType, String? limit, String? maxDiscount, String? minPurches,
  }) async {
    _isLoading = true;
    update();
    Map<String, String?> data = {
      "coupon_id": couponId,
      "code": code,
      "title": title,
      "start_date": startDate,
      "expire_date": expireDate,
      "discount": discount != null && discount.isNotEmpty ? discount : '0',
      "coupon_type": couponType,
      "discount_type": discountType,
      "limit": limit,
      "max_discount": maxDiscount,
      "min_purchase": minPurches,
    };

    Response response = await couponRepo.updateCoupon(data);
    if(response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(response.body['message'], isError: false);
      getCouponList();
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

}