import 'dart:convert';

import 'package:bytebank/http/webclient.dart';
import 'package:http/http.dart';

const MESSAGE_URI = "https://gist.githubusercontent.com/IagoEngel/01cb3044e5da4a9e326dc898fced4661/raw/d9b8b3a0d440bea0063ab1d3ad1a57f73fc30284/";

class I18NWebClient {
  final String _viewKey;

  I18NWebClient(this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    final Response response = await client.get("$MESSAGE_URI$_viewKey.json");

    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}