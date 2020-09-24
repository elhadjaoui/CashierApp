import 'package:auto_size_text/auto_size_text.dart';
import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/helper/show_popup_menu.dart';
import 'package:clock_app/helper/user_helper.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:clock_app/pdf_creation/pdf_viewer_page.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:clock_app/pdf_creation/report_pdf.dart';
import 'package:clock_app/widegt_helper/widgetsHelper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatefulWidget {
  UserInfo userInfo;
  UserDetails(this.userInfo);
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  DateTime _alarmTime;

  UserHelper _userDetailHelper = UserHelper();
  Future<List<UserDetailsInfo>> _userDetails;

  double total = 0;

  bool bol = false;

getTotal(List<UserDetailsInfo> price)
{
  total = 0;
  for(var val in price)
      total += val.price;

    print(total);

}

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _userDetailHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadUserDetails();
    });
    super.initState();
  }

  Future<void> loadUserDetails() async {
    _userDetails = _userDetailHelper.getUserDetails(widget.userInfo.name);
    var details = await _userDetails;
    if(details.isNotEmpty)
      setState(() {
        bol = true;
      });
    getTotal(await _userDetails);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton( icon: Icon( Icons.arrow_back),color: Colors.white,
                      onPressed: () async{
                     Navigator.pop(context);
                    } ,),
                    SizedBox(
                      width: 10,
                    ),
                    AutoSizeText(

                      widget.userInfo.name,
                      maxFontSize: 24,
                      maxLines: 2,
                      minFontSize: 11,
                      style: TextStyle(
                          fontFamily: 'avenir',
                          fontWeight: FontWeight.w700,
                          color: CustomColors.primaryTextColor,
                          ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: 'take',
                      icon: Icon( Icons.call_received),color: Colors.green, onPressed: () async{
                      var result = await ShowMenu().show(context, AddUserDetails(   name: widget.userInfo.name,condition: 'take',), true);
                      if(result)
                        loadUserDetails();
                    } ,),

                    IconButton(
                      tooltip: 'give',
                      icon: Icon( Icons.call_made),color: Colors.red, onPressed: () async{
                      var result = await ShowMenu().show(context, AddUserDetails(   name: widget.userInfo.name,condition: 'give',), true);
                      print("Vv $result");
                      if(result)
                        loadUserDetails();
                    } ,),
                    IconButton( icon: Icon( Icons.print),
                      color:    bol ? Colors.white : Colors.black12 ,
                        tooltip: 'print',
                      onPressed: () async {


                      // ignore: unnecessary_statements
                      bol ? ShowMenu().show(context,  userReport(context,await _userDetails,total), false) : null;
                   //   Navigator.push(context, MaterialPageRoute(builder: (build)=> reportView(context)));
                    } ,),
                  ],
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'total'.tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'avenir'),
                ),
                SizedBox(width: 8),
                Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      total.toString(),
                      style: TextStyle(
                          color: total >= 500 || total < 0 ? Colors.red: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          fontFamily: 'avenir'),
                    ),
                    SizedBox(width: 8,),
                    Text(
                      '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'avenir'),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<UserDetailsInfo>>(
                future: _userDetails,
                builder: (context, snapshot) {

                  if (snapshot.hasData)
                    {
                      //getTotal(snapshot.data);
                      return ListView.builder(
                        itemCount: snapshot.data.length,

                        itemBuilder: (context, index)
                        {

                          var alarmTime =
                          DateFormat('dd/MM/yyyy hh:mm').format(snapshot.data[index].creationDate);

                          List<Color> gradientColor = GradientTemplate
                              .gradientTemplate[CustomColors.gradientIndex()]
                              .colors;
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            actions: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: IconSlideAction(

                                  caption: 'edit'.tr(),
                                  color: gradientColor.last,
                                  icon: Icons.edit,
                                  onTap: () async {
                                   var result =  await ShowMenu().show(context, AddUserDetails( name: widget.userInfo.name,condition: 'edit',userid: snapshot.data[index],), true);

                                    print(result);
                                    if (result)
                                      loadUserDetails();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: IconSlideAction(
                                  caption: 'delete'.tr(),
                                  color:  gradientColor.last,
                                  icon: Icons.delete,
                                  onTap: () async{
                                    var result = await _userDetailHelper.deleteUserDetailsById(snapshot.data[index].id);
                                    print(result);
                                    if (result > 0)
                                      loadUserDetails();
                                  },
                                ),
                              ),
                            ],
                            child: Container(
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            snapshot.data[index].product,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'avenir'),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        snapshot.data[index].condition == 'take' ? Icons.call_received : Icons.call_made,
                                        color:  snapshot.data[index].condition == 'take' ? Colors.green : Colors.red,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data[index].price.toString() ,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'avenir',
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'avenir'),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        alarmTime,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'avenir'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        shrinkWrap: true,

                      );
                    }

                  return Center(
                    child: Text(
                      'Loading..',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
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
                                                    var userDetailsInfo =
                                                    UserDetailsInfo(
                                                        creationDate: DateTime.now(),
                                                        name: widget
                                                            .userInfo.name,
                                                        price: 20000,
                                                        total: 20);
                                                    var result =
                                                    await _userDetailHelper
                                                        .insertDetailUser(
                                                        userDetailsInfo);
                                                    if (result > 0) loadAlarms();
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
 */

/*

 */

/*

 */