class TrackModel {

  final String id;
  final String title;
  final String artist;
  final String? previewUrl;
  final String? artwork;

  TrackModel({
    required this.id,
    required this.title,
    required this.artist,
    this.previewUrl,
    this.artwork,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {

    return TrackModel(

      id: json['asset_id'] ?? "",

      title: json['display_name'] ?? "",

      artist: "Cloudinary",

      previewUrl: json['secure_url'],

      artwork: json['secure_url'],

    );
  }
}
// class TrackModel {
//
//   final String id;
//   final String title;
//   final String artist;
//   final String? previewUrl;
//   final String? artwork;
//
//   TrackModel({
//     required this.id,
//     required this.title,
//     required this.artist,
//     this.previewUrl,
//     this.artwork,
//   });
//
//   /// Cloudinary JSON
//   factory TrackModel.fromJson(Map<String, dynamic> json) {
//     return TrackModel(
//       id: json['asset_id'] ?? "",
//       title: json['display_name'] ?? "Song",
//       artist: "Cloudinary",
//       previewUrl: json['secure_url'],
//       artwork: json['secure_url'],
//     );
//   }
//
//   /// YouTube JSON
//   factory TrackModel.fromYoutube(Map<String, dynamic> json) {
//     return TrackModel(
//       id: json["id"] ?? "",
//       title: json["title"] ?? "Song",
//       artist: "YouTube",
//       previewUrl: json["url"],
//       artwork: null,
//     );
//   }
// }class TrackModel {
//
//   final String id;
//   final String title;
//   final String artist;
//   final String? previewUrl;
//
//   TrackModel({
//     required this.id,
//     required this.title,
//     required this.artist,
//     this.previewUrl,
//   });
//
//   factory TrackModel.fromYoutube(Map<String, dynamic> json) {
//
//     return TrackModel(
//       id: json["id"],
//       title: json["title"],
//       artist: "YouTube",
//       previewUrl: json["url"],
//     );
//   }
// }