import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../audio_handler.dart';
import '../../../models/song/song_model.dart';
import '../../../resource/snackbar.dart';
import '../music_controller.dart';

class OfflineMusicController extends GetxController {

  final MusicController musicController = Get.find<MusicController>();
  final box = GetStorage();
  late MyAudioHandler audioHandler;

  var likedSongs = <SongModel>[].obs;
  var recentSearches = <String>[].obs;


  var offlineSongs = <SongModel>[].obs;
  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    audioHandler = Get.find<MyAudioHandler>();



    loadFromStorage();
  }

  // ================= PLAY OFFLINE =================

  Future<void> playOfflineSong(SongModel song, List<SongModel> allSongs) async {
    try {
      offlineSongs.value = allSongs;

      currentIndex = offlineSongs.indexWhere((s) => s.id == song.id);
      if (currentIndex == -1) currentIndex = 0;


      musicController.isOfflineMode = true;

      musicController.currentSong.value = song;

      await _playCurrent();

    } catch (e) {
      AppSnackbar.error("Offline playback failed ");
    }
  }

  Future<void> _playCurrent() async {
    final song = offlineSongs[currentIndex];


    musicController.currentSong.value = song;

    await audioHandler.playMedia(
      song.audioUrl,
      song.name,
      song.artist,
      song.image,
    );
  }


  void playNextSong() {
    if (!musicController.isOfflineMode) return;

    if (offlineSongs.isEmpty) return;

    currentIndex++;

    if (currentIndex >= offlineSongs.length) {
      currentIndex = 0; // 🔁 infinite loop
    }

    _playCurrent();
  }

  // ================= STORAGE =================

  void loadFromStorage() {
    final liked = box.read('likedSongs') ?? [];
    likedSongs.value =
        (liked as List).map((e) => SongModel.fromJson(e)).toList();

    final searches = box.read('recentSearches') ?? [];
    recentSearches.value = List<String>.from(searches);
  }

  void saveLiked() {
    box.write(
      'likedSongs',
      likedSongs.map((e) => e.toJson()).toList(),
    );
  }

  void saveSearches() {
    box.write('recentSearches', recentSearches);
  }

  // ================= LIKE =================

  void toggleLike(SongModel song) {
    final index = likedSongs.indexWhere(
          (s) => s.name == song.name && s.artist == song.artist,
    );

    if (index != -1) {
      likedSongs.removeAt(index);
      AppSnackbar.info("Removed from likes");
    } else {
      likedSongs.add(song);
      AppSnackbar.success("Added to liked songs ❤️");
    }

    saveLiked();
  }

  bool isLiked(SongModel song) {
    return likedSongs.any(
          (s) => s.name == song.name && s.artist == song.artist,
    );
  }

  void addRecentSearch(String query) {
    recentSearches.remove(query);
    recentSearches.insert(0, query);

    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }

    saveSearches();
  }
}