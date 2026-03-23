import 'package:lofeee/data/repository/base_api/base_api.dart';
import '../../../models/song/song_model.dart';

class HomeRepository {
  final ApiService apiService = ApiService();

  Future<List<SongModel>> getSongsByQuery(String query) async {
    final response =
    await apiService.getRequest("/search/songs?query=$query");

    List songs = response['data']['results'] ?? [];

    return songs.map((e) => SongModel.fromJson(e)).toList();
  }
}