import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:song_app/model/song_list_model.dart';

class WebService {
  WebService._internal();
  static final WebService _singleton = WebService._internal();
  factory WebService() {
    return _singleton;
  }
  Future<SongListModel> getData(String url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return SongListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
