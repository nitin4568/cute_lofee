import 'package:lofeee/data/repository/base_api/base_api.dart';
import '../../../models/song/song_model.dart';

class MusicRepository {

  final ApiService apiService = ApiService();


  Future<dynamic> globalSearch(String query, {int page = 1}) async {

    final response = await apiService.getRequest(
        "/search?query=$query&page=$page&limit=10");

    return response['data'];
  }


  Future<List<SongModel>> searchSongs(String query, {int page = 1}) async {

    final response = await apiService.getRequest(
        "/search/songs?query=$query&page=$page&limit=10");

    List songs = response['data']['results'];

    return songs.map((e) => SongModel.fromJson(e)).toList();
  }

  Future<dynamic> searchArtists(String query) async {

    final response =
    await apiService.getRequest("/search/artists?query=$query");

    return response['data']['results'];
  }


  Future<dynamic> searchAlbums(String query) async {

    final response =
    await apiService.getRequest("/search/albums?query=$query");

    return response['data']['results'];
  }


  Future<dynamic> searchPlaylists(String query) async {

    final response =
    await apiService.getRequest("/search/playlists?query=$query");

    return response['data']['results'];
  }


  Future<SongModel> getSong(String id) async {

    final response =
    await apiService.getRequest("/songs/$id");

    return SongModel.fromJson(response['data'][0]);
  }


  Future<List<SongModel>> getSuggestions(String id) async {

    final response =
    await apiService.getRequest("/songs/$id/suggestions");

    List songs = response['data'];

    return songs.map((e) => SongModel.fromJson(e)).toList();
  }


  Future<List<SongModel>> getPlaylistSongs(String playlistId) async {

    final response =
    await apiService.getRequest("/playlists?id=$playlistId");

    List songs = response['data']['songs'];

    return songs.map((e) => SongModel.fromJson(e)).toList();
  }


  Future<List<SongModel>> getAlbumSongs(String albumId) async {

    final response =
    await apiService.getRequest("/albums?id=$albumId");

    List songs = response['data']['songs'];

    return songs.map((e) => SongModel.fromJson(e)).toList();
  }


  Future<dynamic> getHomeModules() async {

    final response =
    await apiService.getRequest("/modules");

    return response['data'];
  }
}