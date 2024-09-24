import 'package:dio/dio.dart';
import 'create_group_repo.dart';

class CreateGroupRepoImp implements CreateGroupRepo {
  @override
  Future<void> createGroupRequest(
    Function(bool? status, String? error) callback,
    String groupName,
    String description,
  ) async {
    var dio = Dio();
    final response = await dio.post(
      "",
    );

    print("status code is ${response.statusCode}");
    if (response.statusCode == 200) {
      callback(true, null);
    } else {
      callback(
        null,
        response.data["message"],
      );
    }
  }
}
