import 'package:manga_dl/manga.dart';
import 'package:manga_dl/mangakatana.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:manga_dl/chapter.dart';
import 'package:path/path.dart';

void main(List<String> arguments) async {
  mangakatana mk = mangakatana();
  print("Query");
  String query = stdin.readLineSync()??'';
  List<manga> searchResult = mk.searchRequestParse(await mk.searchRequest(query, 1));

  for(int i=0; i<searchResult.length; i++) {
    print('${i+1}: ${searchResult[i].title}');
  }

  print("Input number in list");
  int n = int.parse(stdin.readLineSync()!);
  final String url = searchResult[n-1].url;
  final String title = searchResult[n-1].title;

  print("Chapter");
  final String cn = stdin.readLineSync()!;

  String filepath = join(Directory.current.path, title);
  chapter c = mk.pageListParse(await mk.pageListRequest(url, int.parse(cn)));
  pw.Document pdf = pw.Document();

  final String filetype = "pdf";

  print('Downloading images');
  int x = 0;
  for(String i in c.urls) {
    print('${x+1}/${c.urls.length}');
    x++;
    final http.Response response = await http.get(Uri.parse(i));
    if(filetype=="png") {
      File(join(filepath, title, 'Ch${c.chapterNumber}: ${c.chapterName}', '${i.split('/')[5]}.jpg')).create(recursive: true)
      .then((File file) async {
        await file.writeAsBytes(response.bodyBytes);
      });
    } else if (filetype=="pdf") {
      pdf.addPage(pw.MultiPage(
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
    print('Creating PDF');
    File(join(filepath, title, 'Ch${c.chapterNumber}: ${c.chapterName}')).create(recursive: true)
    .then((File file) async {
      await file.writeAsBytes(await pdf.save());
    });
  }
}