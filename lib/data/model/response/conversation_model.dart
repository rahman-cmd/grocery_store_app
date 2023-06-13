class ConversationsModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Conversation>? conversations;

  ConversationsModel({this.totalSize, this.limit, this.offset, this.conversations});

  ConversationsModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['conversation'] != null) {
      conversations = <Conversation>[];
      json['conversation'].forEach((v) {
        conversations!.add(Conversation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (conversations != null) {
      data['conversation'] = conversations!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Conversation {
  int? id;
  int? senderId;
  String? senderType;
  int? receiverId;
  String? receiverType;
  int? unreadMessageCount;
  int? lastMessageId;
  String? lastMessageTime;
  String? createdAt;
  String? updatedAt;
  User? sender;
  User? receiver;
  LastMessage? lastMessage;


  Conversation({
    this.id,
    this.senderId,
    this.senderType,
    this.receiverId,
    this.receiverType,
    this.unreadMessageCount,
    this.lastMessageId,
    this.lastMessageTime,
    this.createdAt,
    this.updatedAt,
    this.sender,
    this.receiver,
    this.lastMessage,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    senderType = json['sender_type'];
    receiverId = json['receiver_id'];
    receiverType = json['receiver_type'];
    unreadMessageCount = json['unread_message_count'];
    lastMessageId = json['last_message_id'];
    lastMessageTime = json['last_message_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sender = json['sender'] != null ? User.fromJson(json['sender']) : null;
    receiver = json['receiver'] != null ? User.fromJson(json['receiver']) : null;
    lastMessage = json['last_message'] != null ? LastMessage.fromJson(json['last_message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['sender_type'] = senderType;
    data['receiver_id'] = receiverId;
    data['receiver_type'] = receiverType;
    data['unread_message_count'] = unreadMessageCount;
    data['last_message_id'] = lastMessageId;
    data['last_message_time'] = lastMessageTime;
    data['last_message'] = lastMessage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (receiver != null) {
      data['receiver'] = receiver!.toJson();
    }

    return data;
  }
}

class User {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;
  int? userId;
  int? vendorId;
  int? deliveryManId;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.image,
        this.userId,
        this.vendorId,
        this.deliveryManId,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    deliveryManId = json['deliveryman_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['deliveryman_id'] = deliveryManId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class LastMessage {
  int? id;
  int? conversationId;
  int? senderId;
  String? message;
  int? isSeen;

  LastMessage({
        this.id,
        this.conversationId,
        this.senderId,
        this.message,
        this.isSeen,
  });

  LastMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    message = json['message'];
    isSeen = json['is_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['sender_id'] = senderId;
    data['message'] = message;
    data['is_seen'] = isSeen;
    return data;
  }
}