import 'package:backdrop/backdrop.dart';
import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/helper/data.dart';
import 'package:clock_app/helper/enums.dart';
import 'package:clock_app/models/menu_info.dart';
import 'package:clock_app/views/expenses_page.dart';
import 'package:clock_app/views/users_page.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final issueGithub = "https://github.com/elhadjaoui/CashierApp/issues";
  final repoGithub = "https://github.com/elhadjaoui/CashierApp";
  final instaAccount = "https://www.instagram.com/mohamed_el_hadjaoui/";
  final rate =
      "https://play.google.com/store/apps/details?id=com.cashier.qayadapp";
  String dropdownValue = 'English - UK';
  String icon = "uk.png";

  Future<void> send() async {
    final Email email = Email(
      body: "Hi, my name is  . I am sending you this email because",
      subject: 'Hello Dear',
      recipients: ["achraf-2060@outlook.fr"],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

  }

  Future<void> _lauchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        enableJavaScript: true,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      print('Can\'t Lauch url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        backgroundColor: CustomColors.clockBG,
        title: Text("appName".tr()),
      ),
      backLayer: Container(
        width: double.infinity,
        height: double.infinity,
        color: CustomColors.clockBG,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/gear.png',
                scale: 4.6,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'language'.tr() + ":",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  DropdownButton<String>(
                    icon: Container(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Image(
                        image: AssetImage("assets/icons/" + icon),
                      ),
                      height: 30,
                      width: 30,
                    ),
                    iconSize: 18,
                    elevation: 16,
                    value: dropdownValue,
                    style: TextStyle(color: Colors.white),
                    underline: Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      color: Colors.transparent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        if (newValue == 'English - UK') {
                          this.setState(() {
                            dropdownValue = 'English - UK';
                            icon = "uk.png";
                            context.locale = Locale('en', 'UK');
                          });
                        } else if (newValue == 'Spanish - ES') {
                          this.setState(() {
                            dropdownValue = 'Spanish - ES';
                            icon = "es.png";
                            context.locale = Locale('es', 'SP');
                          });
                        } else if (newValue == 'Arabic - SA') {
                          this.setState(() {
                            dropdownValue = 'Arabic - SA';
                            icon = "ar.png";
                            context.locale = Locale('ar', 'SA');
                          });
                        } else if (newValue == 'Farsi - IR') {
                          this.setState(() {
                            dropdownValue = 'Farsi - IR';
                            icon = "fa.png";
                            context.locale = Locale('fa', 'IR');
                          });
                        } else if (newValue == 'Hindi - IN') {
                          this.setState(() {
                            dropdownValue = 'Hindi - IN';
                            icon = "hi.png";
                            context.locale = Locale('hi', 'IN');
                          });
                        }
                      });
                    },
                    items: <String>[
                      'English - UK',
                      'Arabic - SA',
                      'Farsi - IR',
                      'Spanish - ES',
                      'Hindi - IN'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 3),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                  )
                ],
              ),
              //   Text('appName is ........\n\n\n\n\n hhhhhhhh',style: TextStyle(color: Colors.white,fontFamily: 'avenir')),
              SizedBox(
                height: 30,
              ),
              RaisedButton.icon(
                 color: CustomColors.pageBackgroundColor,
                onPressed: () async {
                 await send();
                },
                label: Text(
                  'contact_email'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),

              FlatButton.icon(
                  onPressed: () => _lauchUrl(rate),
                  icon: Icon(
                    Icons.star,
                    color: Colors.orangeAccent,
                  ),
                  label: Text('rate_us'.tr(),
                      style: TextStyle(color: Colors.white))),
              FlatButton.icon(
                  onPressed: () => _lauchUrl(instaAccount),
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  label: Text('dm_inst'.tr(),
                      style: TextStyle(color: Colors.white))),
              FlatButton.icon(
                  onPressed: () => _lauchUrl(repoGithub),
                  icon: Icon(
                    Icons.code,
                    color: Colors.white,
                  ),
                  label: Text('source_code'.tr(),
                      style: TextStyle(color: Colors.white))),
              FlatButton.icon(
                  onPressed: () => _lauchUrl(issueGithub),
                  icon: Icon(
                    Icons.bug_report,
                    color: Colors.white,
                  ),
                  label: Text('report_issue'.tr(),
                      style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
      ),
      frontLayer: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Consumer<MenuInfo>(
                builder: (BuildContext context, MenuInfo value, Widget child) {
                  if (value.menuType == MenuType.user)
                    return UsersPage();
                  else
                    return ExpensesPage();
                },
              ),
            ),
            VerticalDivider(
              color: CustomColors.dividerColor,
              width: 0.6,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: menuItems
                    .map((currentMenuInfo) => buildMenuButton(currentMenuInfo))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return Row(
          children: [
            Container(
              color: currentMenuInfo.menuType == value.menuType
                  ? CustomColors.dividerColor
                  : Colors.transparent,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            FlatButton(
              padding: const EdgeInsets.all(
                15.0,
              ),
              color: Colors.transparent,
              onPressed: () {
                var menuInfo = Provider.of<MenuInfo>(context, listen: false);
                menuInfo.updateMenu(currentMenuInfo);
              },
              child: Column(
                children: <Widget>[
                  Image.asset(
                    currentMenuInfo.imageSource,
                    scale: 8.8,
                  ),
                  SizedBox(height: 10),
                  Text(
                    currentMenuInfo.title.tr() ?? '',
                    style: TextStyle(
                        fontFamily: 'avenir',
                        color: CustomColors.primaryTextColor,
                        fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
