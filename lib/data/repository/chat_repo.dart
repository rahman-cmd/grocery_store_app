import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/helper/user_type.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class ChatRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ChatRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getConversationList(int offset) async {
    return await apiClient.getData('${AppConstants.getConversationListUri}?offset=$offset&limit=10');
  }

  Future<Response> searchConversationList(String name) async {
    return apiClient.getData('${AppConstants.searchConversationListUri}?name=$name&limit=20&offset=1');
  }

  Future<Response> getMessages(int offset, int? userId, UserType userType, int? conversationID) async {
    return await apiClient.getData('${AppConstants.getMessageListUri}?offset=$offset&limit=10&${conversationID != null ?
    'conversation_id' : userType == UserType.delivery_man ? 'delivery_man_id' : 'user_id'}=${conversationID ?? userId}');
  }

  Future<Response> sendMessage(String message, List<MultipartBody> images, int? conversationId, int? userId, UserType userType) async {
    return await apiClient.postMultipartData(
      AppConstants.sendMessageUri,
      {'message': message, 'receiver_type': userType.name, conversationId != null ? 'conversation_id' : 'receiver_id': '${conversationId ?? userId}', 'offset': '1', 'limit': '10'},
      images,
    );
  }
}