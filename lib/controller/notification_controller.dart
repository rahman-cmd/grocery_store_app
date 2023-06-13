import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/notification_model.dart';
import 'package:sixam_mart_store/data/repository/notification_repo.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  List<NotificationModel>? _notificationList;
  bool _hasNotification = false;

  List<NotificationModel>? get notificationList => _notificationList;
  bool get hasNotification => _hasNotification;

  Future<void> getNotificationList() async {
    Response response = await notificationRepo.getNotificationList();
    if (response.statusCode == 200) {
      _notificationList = [];
      response.body.forEach((notify) {
        NotificationModel notification = NotificationModel.fromJson(notify);
        notification.title = notify['data']['title'];
        notification.description = notify['data']['description'].toString();
        notification.image = notify['data']['image'];
        _notificationList!.add(notification);
      });
      _notificationList!.sort((NotificationModel n1, NotificationModel n2) {
        return DateConverter.dateTimeStringToDate(n1.createdAt!).compareTo(DateConverter.dateTimeStringToDate(n2.createdAt!));
      });
      _notificationList = _notificationList!.reversed.toList();

      _hasNotification = _notificationList!.length != getSeenNotificationCount();

    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo.saveSeenNotificationCount(count);
  }

  int? getSeenNotificationCount() {
    return notificationRepo.getSeenNotificationCount();
  }

  void clearNotification() {
    _notificationList = null;
  }
}
