import 'package:manga_dl/mangakatana.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

void main(List<String> arguments) async {
  mangakatana mk = mangakatana();

  print("Title ID");
  final String title = stdin.readLineSync()??'';
  print("Chapter");
  final String chapter = stdin.readLineSync()??'';

  String filepath = 'C:\\Users\\asus\\Downloads';
  List<String> urls = mk.pageListParse(await mk.pageListRequest(title, int.parse(chapter)));
  pw.Document pdf = pw.Document(); 

  final String filetype = "pdf";

  for(String i in urls) {
    print('GET $i');
    final http.Response response = await http.get(Uri.parse(i));
    if(filetype=="png") {
      File('$filepath\\$title\\ch$chapter\\${i.split('/')[5]}.jpg').create(recursive: true)
      .then((File file) async {
        await file.writeAsBytes(response.bodyBytes);
      });
    } else if (filetype=="pdf") {
      pdf.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.all(0),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Image(pw.MemoryImage(response.bodyBytes)),
          ];
        }
      ));
    } else {
      print("error");
    }
  }

  if(filetype=="pdf") {
    print('CREATE PDF');
    File('$filepath\\wind-breaker-nii-satoru.26194\\ch$chapter\\document.pdf').create(recursive: true)
    .then((File file) async {
      await file.writeAsBytes(await pdf.save());
    });
  }
}