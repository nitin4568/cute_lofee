import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/song/song_model.dart';
import '../../audio_handler.dart';
import '../../data/repository/music_repo/music_repository.dart';
import '../../resource/network.dart';
import '../../resource/snackbar.dart';
import 'home_controller/offline_music_controller.dart';

class MusicController extends GetxController {

  final MusicRepository repository = MusicRepository();
  final box = GetStorage();

  late MyAudioHandler audioHandler;

  var songs = <SongModel>[].obs;
  Rxn<SongModel> currentSong = Rxn<SongModel>();
  var likedSongs = <SongModel>[].obs;
  var recentSearches = <String>[].obs;

  var isPlaying = false.obs;
  var isSearching = false.obs;

  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  String currentMood = "bollywood"; // default

  int currentPage = 1;
  bool hasMore = true;
  var isLoadingMore = false.obs;
  String currentQuery = "";

  Timer? _debounce;

  bool isOfflineMode = false;
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

  // ================= AUTO NEXT =================

  Future<void> handleSongComplete() async {

    if (isOfflineMode) {

      final offlineController = Get.find<OfflineMusicController>();
      offlineController.playNextSong();
      return;
    }


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
  Future<void> playSong(SongModel song) async {
    try {
      if (currentSong.value?.id == song.id) return;

      isOfflineMode = false;
      currentSong.value = song;

      playedSongIds.add(song.id);

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