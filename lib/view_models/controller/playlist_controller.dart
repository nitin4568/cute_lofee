import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/play_list.dart';
import '../../models/song/song_model.dart';

class PlaylistController extends GetxController {
  final box = GetStorage();

  var playlists = <PlaylistModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
  }

  void loadPlaylists() {
    final data = box.read('playlists') ?? [];

    playlists.value = (data as List)
        .map((e) => PlaylistModel.fromJson(e))
        .toList();
  }

  void savePlaylists() {
    box.write(
      'playlists',
      playlists.map((e) => e.toJson()).toList(),
    );
  }

  void createPlaylist(String name) {
    playlists.add(PlaylistModel(name: name, songs: []));
    savePlaylists();
  }

  /// 🔥 ADD SONG
  void addSong(int index, SongModel song) {
    final exists = playlists[index].songs
        .any((s) => s.id == song.id);

    if (exists) {
      Get.snackbar("Already Added", "Song already in playlist");
      return;
    }

    /// 🔥 DEBUG CHECK
    print("ADDING SONG IMAGE: ${song.image}");

    playlists[index].songs.add(song);

    playlists.refresh();
    savePlaylists();

    Get.snackbar("Added ✅", "Song added");
  }

  void removeSong(int pIndex, int sIndex) {
    playlists[pIndex].songs.removeAt(sIndex);

    playlists.refresh();
    savePlaylists();
  }
}