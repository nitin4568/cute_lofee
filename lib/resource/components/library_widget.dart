import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../view/track_screen/track_screen.dart';
import '../../models/song/song_model.dart';
import '../../view_models/controller/home_controller/offline_music_controller.dart';

import '../snackbar.dart';

class LibraryWidget extends StatefulWidget {
  const LibraryWidget({super.key});

  @override
  State<LibraryWidget> createState() => _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget>
    with WidgetsBindingObserver {

  final audio.OnAudioQuery audioQuery = audio.OnAudioQuery();
  final OfflineMusicController controller = Get.put(OfflineMusicController());

  List<audio.SongModel> songs = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  Future<void> init() async {
    await requestPermission();
    await loadSongs();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadSongs();
    }
  }

  Future<void> requestPermission() async {
    var status = await Permission.storage.request();
    var status2 = await Permission.audio.request();

    if (!(status.isGranted || status2.isGranted)) {
      AppSnackbar.error("Permission denied ");
      openAppSettings();
    }
  }

  Future<void> loadSongs() async {
    try {
      final result = await audioQuery.querySongs(
        uriType: audio.UriType.EXTERNAL,
        ignoreCase: true,
        orderType: audio.OrderType.ASC_OR_SMALLER,
        sortType: audio.SongSortType.TITLE,
      );

      setState(() {
        songs = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      AppSnackbar.error("Failed to load songs");
    }
  }

  void _onSongTap(audio.SongModel song) {
    final newSong = SongModel(
      id: song.id.toString(),
      name: song.title,
      artist: song.artist ?? "Unknown",
      image: "",
      audioUrl: song.data,
    );

    controller.playOfflineSong(
      newSong,
      songs.map((e) => SongModel(
        id: e.id.toString(),
        name: e.title,
        artist: e.artist ?? "Unknown",
        image: "",
        audioUrl: e.data,
      )).toList(),
    );

    Get.to(
          () => TrackScreen(song: newSong),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 3,
        ),
      );
    }

    if (songs.isEmpty) {
      return const Center(child: Text("No songs found 🎧"));
    }

    final filteredSongs = songs.where((song) {
      return song.title.toLowerCase().contains(searchQuery);
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 8.h),

          /// 🔍 SEARCH
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search songs...",
                 prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 6.h),

          /// 🎵 LIST + PULL REFRESH
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadSongs,
              child: ListView.builder(
                key: const PageStorageKey("library_list"),
                physics: const BouncingScrollPhysics(),
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = filteredSongs[index];

                  return Padding(
                    key: ValueKey(song.id),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => _onSongTap(song),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            ArtworkWidget(
                              key: ValueKey('art_${song.id}'),
                              song: song,
                              audioQuery: audioQuery,
                            ),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    song.artist ?? "Unknown",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
class ArtworkWidget extends StatefulWidget {
  final audio.SongModel song;
  final audio.OnAudioQuery audioQuery;

  const ArtworkWidget({
    super.key,
    required this.song,
    required this.audioQuery,
  });

  @override
  State<ArtworkWidget> createState() => _ArtworkWidgetState();
}

class _ArtworkWidgetState extends State<ArtworkWidget>
    with AutomaticKeepAliveClientMixin {

  Uint8List? _artwork;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadArtwork();
  }

  Future<void> _loadArtwork() async {
    if (_loaded) return;
    _loaded = true;

    final data = await widget.audioQuery.queryArtwork(
      widget.song.id,
      audio.ArtworkType.AUDIO,
      size: 200,
    );

    if (mounted) {
      setState(() {
        _artwork = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: _artwork != null
          ? Image.memory(
        _artwork!,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      )
          : Container(
        height: 50,
        width: 50,
        color: Theme.of(context).dividerColor,
        child: Icon(
          Icons.music_note,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}