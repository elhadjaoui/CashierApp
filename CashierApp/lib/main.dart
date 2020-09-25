import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/models/menu_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helper/enums.dart';
import 'views/homepage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    EasyLocalization(
      path: 'assets/locales',
      supportedLocales: [Locale('en', 'UK'), Locale('es', 'SP'),Locale('ar', 'SA'),Locale('hi', 'IN'),Locale('fa', 'IR')],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(

        primarySwatch: Colors.blue,
        canvasColor: CustomColors.pageBackgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<MenuInfo>(
        create: (context) => MenuInfo(MenuType.user),
        child: HomePage(),
      ),
    );
  }
}
