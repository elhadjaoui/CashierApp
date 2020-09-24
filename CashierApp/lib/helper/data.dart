import 'package:clock_app/constants/theme_data.dart';
import 'enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clock_app/models/menu_info.dart';



List<MenuInfo> menuItems = [
  MenuInfo(MenuType.user,
      title: 'users', imageSource: 'assets/icons/user.png'),
  MenuInfo(MenuType.expenses,
      title: 'expenses', imageSource: 'assets/icons/money.png'),
//  MenuInfo(MenuType.setting,
//      title: 'Settings', imageSource: 'assets/icons/gear.png'),
//  MenuInfo(MenuType.about,
//      title: 'About us', imageSource: 'assets/icons/info.png'),
];

//List<UserInfo> alarms = [
//  UserInfo(
//      creationDate: DateTime.now().add(Duration(hours: 1)),
//      name: 'Office',
//      gradientColorIndex: 0),
//  UserInfo(
//      creationDate: DateTime.now().add(Duration(hours: 2)),
//      name: 'Sport',
//      gradientColorIndex: 1),
//];
