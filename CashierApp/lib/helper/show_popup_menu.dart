import 'package:clock_app/constants/theme_data.dart';
import 'package:clock_app/helper/CustomContainer.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:clock_app/widegt_helper/widgetsHelper.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'user_helper.dart';


class ShowMenu
{
  Future<bool> show(BuildContext context,Widget body,bool expand)
  {
    return showBarModalBottomSheet(
      expand: expand,
      isDismissible: true,
      bounce: true,
        enableDrag: true,
      context: context,
      backgroundColor: CustomColors.pageBackgroundColor,
      builder: (context, ScrollController scrollController) => body

    );
  }

}