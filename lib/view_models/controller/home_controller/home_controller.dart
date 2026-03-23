import 'dart:math';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/repository/music_repo/music_repository.dart';
import '../../../models/song/song_model.dart';
import '../../../resource/network.dart';
import '../../../resource/snackbar.dart';
import '../../../view/track_screen/track_screen.dart';
import '../music_controller.dart';

class HomeController extends GetxController {

  final MusicRepository musicRepo = MusicRepository();
  final box = GetStorage();
  final Random random = Random();

  var isLoading = true.obs;
  var isRefreshing = false.obs;

  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  var trendingSongs = <SongModel>[].obs;
  var romanticSongs = <SongModel>[].obs;
  var lofiSongs = <SongModel>[].obs;
  var partySongs = <SongModel>[].obs;
  var suggestedSongs = <SongModel>[].obs;

  RxList<SongModel> recentSongs = <SongModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecent();
    fetchHomeData();
  }

  /// 🔥 RANDOM QUERY GENERATOR (FIXED)
  String randomQuery(String base) {
    List<String> extras = [
      "2024",
      "latest",
      "hits",
      "top",
      "bollywood",
      "mix",
      "1990",
      "2000",
      "new",
      "old",
      "kishor"
    ];
    return "$base ${extras[random.nextInt(extras.length)]}";
  }

  Future<void> fetchHomeData({bool isRefresh = false}) async {
    try {

      if (isRefresh) {
        isRefreshing.value = true;
      } else {
        isLoading.value = true;
      }

      if (!await NetworkUtils.isConnected()) {
        AppSnackbar.error("No Internet ❌");
        isLoading.value = false;
        isRefreshing.value = false;
        return;
      }

      /// 🔥 CLEAR OLD DATA
      trendingSongs.clear();
      romanticSongs.clear();
      lofiSongs.clear();
      partySongs.clear();
      suggestedSongs.clear();

      final results = await Future.wait([
        musicRepo.searchSongs(randomQuery("trending songs")),
        musicRepo.searchSongs(randomQuery("romantic songs")),
        musicRepo.searchSongs(randomQuery("lofi songs")),
        musicRepo.searchSongs(randomQuery("party songs")),
        musicRepo.searchSongs(randomQuery("new songs")),
      ]);

      /// 🔥 UNIQUE FILTER
      trendingSongs.assignAll(_unique(results[0]));
      romanticSongs.assignAll(_unique(results[1]));
      lofiSongs.assignAll(_unique(results[2]));
      partySongs.assignAll(_unique(results[3]));
      suggestedSongs.assignAll(_unique(results[4]));

    } catch (e) {
      AppSnackbar.error("Failed to load songs ❌");
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  /// 🔥 REMOVE DUPLICATES
  List<SongModel> _unique(List<SongModel> list) {
    final map = <String, SongModel>{};
    for (var song in list) {
      map["${song.name}_${song.artist}"] = song;
    }
    return map.values.toList();
  }

  /// 🔥 RECENT SONGS
  void addRecent(SongModel song) {
    recentSongs.removeWhere(
          (s) => s.name == song.name && s.artist == song.artist,
    );

    recentSongs.insert(0, song);

    if (recentSongs.length > 20) {
      recentSongs.removeLast();
    }

    box.write(
      'recentSongs',
      recentSongs.map((e) => e.toJson()).toList(),
    );
  }

  void loadRecent() {
    final data = box.read('recentSongs');

    if (data != null && data is List) {
      recentSongs.value =
          data.map((e) => SongModel.fromJson(e)).toList();
    }
  }

  /// 🔥 FINAL SONG CLICK (MOST IMPORTANT)
  void onSongClick(SongModel song) async {

    if (!await NetworkUtils.isConnected()) {
      AppSnackbar.error("No Internet ❌");
      return;
    }

    addRecent(song);

    final musicController = Get.find<MusicController>();


    await musicController.playSong(song);


    Get.to(
          () => TrackScreen(song: song),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 300),
    );
  }
}