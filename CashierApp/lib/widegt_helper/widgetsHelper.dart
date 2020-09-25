import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/helper/CustomContainer.dart';
import 'package:clock_app/helper/show_popup_menu.dart';
import 'package:clock_app/helper/user_helper.dart';
import 'package:clock_app/models/expenses.dart';
import 'package:clock_app/models/menu_info.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:clock_app/service/fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class WidgetsHelper {
  UserHelper _userHelper = UserHelper();
  Fetch _fetch = Fetch();
  var _textController = TextEditingController();
  var _nametController = TextEditingController();


  Widget actionUser(BuildContext context, UserInfo data) => Container(
        //height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          bool result =  await ShowMenu().show(context, addUser( context, 'edit',data: data), true);
//                     await _userHelper.update(data);
                    print('resutttttt: $result');
                    if (result != null && result)
                      {

                        Navigator.pop(context,true);
                      }
                        },
                        child: CustomContainer(
                            header: 'edit'.tr()+' ${data.name} ', icon: Icons.edit)),
                    GestureDetector(
                        onTap: () async {
                          var result = await _userHelper.delete(data.id);
                          _userHelper.deleteUserDetails(data.name);
                          print('resutttttt: $result');
                          if (result > 0) {
//                            var menu =
//                                Provider.of<MenuInfo>(context, listen: false);
//                            menu.loadUsers();
                            Navigator.pop(context,true);
                          }
                        },
                        child: CustomContainer(
                            header: 'delete'.tr() +' ${data.name} ', icon: Icons.delete)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  Widget addUser(BuildContext context, String tag, {UserInfo data}) =>
      Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.3,
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        tag == 'add' ? 'Add User' : 'Edit User',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    cursorColor: Colors.white,
                    keyboardAppearance: Brightness.dark,
                    maxLength: 17,
                    style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w500,
                        color: CustomColors.primaryTextColor,
                        fontSize: 20),
                    keyboardType: TextInputType.text,
                    controller: _textController,
                    decoration: InputDecoration(
                      fillColor: Colors.white.withOpacity(0.4),
                      hintText: tag == 'add' ? 'User Name..' : data.name,
                      hintStyle: TextStyle(
                          fontFamily: 'avenir',
                          fontWeight: FontWeight.w500,
                          color: CustomColors.primaryTextColor,
                          fontSize: 20),
                    ),
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: CustomColors.gradientColor.last,
                    onPressed: () async {
                      List<UserInfo> existingUser = await _userHelper
                          .getUsersByName(_textController.text);
                      var result;
                      if (_textController.text.isNotEmpty) {
                        if (tag == 'add') {
                          var userInfo = UserInfo(
                            creationDate: DateTime.now(),
                            name: _textController.text,
                          );

                          if (existingUser.length == 0)
                            result = await _userHelper.insertUser(userInfo);
                          else
                            Toast.show("User Name already existed..", context, duration: Toast.LENGTH_LONG,
                                gravity:  Toast.CENTER,);

                        } else {
                          var old = data.name;
                          data.name = _textController.text;
                          data.creationDate = DateTime.now();
                          if (existingUser.length == 0)
                            {
                             var cont = await _userHelper.updateUserDetailsByName(_textController.text,old);
                             print('count = $cont');
                              result = await _userHelper.update(data);
                            }

                          else
                            print("User Name already existed");
                        }
                        if (result != null && result > 0) {
                          print('vvvv = $result');
//                          var menu =
//                          Provider.of<MenuInfo>(context, listen: false);
//                          menu.loadUsers();
                          Navigator.pop(context,true);
                        }
                      }
                      else
                        Toast.show("Name cannot be empty..", context, duration: Toast.LENGTH_LONG,
                          gravity:  Toast.CENTER,);
                    },
                    icon: Icon(Icons.done),
                    label: Text('save'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

//  Future<List<UserInfo>> getUsers(String name) async {
//    List<UserInfo> _listOfUser = await UserHelper().getUsers();
//    List<UserInfo> user = [];
//    _listOfUser.forEach((element) {
//      print('name $name');
//      if (element.name.contains(name)) user.add(element);
//    });
//    return user;
//  }

//  Widget searchForUser(BuildContext context)  {
//    String name = '';
//    List<UserInfo> user =  getUsers(name);
//
//    print("widgeeet ${user.length}");
//    return Material(
//        child: SingleChildScrollView(
//      child: Container(
//        // height: double.infinity,
//        child: Padding(
//          padding: const EdgeInsets.all(11.0),
//          child: Column(
//            children: [
//              Padding(
//                padding: const EdgeInsets.all(11.0),
//                child: TextField(
//                  cursorColor: Colors.white,
//                  keyboardAppearance: Brightness.dark,
//                  maxLength: 17,
//                  onChanged: (value) async {
//                    name = value;
//                    //user  = await getUsers(value) ;
//                  },
//                  style: TextStyle(
//                      fontFamily: 'avenir',
//                      fontWeight: FontWeight.w500,
//                      color: CustomColors.primaryTextColor,
//                      fontSize: 20),
//                  keyboardType: TextInputType.name,
//                  controller: _nametController,
//                  decoration: InputDecoration(
//                    fillColor: Colors.white.withOpacity(0.4),
//                    icon: new Icon(
//                      Icons.search,
//                      color: Colors.white,
//                    ),
//                    labelText: "search for user..",
//                    labelStyle: TextStyle(
//                        fontFamily: 'avenir',
//                        fontWeight: FontWeight.w500,
//                        color: CustomColors.primaryTextColor,
//                        fontSize: 15),
//                    enabledBorder: const OutlineInputBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                      borderSide: const BorderSide(
//                        color: Colors.grey,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 10,
//              ),
//              Padding(
//                  padding: const EdgeInsets.all(11.0),
//                  child: SingleChildScrollView(
//                    child: GridView.builder(
//                        shrinkWrap: true,
//                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                          crossAxisCount: 3,
//                          mainAxisSpacing: 1.0,
//                          crossAxisSpacing: 10.0,
//                          childAspectRatio: 1,
//                        ),
//                        itemCount: user.length ?? 0,
//                        itemBuilder: (context, index) {
//                          print("item = ${user.length}");
//                          var data = user[index];
//                          var alarmTime = DateFormat('dd/MM/yyyy hh:mm')
//                              .format(data.creationDate);
//                          var gradientColor = GradientTemplate
//                              .gradientTemplate[CustomColors.gradientIndex()]
//                              .colors;
//                          return GestureDetector(
//                            onTap: () {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (build) => UserDetails(data)));
//                            },
//                            child: Container(
//                              height: double.infinity,
//                              margin: const EdgeInsets.all(7),
//                              padding: const EdgeInsets.all(10),
//                              decoration: BoxDecoration(
//                                // image: DecorationImage(image: AssetImage('assets/clock_icon.png'),alignment: Alignment.bottomLeft, scale: 1.4),
//                                gradient: LinearGradient(
//                                  colors: gradientColor,
//                                  begin: Alignment.centerLeft,
//                                  end: Alignment.centerRight,
//                                ),
//                                boxShadow: [
//                                  BoxShadow(
//                                    color: gradientColor.last.withOpacity(0.4),
//                                    blurRadius: 8,
//                                    spreadRadius: 2,
//                                    offset: Offset(4, 4),
//                                  ),
//                                ],
//                                borderRadius:
//                                    BorderRadius.all(Radius.circular(24)),
//                              ),
//                              child: Wrap(
//                                direction: Axis.horizontal,
//                                children: <Widget>[
//                                  Icon(
//                                    Icons.person,
//                                    color: Colors.white,
//                                    size: 15,
//                                  ),
//                                  SizedBox(width: 8),
//                                  Text(
//                                    data.name,
//                                    style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: 15.0,
//                                        fontFamily: 'avenir'),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          );
//                        }),
//                  ))
//            ],
//          ),
//        ),
//      ),
//    ));
//  }
}

