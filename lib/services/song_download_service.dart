import 'package:song_app/model/song_list_model.dart';
import 'package:song_app/utils/web_service.dart';

class SongDownloadService {
  SongDownloadService._internal();
  static final SongDownloadService _singleton = SongDownloadService._internal();
  factory SongDownloadService() {
    return _singleton;
  }
  Future<SongListModel> fetchAllSongs(String url) async {
    WebService webService = WebService();
    final serviceResponse = await webService.getData(url);
    print("Server Response${serviceResponse.toJson()}");
    return serviceResponse;
  }
}
