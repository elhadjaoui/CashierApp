
import 'package:clock_app/helper/user_helper.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:flutter/foundation.dart';

class Fetch extends ChangeNotifier
{
  UserHelper _userHelper = UserHelper();

  Future<List<UserInfo>> loadUsers() {
    notifyListeners();
    return _userHelper.getUsers();

  }
}