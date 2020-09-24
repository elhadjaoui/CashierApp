import 'package:clock_app/helper/enums.dart';
import 'package:clock_app/helper/user_helper.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:flutter/foundation.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String title;
  String imageSource;
  var users;

  MenuInfo(this.menuType, {this.title, this.imageSource,this.users});

  updateMenu(MenuInfo menuInfo) {
    this.menuType = menuInfo.menuType;
    this.title = menuInfo.title;
    this.imageSource = menuInfo.imageSource;

//Important
    notifyListeners();
  }
  UserHelper _userHelper = UserHelper();

  Future<List<UserInfo>> loadUsers() {
     users = _userHelper.getUsers();
    notifyListeners();
    return users;

  }


}
