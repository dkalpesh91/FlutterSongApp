import 'package:song_app/model/song_list_model.dart';
import 'package:song_app/utils/web_service.dart';

class SongDownloadService {
  static Future<SongListModel> fetchAllSongs(String url) async {
    final serviceResponse = await WebService().getData(url);
    print("Server Response${serviceResponse.toJson()}");
    return serviceResponse;
  }
}
