import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/song/song_model.dart';
import '../../audio_handler.dart';
import '../../data/repository/music_repo/music_repository.dart';
import '../../resource/network.dart';
import '../../resource/snackbar.dart';
import 'home_controller/home_controller.dart';
import 'home_controller/offline_music_controller.dart';

enum PlayMode { random, playlist, offline }
class MusicController extends GetxController {

  PlayMode currentMode = PlayMode.random;

  final MusicRepository repository = MusicRepository();
  final box = GetStorage();

  late MyAudioHandler audioHandler;

  List<SongModel> currentPlaylist = [];
  int currentIndex = 0;

  var songs = <SongModel>[].obs;
  Rxn<SongModel> currentSong = Rxn<SongModel>();

  var recentSearches = <String>[].obs;

  var isPlaying = false.obs;
  var isSearching = false.obs;

  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  var isRepeatMode = false.obs; // 🔁 repeat single song
  String currentMood = "bollywood"; // default

  int currentPage = 1;
  bool hasMore = true;
  var isLoadingMore = false.obs;
  String currentQuery = "";

  Timer? _debounce;

  // bool isOfflineMode = false;
  Set<String> playedSongIds = {};

  @override
  void onInit() {
    super.onInit();

    audioHandler = Get.find<MyAudioHandler>();
    loadFromStorage();


    audioHandler.onSongComplete = handleSongComplete;

    audioHandler.playbackState.listen((state) {
      isPlaying.value = state.playing;
    });

    audioHandler.positionStream.listen((pos) {
      currentPosition.value = pos;
    });

    audioHandler.durationStream.listen((dur) {
      totalDuration.value = dur ?? Duration.zero;
    });
  }

  Future<void> playPlaylist(List<SongModel> songs, int startIndex) async {
    if (songs.isEmpty) return;

    currentMode = PlayMode.playlist;
    currentPlaylist = songs;
    currentIndex = startIndex;

    await playSong(
      currentPlaylist[currentIndex],
      fromPlaylist: true,
    );
  }
  // ================= AUTO NEXT =================

  Future<void> handleSongComplete() async {

    // 🔁 REPEAT MODE (BEST FIX)
    if (isRepeatMode.value) {
      await audioHandler.seek(Duration.zero);
      await audioHandler.play();
      return;
    }

    // 🎯 PLAYLIST MODE
    if (currentMode == PlayMode.playlist &&
        currentPlaylist.isNotEmpty) {

      currentIndex++;

      if (currentIndex < currentPlaylist.length) {
        await playSong(
          currentPlaylist[currentIndex],
          fromPlaylist: true,
        );
        return;
      } else {
        currentMode = PlayMode.random;
        return;
      }
    }

    // 🎯 OFFLINE MODE
    if (currentMode == PlayMode.offline) {
      final offlineController = Get.find<OfflineMusicController>();
      offlineController.playNextSong();
      return;
    }

    // 🎯 RANDOM MODE
    await playNextOnlineSong();
  }

  Future<void> playNextOnlineSong() async {
    try {
      if (currentSong.value == null) return;

      List<SongModel> songs = [];

      // 🔥 TRY SUGGESTIONS
      try {
        songs = await repository.getSuggestions(currentSong.value!.id);
      } catch (_) {}

      // 🔥 SMART FALLBACK (IMPORTANT)
      if (songs.isEmpty) {
        songs = await repository.searchSongs(
          "$currentMood bollywood latest old songs",
          page: currentPage,
        );
      }

      if (songs.isEmpty) return;

      // ❌ remove played
      final filtered = songs
          .where((s) =>
      !playedSongIds.contains(s.id) &&
          s.audioUrl.isNotEmpty)
          .toList();

      SongModel nextSong;

      if (filtered.isNotEmpty) {
        filtered.shuffle();
        nextSong = filtered.first;
      } else {
        playedSongIds.clear();
        songs.shuffle();
        nextSong = songs.first;
      }

      await playSong(nextSong);

    } catch (e) {
      print("AUTO NEXT ERROR: $e");
      AppSnackbar.error("Auto next failed ❌");
    }
  }

  // ================= SEARCH =================

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchSongs(query);
    });
  }

  Future<void> searchSongs(String query) async {
    try {
      if (query.trim().isEmpty) {
        songs.clear();
        return;
      }

      currentQuery = query;
      currentPage = 1;
      hasMore = true;

      if (!await NetworkUtils.isConnected()) {
        AppSnackbar.error("No Internet Connection ");
        return;
      }

      isSearching.value = true;
      addRecentSearch(query);

      final result = await repository.searchSongs(query, page: currentPage);

      songs.value = result;

    } catch (e) {
      AppSnackbar.error("Search failed ");
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadMoreSongs() async {
    if (isLoadingMore.value || !hasMore) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final result = await repository.searchSongs(
        currentQuery,
        page: currentPage,
      );

      if (result.isEmpty) {
        hasMore = false;
      } else {
        songs.addAll(result);
      }

    } catch (e) {
      AppSnackbar.error("Load more failed ");
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ================= PLAYER =================

  Future<void> togglePlayPause() async {
    if (isPlaying.value) {
      await audioHandler.pause();
    } else {
      await audioHandler.play();
    }
  }
  Future<void> playSong(SongModel song, {bool fromPlaylist = false}) async {
    try {
      if (currentSong.value?.id == song.id && !isRepeatMode.value) return;

      if (!fromPlaylist) {
        currentMode = PlayMode.random;
      }

      currentSong.value = song;
      playedSongIds.add(song.id);


      try {
        final homeController = Get.find<HomeController>();
        homeController.addRecent(song);
      } catch (_) {}

      // 🔥 AUTO MOOD DETECTION
      final name = song.name.toLowerCase();

      if (name.contains("love") || name.contains("romantic")) {
        currentMood = "bollywood romantic";
      } else if (name.contains("sad")) {
        currentMood = "bollywood sad";
      } else {
        currentMood = "bollywood trending";
      }

      if (!await NetworkUtils.isConnected()) {
        AppSnackbar.error("No Internet ");
        return;
      }

      await audioHandler.playMedia(
        song.audioUrl,
        song.name,
        song.artist,
        song.image,
      );

    } catch (e) {
      AppSnackbar.error("Playback failed ");
    }
  }

  void seek(double value) {
    final newPos = Duration(seconds: value.toInt());
    currentPosition.value = newPos;
    audioHandler.seek(newPos);
  }

  void seekForward() {
    final newPos = currentPosition.value + const Duration(seconds: 10);

    if (newPos < totalDuration.value) {
      currentPosition.value = newPos;
      audioHandler.seek(newPos);
    } else {
      currentPosition.value = totalDuration.value;
      audioHandler.seek(totalDuration.value);
    }
  }

  void seekBackward() {
    final newPos = currentPosition.value - const Duration(seconds: 10);

    if (newPos > Duration.zero) {
      currentPosition.value = newPos;
      audioHandler.seek(newPos);
    } else {
      currentPosition.value = Duration.zero;
      audioHandler.seek(Duration.zero);
    }
  }

  // ================= STORAGE =================

  void loadFromStorage() {

    final searches = box.read('recentSearches') ?? [];
    recentSearches.value = List<String>.from(searches);
  }



  void saveSearches() {
    box.write('recentSearches', recentSearches);
  }




  void addRecentSearch(String query) {
    recentSearches.remove(query);
    recentSearches.insert(0, query);

    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }

    saveSearches();
  }

  String formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}