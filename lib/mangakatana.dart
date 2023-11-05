import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:manga_dl/chapter.dart';
import 'package:manga_dl/manga.dart';

class mangakatana {
  final String baseUrl = "https://mangakatana.com";

  final http.Client client = http.Client();

  Future<http.Response> searchRequest(String query, int page) async {
    print("searchRequest");
    return await client.get(Uri.parse('$baseUrl/page/$page/?search=$query&search_by=book_name'));
  }

  List<manga> searchRequestParse(http.Response response) {
    print("searchRequestParse");
    List<String> segments = (response.request!=null)?response.request!.url.pathSegments:[];
    Document document = parser.parse(response.body);
    if(segments[0] == "manga" && segments[1]!="page") {
      return ([manga(
        title: document.getElementById('single_book')!.getElementsByTagName('h1')[0].text,
        url: response.request!.url.path
      )]);
    } else {
      List<manga> ar = [];
      int length = (document.getElementById('book_list') != null)?document.getElementById('book_list')!.getElementsByClassName('item').length:0;
      for(int i=0; i<length; i++) {
        Element res = document.getElementById('book_list')!.getElementsByClassName('item')[i];
        ar.add(manga(
          title: res.getElementsByClassName('title')[0].getElementsByTagName('a')[0].text,
          url: res.getElementsByClassName('title')[0].getElementsByTagName('a')[0].attributes['href']!
        ));
      }
      return ar;
    }
  }

  Future<http.Response> pageListRequest(String url, int chapter) async {
    print('Getting webpage');
    return await client.get(Uri.parse('$url/c$chapter'));
  }

  chapter pageListParse(http.Response response) {
    print('Parsing webpage');
    Document document = parser.parse(response.body);
    Element script = document.getElementsByTagName('script')[13];
    List<String> ar = script.text.split("var thzq=[")[1].split(",];")[0].split(',');
    for(int i = 0; i<ar.length; i++) {
      ar[i] = ar[i].split('\'')[1];
    }
    String data = document.getElementById('breadcrumb_wrap')!.getElementsByClassName('uk-active')[0].getElementsByTagName('span')[0].text;
    int number = int.parse(data.split(' ')[1].split(':')[0]);
    String title = data.substring(data.indexOf(':')+2);
    return chapter(chapterNumber: number, chapterName: title, urls: ar);
  }
}