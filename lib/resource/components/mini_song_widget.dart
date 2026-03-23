import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:lofeee/view/track_screen/track_screen.dart';
import 'package:lofeee/view_models/controller/music_controller.dart';

class MiniPlayer extends StatelessWidget {
  MiniPlayer({super.key});

  final MusicController controller = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final song = controller.currentSong.value;
      if (song == null) return const SizedBox();

      final localId = int.tryParse(song.id);
      final isLocal = localId != null;

      return GestureDetector(
        onTap: () {
          Get.to(
                () => TrackScreen(song: song),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.pink.shade100,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [


              Obx(() {
                final total = controller.totalDuration.value.inSeconds;
                final current = controller.currentPosition.value.inSeconds;

                final progress =
                total == 0 ? 0.0 : current / total;

                return LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.pink.shade50,
                  color: Colors.pink,
                );
              }),

              SizedBox(height: 6.h),

              Row(
                children: [


                  RepaintBoundary(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: isLocal
                          ? audio.QueryArtworkWidget(
                        id: localId!,
                        type: audio.ArtworkType.AUDIO,
                        artworkHeight: 50.h,
                        artworkWidth: 50.w,
                        nullArtworkWidget: Container(
                          height: 50.h,
                          width: 50.w,
                          color: Colors.white,
                          child: const Icon(Icons.music_note),
                        ),
                      )
                          : CachedNetworkImage(
                        imageUrl: song.image,
                        height: 50.h,
                        width: 50.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.grey.shade200,
                        ),
                        errorWidget: (_, __, ___) =>
                        const Icon(Icons.music_note),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          song.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Obx(() => IconButton(
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.pink,
                      size: 26.sp,
                    ),
                    onPressed: controller.togglePlayPause,
                  )),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}