import 'dart:math';
import 'dart:ui';

import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/helper/show_popup_menu.dart';
import 'package:clock_app/models/menu_info.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:clock_app/views/search_user.dart';
import 'package:clock_app/views/user_details.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:clock_app/widegt_helper/widgetsHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helper/user_helper.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  DateTime _alarmTime;
  String _alarmTimeString;
  UserHelper _userHelper = UserHelper();
  //Fetch _fetch = Fetch();
  Future<List<UserInfo>> _users;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    //_users = _fetch.loadUsers();
    super.initState();
  }

//  void loadUsers() {
//    _users = _fetch.loadUsers();
//    if (mounted) setState(() {});
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'users'.tr(),
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryTextColor,
                    fontSize: 24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'add',
                   icon: Icon( Icons.person_add,),
                    color: Colors.white, onPressed:() async {
                    ShowMenu().show(context, WidgetsHelper().addUser(context,'add',), true);
//                        print('rex = $result');
//                        if (result != null && result  ) {
//                          setState(() {});
//                        }
                  },
                  ),
                  SizedBox(
                    width: 13.0,
                  ),
                  IconButton(
                     tooltip: 'search',
                    color: Colors.white,
                    icon: Icon(Icons.search,),
                    onPressed: ()
                  async {
                    ShowMenu().show(context, SearchForUser(), true);
                    //_userHelper.getUsersByName()
                    // Navigator.push(context, MaterialPageRoute(builder: (build)=> SearchForUser()));
                  },
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Expanded(
            child: Consumer(
                builder: (BuildContext context, MenuInfo value, Widget child)
                {
                  return FutureBuilder<List<UserInfo>>(
                    future: value.loadUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return GridView.builder(
                          physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 1.0,
                              crossAxisSpacing: 13.0,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data;
                              var alarmTime = DateFormat('dd/MM/yyyy hh:mm')
                                  .format(data[index].creationDate);
                              var ccolor = Random();
                              int ccclor = ccolor.nextInt(
                                  GradientTemplate.gradientTemplate.length - 1);
                              var gradientColor =
                                  GradientTemplate.gradientTemplate[ccclor].colors;
                              return GestureDetector(
                                onLongPress: () async {
                                  var result = await ShowMenu().show(
                                      context,
                                      WidgetsHelper()
                                          .actionUser(context, data[index]),
                                      false);
//                            print(result);
//                            if (result) setState(() {});
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (build) =>
                                              UserDetails(data[index])));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 32),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 8),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Wrap(
                                        children: <Widget>[
                                          Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            data[index].name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                fontFamily: 'avenir'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            alarmTime,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'avenir',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700),
                                          ),
//                                      IconButton(
//                                        icon: Icon(Icons.delete),
//                                        color: Colors.white,
//                                        onPressed: () {
//                                          _userHelper.delete(data[index].id);
//                                          loadAlarms();
//                                        },
//                                      ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      return Center(
                        child: Text(
                          'Loading..',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
/*
ListView(
                    children: snapshot.data.map<Widget>((alarm) {
                      var alarmTime =
                      DateFormat('hh:mm aa').format(alarm.alarmDateTime);
                      var ccolor = Random();
                      int ccclor = ccolor.nextInt(GradientTemplate.gradientTemplate.length - 1);
                      var gradientColor = GradientTemplate
                          .gradientTemplate[ccclor].colors;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
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
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.label,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      alarm.title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'avenir'),
                                    ),
                                  ],
                                ),
                                Switch(
                                  onChanged: (bool value) {},
                                  value: true,
                                  activeColor: Colors.white,
                                ),
                              ],
                            ),
                            Text(
                              'Mon-Fri',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'avenir'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  alarmTime,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'avenir',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.white,
                                  onPressed: () {
                                    _alarmHelper.delete(alarm.id);
                                    loadAlarms();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).followedBy([
                      if (alarms.length < 5)
                        DottedBorder(
                          strokeWidth: 2,
                          color: CustomColors.clockOutline,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(24),
                          dashPattern: [5, 4],
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.clockBG,
                              borderRadius:
                              BorderRadius.all(Radius.circular(24)),
                            ),
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString =
                                    DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Container(
                                          padding: const EdgeInsets.all(32),
                                          child: Column(
                                            children: [
                                              FlatButton(
                                                onPressed: () async {
                                                  var selectedTime =
                                                  await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                    TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    var selectedDateTime =
                                                    DateTime(
                                                        now.year,
                                                        now.month,
                                                        now.day,
                                                        selectedTime.hour,
                                                        selectedTime
                                                            .minute);
                                                    _alarmTime =
                                                        selectedDateTime;
                                                    setModalState(() {
                                                      _alarmTimeString =
                                                          selectedTime
                                                              .toString();
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  _alarmTimeString,
                                                  style:
                                                  TextStyle(fontSize: 32),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text('Repeat'),
                                                trailing: Icon(
                                                    Icons.arrow_forward_ios),
                                              ),
                                              ListTile(
                                                title: Text('Sound'),
                                                trailing: Icon(
                                                    Icons.arrow_forward_ios),
                                              ),
                                              ListTile(
                                                title: Text('Title'),
                                                trailing: Icon(
                                                    Icons.arrow_forward_ios),
                                              ),
                                              FloatingActionButton.extended(
                                                onPressed: () async {
                                                  DateTime
                                                  scheduleAlarmDateTime;
                                                  if (_alarmTime
                                                      .isAfter(DateTime.now()))
                                                    scheduleAlarmDateTime =
                                                        _alarmTime;
                                                  else
                                                    scheduleAlarmDateTime =
                                                        _alarmTime.add(
                                                            Duration(days: 1));

                                                  var alarmInfo = AlarmInfo(
                                                    alarmDateTime:
                                                    scheduleAlarmDateTime,
                                                    gradientColorIndex:
                                                    alarms.length,
                                                    title: 'alarm',
                                                  );
                                                  var result = await  _alarmHelper
                                                      .insertAlarm(alarmInfo);
                                                  if (result > 0)
                                                    loadAlarms();
                                                  Navigator.pop(context);

                                                  // scheduleAlarm(
                                                  //     scheduleAlarmDateTime);
                                                },
                                                icon: Icon(Icons.alarm),
                                                label: Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                                // scheduleAlarm();
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/add_alarm.png',
                                    scale: 1.5,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add Alarm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'avenir'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Text('Only 5 alarms allowed!'),
                    ]).toList(),
                  );
 */
/*

 */