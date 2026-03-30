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


  var recentSearches = <String>[].obs;


  var offlineSongs = <SongModel>[].obs;
  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    audioHandler = Get.find<MyAudioHandler>();




  }

  // ================= PLAY OFFLINE =================

  Future<void> playOfflineSong(SongModel song, List<SongModel> allSongs) async {
    try {
      offlineSongs.value = allSongs;

      currentIndex = offlineSongs.indexWhere((s) => s.id == song.id);
      if (currentIndex == -1) currentIndex = 0;

      // 🔥 FIX
      musicController.currentMode = PlayMode.offline;

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

    // 🔥 FIX
    if (musicController.currentMode != PlayMode.offline) return;

    if (offlineSongs.isEmpty) return;

    currentIndex++;

    if (currentIndex >= offlineSongs.length) {
      currentIndex = 0; // 🔁 loop
    }

    _playCurrent();
  }

  // ================= STORAGE =================



  void saveSearches() {
    box.write('recentSearches', recentSearches);
  }

  // ================= LIKE =================



  void addRecentSearch(String query) {
    recentSearches.remove(query);
    recentSearches.insert(0, query);

    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }

    saveSearches();
  }
}