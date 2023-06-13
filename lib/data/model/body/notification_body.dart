enum NotificationType{
  message,
  order,
  general,
}

class NotificationBody {
  NotificationType? notificationType;
  int? orderId;
  int? customerId;
  int? deliveryManId;
  int? conversationId;
  String? type;

  NotificationBody({
    this.notificationType,
    this.orderId,
    this.customerId,
    this.deliveryManId,
    this.conversationId,
    this.type,
  });

  NotificationBody.fromJson(Map<String, dynamic> json) {
    notificationType = convertToEnum(json['order_notification']);
    orderId = json['order_id'];
    customerId = json['customer_id'];
    deliveryManId = json['delivery_man_id'];
    conversationId = json['conversation_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_notification'] = notificationType.toString();
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['delivery_man_id'] = deliveryManId;
    data['conversation_id'] = conversationId;
    data['type'] = type;
    return data;
  }

  NotificationType convertToEnum(String? enumString) {
    if(enumString == NotificationType.general.toString()) {
      return NotificationType.general;
    }else if(enumString == NotificationType.order.toString()) {
      return NotificationType.order;
    }else if(enumString == NotificationType.message.toString()) {
      return NotificationType.message;
    }
    return NotificationType.general;
  }

}
