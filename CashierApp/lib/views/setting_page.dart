
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';


class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String dropdownValue = 'English - UK';
  String icon = "uk.png";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Text(
                'title'.tr() + ":",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 50),
              width: width,
              alignment: Alignment.center,
              child: Container(
                height: 40,
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.white, width: .9),
                ),
                child: Container(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
                              }
                            });
                          },
                          items: <String>['English - UK', 'Spanish - ES']
                              .map<DropdownMenuItem<String>>((String value) {
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
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
