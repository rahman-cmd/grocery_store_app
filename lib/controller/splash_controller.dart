import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/repository/splash_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  ConfigModel? _configModel;
  final DateTime _currentTime = DateTime.now();
  bool _firstTimeConnectionCheck = true;
  int? _moduleID;
  String? _moduleType;
  Map<String, dynamic>? _data = {};
  String? _htmlText;

  ConfigModel? get configModel => _configModel;
  DateTime get currentTime => _currentTime;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  int? get moduleID => _moduleID;
  String? get moduleType => _moduleType;
  String? get htmlText => _htmlText;

  Future<bool> getConfigData() async {
    Response response = await splashRepo.getConfigData();
    bool isSuccess = false;
    if(response.statusCode == 200) {
      _data = response.body;
      _configModel = ConfigModel.fromJson(response.body);
      isSuccess = true;
    }else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  bool showIntro() {
    return splashRepo.showIntro();
  }

  void setIntro(bool intro) {
    splashRepo.setIntro(intro);
  }

  bool isRestaurantClosed() {
    DateTime open = DateFormat('hh:mm').parse('');
    DateTime close = DateFormat('hh:mm').parse('');
    DateTime openTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, open.hour, open.minute);
    DateTime closeTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, close.hour, close.minute);
    if(closeTime.isBefore(openTime)) {
      closeTime = closeTime.add(const Duration(days: 1));
    }
    if(_currentTime.isAfter(openTime) && _currentTime.isBefore(closeTime)) {
      return false;
    }else {
      return true;
    }
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  Future<void> setModule(int? moduleID, String? moduleType) async {
    _moduleID = moduleID;
    _moduleType = moduleType;
    if(moduleType != null) {
      _configModel!.moduleConfig!.module = Module.fromJson(_data!['module_config'][moduleType]);
    }
    update();
  }

  Module getModuleConfig(String? moduleType) {
    Module module = Module.fromJson(_data!['module_config'][moduleType]);
    if(moduleType == 'food') {
      module.newVariation = true;
    }else {
      module.newVariation = false;
    }
    return module;
  }

  Module getStoreModuleConfig() {
    Module module = Module.fromJson(_data!['module_config'][Get.find<AuthController>().profileModel!.stores!.first.module!.moduleType]);
    if(Get.find<AuthController>().profileModel!.stores!.first.module!.moduleType == 'food') {
      module.newVariation = true;
    }else {
      module.newVariation = false;
    }
    return module;
  }

  Future<void> getHtmlText(bool isPrivacyPolicy) async {
    _htmlText = null;
    Response response = await splashRepo.getHtmlText(isPrivacyPolicy);
    if (response.statusCode == 200) {
      _htmlText = response.body;
      if(_htmlText != null && _htmlText!.isNotEmpty) {
        _htmlText = _htmlText!.replaceAll('href=', 'target="_blank" href=');
      }else {
        _htmlText = '';
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

}