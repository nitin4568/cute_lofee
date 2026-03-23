class HomeModel {
  final List<HomeSection> sections;

  HomeModel({required this.sections});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    List<HomeSection> temp = [];

    json.forEach((key, value) {
      if (value != null && value['data'] != null) {
        temp.add(HomeSection.fromJson(value));
      }
    });

    return HomeModel(sections: temp);
  }
}

class HomeSection {
  final String title;
  final List<HomeItem> items;

  HomeSection({required this.title, required this.items});

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    return HomeSection(
      title: json['title'] ?? "",
      items: (json['data'] as List? ?? [])
          .map((e) => HomeItem.fromJson(e))
          .toList(),
    );
  }
}

class HomeItem {
  final String id;
  final String name;
  final String type;
  final String image;
  final String artist;
  final String album;

  HomeItem({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.artist,
    required this.album,
  });

  factory HomeItem.fromJson(Map<String, dynamic> json) {

    /// 🔥 SAFE IMAGE
    String imageUrl = "";
    if (json['image'] != null &&
        json['image'] is List &&
        json['image'].isNotEmpty) {
      imageUrl = json['image'].last['url'] ?? "";
    }

    /// 🔥 SAFE ARTIST
    String artistName = "";
    if (json['artists'] != null &&
        json['artists']['primary'] != null &&
        json['artists']['primary'] is List &&
        json['artists']['primary'].isNotEmpty) {
      artistName = json['artists']['primary'][0]['name'] ?? "";
    }

    /// 🔥 SAFE ALBUM
    String albumName = "";
    if (json['album'] != null) {
      albumName = json['album']['name'] ?? "";
    }

    return HomeItem(
      id: json['id'] ?? "",
      name: json['name'] ?? json['title'] ?? "",
      type: json['type'] ?? "",
      image: imageUrl,
      artist: artistName,
      album: albumName,
    );
  }
}