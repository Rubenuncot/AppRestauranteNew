import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiProvider extends ChangeNotifier {
  String baseUrl = 'telamarinera.zapto.org:16012';

  Future<String> responseJsonData(
      String verb, Map<String, String> params) async {
    final dynamic url;
    bool get = false;
    final dynamic response;

    for(var x = 0; x < params.length; x++){
      print(params.keys.first);
    }

    url = Uri.https(baseUrl, '/api/getResources/$verb', params.keys.first == '' ? params : null);

    switch (verb) {
      case 'show':
        response = await http.get(url);
        break;
      case 'delete':
        response = await http.delete(url);
        break;
      case 'update':
        response = await http.patch(url);
        break;
      case 'store':
        response = await http.post(url);
        break;
      default:
        response = await http.get(Uri.https(baseUrl));
    }
    print(response.body);
    return response.body;
  }
}
