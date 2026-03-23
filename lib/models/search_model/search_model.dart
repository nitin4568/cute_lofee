import 'package:lofeee/models/song/song_model.dart';


class SearchModel {

  List<SongModel> songs;

  SearchModel({required this.songs});

  factory SearchModel.fromJson(Map<String, dynamic> json) {

    List list = json['data']['results'];

    List<SongModel> songs =
    list.map((e) => SongModel.fromJson(e)).toList();

    return SearchModel(songs: songs);
  }
}