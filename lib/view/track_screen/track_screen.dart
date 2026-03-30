import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../view_models/controller/music_controller.dart';
import '../../models/song/song_model.dart';
import '../../view_models/controller/playlist_controller.dart';

class TrackScreen extends StatefulWidget {
  final SongModel song;

  const TrackScreen({super.key, required this.song});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final MusicController controller = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {

    final localId = int.tryParse(widget.song.id);
    final isLocal = localId != null;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.4),
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20.h),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 24.sp),
                        onPressed: () => Get.back(),
                      ),

                      Row(
                        children: [

                          // ❤️ LIKE


                          // ➕ ADD TO PLAYLIST
                          IconButton(
                            icon: Icon(Icons.playlist_add, size: 24.sp),
                            onPressed: () {
                              showAddToPlaylistDialog(widget.song);
                            },
                          ),
                        ],
                      )
                    ],
                  )
                ),

                /// 🔥 SONG IMAGE + INFO (REACTIVE)
                Expanded(
                  child: Obx(() {
                    final song = controller.currentSong.value;

                    if (song == null) return const SizedBox();

                    final localId = int.tryParse(song.id);
                    final isLocal = localId != null;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: SizedBox(
                            height: 260.h,
                            width: 260.w,
                            child: isLocal
                                ? audio.QueryArtworkWidget(
                                    id: localId!,
                                    type: audio.ArtworkType.AUDIO,
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget: Container(
                                      color: Theme.of(context).cardColor,
                                      child: Icon(
                                        Icons.music_note,
                                        size: 100.sp,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        song.image.isNotEmpty ? song.image : "",
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) =>
                                        Container(color: Theme.of(context).dividerColor),
                                    errorWidget: (_, __, ___) =>
                                        const Icon(Icons.music_note),
                                  ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// NAME
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              /// 🎵 SONG NAME
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  song.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),

                              SizedBox(height: 5.h),

                              /// 🎤 ARTIST
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  song.artist,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                            style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 5.h),

                      ],
                    );
                  }),
                ),


                Obx(() {
                  final total =
                      controller.totalDuration.value.inSeconds.toDouble();
                  final current =
                      controller.currentPosition.value.inSeconds.toDouble();

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        Slider(
                          min: 0,
                          max: total > 0 ? total : 1,
                          value: current.clamp(0, total == 0 ? 1 : total),
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: controller.seek,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller
                                  .formatTime(controller.currentPosition.value),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text(
                              controller
                                  .formatTime(controller.totalDuration.value),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                SizedBox(height: 10.h),


                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        IconButton(
                          icon: Icon(Icons.replay_10, size: 30.sp),
                          onPressed: controller.seekBackward,
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          padding: EdgeInsets.all(12.w),
                          child: IconButton(
                            icon: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            iconSize: 30.sp,
                            onPressed: controller.togglePlayPause,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        IconButton(
                          icon: Icon(Icons.forward_10, size: 30.sp),
                          onPressed: controller.seekForward,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.repeat_one,
                            color: controller.isRepeatMode.value
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          onPressed: () {
                            controller.isRepeatMode.toggle();
                          },
                        ),

                        SizedBox(width: 20),

                        // 🔀 NORMAL FLOW (SUFFIX ALL)
                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            color: !controller.isRepeatMode.value
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          onPressed: () {
                            controller.isRepeatMode.value = false;
                          },
                        ),
                      ],
                    )),


                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
    );

  }
  void showAddToPlaylistDialog(SongModel song) {
    final playlistController = Get.find<PlaylistController>();

    TextEditingController nameController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),

        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ➕ CREATE PLAYLIST
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  "Create New Playlist",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Get.defaultDialog(
                    title: "Create Playlist",
                    radius: 16,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                    content: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Enter playlist name",
                            prefixIcon: Icon(Icons.queue_music),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),

                    textConfirm: "Create",
                    textCancel: "Cancel",

                    confirmTextColor: Colors.white,

                    onConfirm: () {
                      if (nameController.text.trim().isEmpty) return;

                      playlistController
                          .createPlaylist(nameController.text.trim());

                      playlistController.addSong(
                        playlistController.playlists.length - 1,
                        song,
                      );

                      nameController.clear();

                      Get.back();
                      Get.back();
                    },
                  );
                },
              ),

              Divider(color: Theme.of(context).dividerColor),

              // 📂 EXISTING PLAYLIST
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlistController.playlists.length,
                  itemBuilder: (_, index) {
                    final playlist = playlistController.playlists[index];

                    return ListTile(
                      leading: Icon(Icons.queue_music),
                      title: Text(playlist.name),

                      onTap: () {
                        playlistController.addSong(index, song);
                        Get.back();

                        Get.snackbar(
                          "Added",
                          "Song added to ${playlist.name}",
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          colorText: Theme.of(context).colorScheme.onPrimary,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
