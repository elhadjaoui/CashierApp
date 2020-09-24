

import 'package:clock_app/constants/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share_extend/share_extend.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
       appBar: AppBar(title: Text('data'),backgroundColor: CustomColors.pageBackgroundColor,
         elevation: 20.0,
         centerTitle: true,
         actions: [Padding(
           padding: const EdgeInsets.symmetric(horizontal: 15.0),
           child: IconButton(icon: Icon(Icons.share), onPressed: () { 
             ShareExtend.share(path, 'file',subject: 'Mohamed El Hadjaoui');
           },),
         )],),
    );
  }
}