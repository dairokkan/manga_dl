import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class mangakatana {
  final String baseUrl = "https://mangakatana.com";

  final http.Client client = http.Client();

  Future<http.Response> pageListRequest(String title, int chapter) async {
    print('GET page');
    return await client.get(Uri.parse('$baseUrl/manga/$title/c$chapter'));
  }

  List<String> pageListParse(http.Response response) {
    print('PARSE page');
    var document = parser.parse(response.body);
    var script = document.getElementsByTagName('script')[13];
    List<String> ar = script.text.split("var thzq=[")[1].split(",];")[0].split(',');
    for(int i = 0; i<ar.length; i++) {
      ar[i] = ar[i].split('\'')[1];
    }
    return ar;
  }
}