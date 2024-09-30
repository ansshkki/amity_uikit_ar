import 'package:amity_uikit_beta_service/utils/navigation_key.dart';
import 'package:amity_uikit_beta_service/viewmodel/amity_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'create_group_repo.dart';

class CreateGroupRepoImp implements CreateGroupRepo {
  @override
  Future<void> createGroupRequest(
    Function(bool? status, String? error) callback,
    String title,
    String description,
  ) async {
    var dio = Dio();
    try {
      var accessToken = Provider.of<AmityVM>(
        NavigationService.navigatorKey.currentContext!,
        listen: false,
      ).generalAccessToken;
      final response = await dio.post(
        "https://api.spacetoonmum.com/auth/v1/group-topic/request",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
          },
        ),
        data: {
          "description": description,
          "title": title,
        },
      );

      if (response.statusCode == 200) {
        callback(true, null);
      } else {
        // callback(null, response.data["message"]);
        callback(null, "حدث خطأ ما!");
      }
    } 
    on DioException catch (error) {
      callback(null, error.message);
    } catch (error) {
      callback(null, "خطا داخلي , يرجى التواصل مع فريق الدعم");
    }
  }
}
