import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../view_models/controller/music_controller.dart';
import '../../models/song/song_model.dart';

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

    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade200,
                  Colors.pink.shade50,
                  Colors.white,
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

                      Obx(() {
                        final isLiked = controller.isLiked(widget.song);
                        return IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.pink : Colors.grey,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            controller.toggleLike(widget.song);
                          },
                        );
                      }),
                    ],
                  ),
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
                                      color: Colors.white,
                                      child:
                                          Icon(Icons.music_note, size: 100.sp),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        song.image.isNotEmpty ? song.image : "",
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) =>
                                        Container(color: Colors.grey.shade200),
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
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13.sp,
                                  ),
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
                          activeColor: Colors.pink,
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                          ),
                          padding: EdgeInsets.all(12.w),
                          child: IconButton(
                            icon: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
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
}