class AddUser extends StatefulWidget {
  UserInfo userInfo;
  String tag;
  AddUser({this.userInfo,this.tag});
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  UserHelper _userHelper = UserHelper();
  Fetch _fetch = Fetch();
  var _textController = TextEditingController();
  var _nametController = TextEditingController();
  Widget addUser(BuildContext context, String tag, {UserInfo data}) =>
      Scaffold(
        body: SingleChildScrollView(
          child: Container(
           // height: MediaQuery.of(context).size.height * 0.3,
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        tag == 'add' ? 'Add User' : 'Edit User',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    cursorColor: Colors.white,
                    keyboardAppearance: Brightness.dark,
                    maxLength: 17,
                    style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w500,
                        color: CustomColors.primaryTextColor,
                        fontSize: 20),
                    keyboardType: TextInputType.text,
                    controller: _textController,
                    decoration: InputDecoration(
                      fillColor: Colors.white.withOpacity(0.4),
                      hintText: tag == 'add' ? 'User Name..' : data.name,
                      hintStyle: TextStyle(
                          fontFamily: 'avenir',
                          fontWeight: FontWeight.w500,
                          color: CustomColors.primaryTextColor,
                          fontSize: 20),
                    ),
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: CustomColors.gradientColor.last,
                    onPressed: () async {
                      List<UserInfo> existingUser = await _userHelper
                          .getUsersByName(_textController.text);
                      var result;
                      if (_textController.text.isNotEmpty) {
                        if (tag == 'add') {
                          var userInfo = UserInfo(
                            creationDate: DateTime.now(),
                            name: _textController.text,
                          );

                          if (existingUser.length == 0)
                            result = await _userHelper.insertUser(userInfo);
                          else
                            print("User Name already existed");
                        } else {
                          data.name = _textController.text;
                          data.creationDate = DateTime.now();
                          if (existingUser.length == 0)
                            result = await _userHelper.update(data);
                          else
                            print("User Name already existed");
                        }
                        if (result != null && result > 0) {
                          print('vvvv = $result');
//                          var menu =
//                          Provider.of<MenuInfo>(context, listen: false);
//                          menu.loadUsers();
                          Navigator.pop(context,true);
                        }
                      }
                    },
                    icon: Icon(Icons.done),
                    label: Text('save'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: addUser(context,widget.tag,data: widget.userInfo),
    );
  }
}

class AddUserDetails extends StatefulWidget {
  String name;
  UserDetailsInfo userid;
  Expenses expenses;
  String condition;
  AddUserDetails({this.name,this.condition,this.userid,this.expenses});
  @override
  _AddUserDetailsState createState() => _AddUserDetailsState();
}

class _AddUserDetailsState extends State<AddUserDetails> {
  var _namecontroller = TextEditingController();
  var _pricecontroller = TextEditingController();
  UserHelper _userHelper = UserHelper();
  List<Color> gradientColor =
      GradientTemplate.gradientTemplate[CustomColors.gradientIndex()].colors;

