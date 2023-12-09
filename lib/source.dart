import 'package:http/http.dart' as http;
import 'package:manga_dl/chapter.dart';
import 'package:manga_dl/manga.dart';

class source {
    final String baseUrl;

    Future<http.Response> searchRequest(String query, int page) async {
        return http.Response();
    }
    
    List<manga> searchRequestParse(http.Response response) {
        return [];
    }

    Future<http.Response> pageListRequest(String url, int chapter) async {
        return http.Response();
    }

    chapter pageListParse(http.Response response) {
        return chapter();
    }
}