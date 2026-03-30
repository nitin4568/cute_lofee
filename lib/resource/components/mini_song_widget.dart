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
            color: Theme.of(context).cardColor,
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
                  backgroundColor: Theme.of(context).dividerColor,
                  color: Theme.of(context).colorScheme.primary,
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
                            color: Theme.of(context).cardColor,
                            child: Icon(
                              Icons.music_note,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        ),
                      )
                          : CachedNetworkImage(
                        imageUrl: song.image,
                        height: 50.h,
                        width: 50.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Theme.of(context).dividerColor,
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
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          song.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  Obx(() => IconButton(
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.primary,
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