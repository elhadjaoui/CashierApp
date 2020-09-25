import 'dart:math';

import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/helper/show_popup_menu.dart';
import 'package:clock_app/helper/user_helper.dart';
import 'package:clock_app/models/expenses.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:clock_app/pdf_creation/report_pdf.dart';
import 'package:clock_app/widegt_helper/widgetsHelper.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  DateTime _expensesTime;
  String _alarmTimeString;
  UserHelper _expensesHelper = UserHelper();
  Future<List<Expenses>> _expenses;
  double total = 0;
  bool bol = false;

  getTotal(List<Expenses> price)
  {
    total = 0;
    for(var val in price)
      total += val.price;

    print(total);

  }

  @override
  void initState() {
    _expensesTime = DateTime.now();
    _expensesHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadExpenses();
    });
    super.initState();
  }

  Future<void> loadExpenses() async {
    _expenses = _expensesHelper.getExpenses();
    var details = await _expenses;
    if(details.isNotEmpty)
      setState(() {
        bol = true;
      });
    getTotal(await _expenses);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'expenses'.tr(),
                    style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w700,
                        color: CustomColors.primaryTextColor,
                        fontSize: 24),
                  ),
                  IconButton(
                    tooltip: 'add',
                    icon: Icon( Icons.add_box,),
                    color: Colors.white, onPressed:() async {
                    var result = await ShowMenu().show(context, AddUserDetails( condition: 'expenses',), true);
                    print("Vv $result");
                    if(result)
                      loadExpenses();
                  },
                  ),
                  IconButton( icon: Icon( Icons.print),
                    color:    bol ? Colors.white : Colors.black12 ,
                    tooltip: 'print',
                    onPressed: () async {


                      // ignore: unnecessary_statements
                      bol ? ShowMenu().show(context,  expensesReport(context,await _expenses,total), false) : null;
                      //   Navigator.push(context, MaterialPageRoute(builder: (build)=> reportView(context)));
                    } ,)
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
              SizedBox(height: 10.0,)
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Expenses>>(
              future: _expenses,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return ListView(
                    children: snapshot.data.map<Widget>((expense) {
                      var alarmTime =
                          DateFormat('dd/MM/yyyy').format(expense.creationDate);

                      var gradientColor = GradientTemplate
                          .gradientTemplate[CustomColors.gradientIndex()].colors;
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: [ Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: IconSlideAction(

                              caption: 'edit'.tr(),
                              color: gradientColor.last,
                              icon: Icons.edit,
                              onTap: () async {
                                var result = await ShowMenu().show(context, AddUserDetails( condition: 'expensesEdit',expenses: expense,), true);
                                print(result);
                                if (result != null && result)
                                  loadExpenses();
                              }
                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: IconSlideAction(
                              caption: 'delete'.tr(),
                              color:  gradientColor.last,
                              icon: Icons.delete,
                              onTap: () async{
                                var result = await _expensesHelper.deleteExpenses(expense.id);
                                print(result);
                                if (result > 0)
                                  loadExpenses();
                              },
                            ),
                          ),],

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
                              Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Icon(
                                    Icons.label,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    expense.name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'avenir'),
                                  ),

                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    expense.price.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'avenir',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    alarmTime,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'avenir',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                return Center(
                  child: Text(
                    'loading'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


}
/*
.followedBy([
//                      if (alarms.length < 5)
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
                                                    _expensesTime =
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
                                                  if (_expensesTime
                                                      .isAfter(DateTime.now()))
                                                    scheduleAlarmDateTime =
                                                        _expensesTime;
                                                  else
                                                    scheduleAlarmDateTime =
                                                        _expensesTime.add(
                                                            Duration(days: 1));

                                                  var expense = Expenses(
                                                    creationDate:
                                                        scheduleAlarmDateTime,
                                                    name: 'alarm',
                                                  );
                                                 var result = await  _expensesHelper
                                                      .insertExpenses(expense);
                                                 if (result > 0)
                                                   loadExpenses();
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
//                      else
//                        Text('Only 5 alarms allowed!'),
                    ])
 */