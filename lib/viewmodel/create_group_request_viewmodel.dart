import 'package:amity_uikit_beta_service/repository/create_group_repo_imp.dart';
import 'package:flutter/cupertino.dart';

enum Statevm {
  unUsed,
  loading,
  success,
  error;
}

class CreateGroupRequestVM with ChangeNotifier {
  CreateGroupRepoImp createGroupRepoImp = CreateGroupRepoImp();
  var status = Statevm.unUsed;
  String? errorMessage ;

  Future<void> createGroupRequest(String groupName, String description) async {
    status = Statevm.loading;
    notifyListeners();
    try {
      await createGroupRepoImp.createGroupRequest(
        (status, error) {
          if (status == true) {
            this.status = Statevm.success;
            notifyListeners();
          } else {
            errorMessage = error ;
            this.status = Statevm.error;
            notifyListeners();
          }
        },
        groupName,
        groupName,
      );
    } catch (e) {
      status = Statevm.error;
      notifyListeners();
    }
  }
}