  Widget addUserDetails(BuildContext context, String tag, {UserInfo data}) =>
      SingleChildScrollView(
    child: Container(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                   tag == 'expenses'? 'add_Expenses'.tr():'add_details'.tr() ,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextField(
              cursorColor: Colors.white,
              keyboardAppearance: Brightness.dark,
              maxLength: 17,
              enabled: widget.condition == 'take' ? false : true,
              style: TextStyle(
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w500,
                  color: CustomColors.primaryTextColor,
                  fontSize: 20),
              keyboardType: TextInputType.text,
              controller: _namecontroller,
              decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.4),
                hintText:  'product'.tr() ,
                hintStyle: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w500,
                    color: CustomColors.primaryTextColor,
                    fontSize: 20),
              ),
            ),
            TextField(
              cursorColor: Colors.white,
              keyboardAppearance: Brightness.dark,
              style: TextStyle(
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w500,
                  color: CustomColors.primaryTextColor,
                  fontSize: 20),
              keyboardType: TextInputType.number,
              controller: _pricecontroller,
              decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.4),
                hintText: '00.0',
                hintStyle: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w500,
                    color: CustomColors.primaryTextColor,
                    fontSize: 20),
              ),
            ),
            SizedBox(height: 18.0,),
            FloatingActionButton.extended(
              backgroundColor: gradientColor.last,
              onPressed: () async {
                List<UserInfo> existingUser = await _userHelper.getUsersByName(_namecontroller.text);
                var result;
                if (_pricecontroller.text.isNotEmpty) {
                  if (widget.condition == 'give') {
                    var userDetailsInfo = UserDetailsInfo(
                      condition: 'give',
                      total: 0,
                      product: _namecontroller.text,
                      price: double.parse(_pricecontroller.text) ,
                      creationDate: DateTime.now(),
                      name: widget.name,
                    );
                    result = await _userHelper.insertDetailUser(userDetailsInfo);

                  }
                  else if (widget.condition == 'expenses') {
                    var expense = Expenses(
                      name: _namecontroller.text,
                      price: double.parse(_pricecontroller.text) ,
                      creationDate: DateTime.now(),
                    );
                    result = await _userHelper.insertExpenses(expense);

                  }
                  else if(widget.condition == 'expensesEdit')
                  {
                    print('asfgasdgasdgsdgasd');
//                    _pricecontroller.text = widget.expenses.price.toString();
//                    _namecontroller.text = widget.expenses.name;
                    widget.expenses.price =  double.parse(_pricecontroller.text) ;
                    widget.expenses.name = _namecontroller.text;
                    widget.expenses.creationDate =  DateTime.now();

                    var result = await _userHelper.updateExpenses(widget.expenses,);
                    print(result);
                    if (result > 0)
                      Navigator.pop(context,true);
                  }
                  else if(widget.condition == 'edit')
                    {
//                      _pricecontroller.text =  widget.userid.price.toString();
//                      _namecontroller.text = widget.userid.product;

                      var sign =  widget.userid.condition;
                      widget.userid.price = sign == 'give' ? double.parse(_pricecontroller.text) : double.parse(_pricecontroller.text) * -1;
                      widget.userid.product = sign == 'take' ? '<=='  :_namecontroller.text;
                      widget.userid.creationDate =  DateTime.now();

                      var result = await _userHelper.updateUserDetails(widget.userid,);
                      print(result);
                      if (result > 0)
                        Navigator.pop(context,true);
                    }
                  else {
                    var userDetailsInfo = UserDetailsInfo(
                      condition: 'take',
                      total: 0,
                      product: '<==',
                      price: double.parse(_pricecontroller.text) * -1,
                      creationDate: DateTime.now(),
                      name: widget.name,
                    );
                    result = await _userHelper.insertDetailUser(userDetailsInfo);
                  }
                  if (result != null && result > 0) {
                    setState(() {

                    });
                    Navigator.pop(context,true);
                  }
                }
                else
                  Toast.show("Price field cannot be empty..", context, duration: Toast.LENGTH_LONG,
                    gravity:  Toast.CENTER,);
              },
              icon: Icon(Icons.done),
              label: Text('save'.tr()),
            ),
          ],
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: addUserDetails( context,widget.condition),
    );
  }
}
