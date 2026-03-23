class SongModel {
  final String id;
  final String name;
  final String artist;
  final String image;
  final String audioUrl;

  SongModel({
    required this.id,
    required this.name,
    required this.artist,
    required this.image,
    required this.audioUrl,
  });

  /// 🔥 FROM JSON (API + STORAGE BOTH SUPPORT)
  factory SongModel.fromJson(Map<String, dynamic> json) {

    /// 🔹 CASE 1: FROM STORAGE (simple structure)
    if (json.containsKey('audioUrl')) {
      return SongModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        artist: json['artist'] ?? '',
        image: json['image'] ?? '',
        audioUrl: json['audioUrl'] ?? '',
      );
    }

    /// 🔹 CASE 2: FROM API (complex structure)

    /// SAFE ARTIST
    String artistName = "Unknown";
    if (json['artists'] != null &&
        json['artists']['primary'] != null &&
        json['artists']['primary'].isNotEmpty) {
      artistName = json['artists']['primary'][0]['name'] ?? "Unknown";
    }

    /// SAFE IMAGE
    String imageUrl = "";
    if (json['image'] != null && json['image'].length > 2) {
      imageUrl = json['image'][2]['url'] ?? "";
    }

    /// SAFE AUDIO
    String audio = "";
    if (json['downloadUrl'] != null && json['downloadUrl'].length > 4) {
      audio = json['downloadUrl'][4]['url'] ?? "";
    }

    return SongModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      artist: artistName,
      image: imageUrl,
      audioUrl: audio,
    );
  }

  /// 🔥 TO JSON (FOR STORAGE)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artist': artist,
      'image': image,
      'audioUrl': audioUrl,
    };
  }
}