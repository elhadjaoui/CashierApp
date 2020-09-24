import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/helper/show_popup_menu.dart';
import 'package:clock_app/helper/user_helper.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:clock_app/views/user_details.dart';
import 'package:clock_app/widegt_helper/widgetsHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchForUser extends StatefulWidget {
  @override
  _SearchForUserState createState() => _SearchForUserState();
}

class _SearchForUserState extends State<SearchForUser> {
  var _nametController = TextEditingController();
  Future<List<UserInfo>> listOfUser =  UserHelper().getUsers();
  String name = '';
  List<UserInfo> user = [];

  Future<List<UserInfo>> getUsers(String name) async {
    List<UserInfo> _listOfUser = await UserHelper().getUsers();
    List<UserInfo> user = [];

    _listOfUser.forEach((element) {
      print(name.isEmpty);
      if (element.name.toLowerCase().contains(name.toLowerCase())) user.add(element);
      else  return _listOfUser;

    });

    return user;
  }
  void _user(String val)async
  {
    user = await getUsers(val);
    print('user ${user.length}');
  }
  @override
  void initState() {
    _user(name);
    super.initState();
  }
  Widget searchForUser(BuildContext context)  {
    return Material(
        child: SingleChildScrollView(
          child: Container(
            // height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextField(
                      cursorColor: Colors.white,
                      keyboardAppearance: Brightness.dark,
                      maxLength: 17,
                      onChanged: (value) async {
                        user.clear();
                        setState(() {

                          name = value;
                          _user(value);
                        });

                        //user  = await getUsers(value) ;
                      },
                      style: TextStyle(
                          fontFamily: 'avenir',
                          fontWeight: FontWeight.w500,
                          color: CustomColors.primaryTextColor,
                          fontSize: 20),
                      keyboardType: TextInputType.name,
                      controller: _nametController,
                      decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.4),
                        icon: new Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        labelText: "search".tr(),
                        labelStyle: TextStyle(
                            fontFamily: 'avenir',
                            fontWeight: FontWeight.w500,
                            color: CustomColors.primaryTextColor,
                            fontSize: 15),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: SingleChildScrollView(
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 1.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1,
                            ),
                            itemCount: user.length ?? 0,
                            itemBuilder: (context, index) {
                              print("item = ${user.length}");
                              var data = user[index];
                              var alarmTime = DateFormat('dd/MM/yyyy hh:mm')
                                  .format(data.creationDate);
                              var gradientColor = GradientTemplate
                                  .gradientTemplate[CustomColors.gradientIndex()]
                                  .colors;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (build) => UserDetails(data)));
                                },
                                child: Container(
                                  height: double.infinity,
                                  margin: const EdgeInsets.all(7),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    // image: DecorationImage(image: AssetImage('assets/clock_icon.png'),alignment: Alignment.bottomLeft, scale: 1.4),
                                    gradient: LinearGradient(
                                      colors: gradientColor,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: gradientColor.last.withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                  ),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        data.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontFamily: 'avenir'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:  searchForUser(context),)
    );
  }
}
