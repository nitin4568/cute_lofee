import 'song/song_model.dart';

class PlaylistModel {
  String name;
  List<SongModel> songs;

  PlaylistModel({
    required this.name,
    required this.songs,
  });

  /// 🔥 AUTO COVER
  String get coverImage {
    if (songs.isNotEmpty) {
      return songs.first.image;
    }
    return "";
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'songs': songs.map((e) => e.toJson()).toList(),
    };
  }

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      name: json['name'] ?? '',
      songs: (json['songs'] as List)
          .map((e) => SongModel.fromJson(e))
          .toList(),
    );
  }
}