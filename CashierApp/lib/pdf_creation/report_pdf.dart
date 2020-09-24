import 'package:clock_app/helper/show_popup_menu.dart';
import 'package:clock_app/models/expenses.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:clock_app/pdf_creation/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:flutter/material.dart' as material;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

userReport(context, List<UserDetailsInfo> userDetailsInfo, double total) async {
  final pdf = pw.Document();
  var data = await rootBundle.load("assets/fonts/Scheherazade-Regular.ttf");
  var myFont = pw.Font.ttf(data);
  final PdfImage logoImage = await pdfImageFromImageProvider(
    pdf: pdf.document,
    image: AssetImage('assets/icons/user.png'),
  );

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      // PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      theme: pw.ThemeData(),
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
            alignment: pw.Alignment.centerLeft,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
                border: pw.BoxBorder(
                    bottom: true, width: 0.5, color: PdfColors.grey)),
            child: pw.Image(logoImage,
                fit: pw.BoxFit.cover, height: 20, width: 20));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.black)));
      },
      build: (pw.Context context) => [
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(userDetailsInfo[0].name,
                          style: pw.TextStyle(font: myFont, fontSize: 20),
                          textScaleFactor: 2),
                      //  pw.PdfLogo( ),
                      pw.Image(logoImage,
                          fit: pw.BoxFit.cover, height: 30, width: 30)
                    ])),
            pw.SizedBox(height: 15),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total : ', style: pw.TextStyle(fontSize: 20)),
                  pw.Text('$total ',
                      style:
                          pw.TextStyle(fontSize: 20, color: PdfColors.green)),
                ]),
            pw.SizedBox(height: 15),
            pw.Table.fromTextArray(
                context: context,
                border: pw.TableBorder(
                  color: PdfColors.white,
                ),
                headerStyle: pw.TextStyle(fontSize: 15),
                cellAlignment: pw.Alignment.center,
                cellStyle: pw.TextStyle(font: myFont, fontSize: 18),
                oddRowDecoration:
                    pw.BoxDecoration(color: PdfColors.lightBlue50),
                headerDecoration:
                    pw.BoxDecoration(color: PdfColors.lightBlueAccent),
                data: <List<String>>[
                  <String>['Product', 'Price', 'Time'],
                  ...userDetailsInfo.map((msg) => [
                        msg.product,
                        "${msg.price.toString()}  ",
                        DateFormat('dd/MM/yyyy hh:mm').format(msg.creationDate)
                      ])
                ]),
            pw.SizedBox(height: 40),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('Signature :'), pw.Text('App Name ')]),

          ]));
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/User report.pdf';
  //print(path);
  final File file = File(path);
  var result = await file.writeAsBytes(pdf.save());
  print("result= $result");

  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfViewerPage(path: path),
    ),
  );
}
expensesReport(context, List<Expenses> expenses, double total) async {
  final pdf = pw.Document();
  var data = await rootBundle.load("assets/fonts/Scheherazade-Regular.ttf");
  var myFont = pw.Font.ttf(data);
  final PdfImage logoImage = await pdfImageFromImageProvider(
    pdf: pdf.document,
    image: AssetImage('assets/icons/user.png'),
  );

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      // PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      theme: pw.ThemeData(),
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
            alignment: pw.Alignment.centerLeft,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
                border: pw.BoxBorder(
                    bottom: true, width: 0.5, color: PdfColors.grey)),
            child: pw.Image(logoImage,
                fit: pw.BoxFit.cover, height: 20, width: 20));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.black)));
      },
      build: (pw.Context context) => [
        pw.Header(
            level: 0,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text('Expenses Report',
                      style: pw.TextStyle(font: myFont, fontSize: 20),
                      textScaleFactor: 2),
                  //  pw.PdfLogo( ),
                  pw.Image(logoImage,
                      fit: pw.BoxFit.cover, height: 30, width: 30)
                ])),
        pw.SizedBox(height: 15),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total : ', style: pw.TextStyle(fontSize: 20)),
              pw.Text('$total ',
                  style:
                  pw.TextStyle(fontSize: 20, color: PdfColors.green)),
            ]),
        pw.SizedBox(height: 15),
        pw.Table.fromTextArray(
            context: context,
            border: pw.TableBorder(
              color: PdfColors.white,
            ),
            headerStyle: pw.TextStyle(fontSize: 15),
            cellAlignment: pw.Alignment.center,
            cellStyle: pw.TextStyle(font: myFont, fontSize: 18),
            oddRowDecoration:
            pw.BoxDecoration(color: PdfColors.lightBlue50),
            headerDecoration:
            pw.BoxDecoration(color: PdfColors.lightBlueAccent),
            data: <List<String>>[
              <String>['Product', 'Price', 'Time'],
              ...expenses.map((msg) => [
                msg.name,
                "${msg.price.toString()}  ",
                DateFormat('dd/MM/yyyy hh:mm').format(msg.creationDate)
              ])
            ]),
        pw.SizedBox(height: 40),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [pw.Text('Signature :'), pw.Text('App Name ')]),

      ]));
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/Expenses report.pdf';
  //print(path);
  final File file = File(path);
  var result = await file.writeAsBytes(pdf.save());
  print("result= $result");

  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfViewerPage(path: path),
    ),
  );
}