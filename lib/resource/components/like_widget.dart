import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/song/song_model.dart';
import '../../view_models/controller/music_controller.dart';
import '../../view/track_screen/track_screen.dart';

class LikesWidget extends StatelessWidget {
  LikesWidget({super.key});

  final MusicController controller = Get.find<MusicController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final likedSongs = controller.likedSongs;

      if (likedSongs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 60.sp, color: Colors.grey),
              SizedBox(height: 10.h),
              Text(
                "No liked songs ❤️",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: likedSongs.length,
        itemBuilder: (context, index) {
          final song = likedSongs[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                controller.playSong(song);
                Get.to(
                      () => TrackScreen(song: song),
                  transition: Transition.downToUp,
                  duration: const Duration(milliseconds: 300),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl: song.image,
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.grey.shade200,
                        ),
                        errorWidget: (_, __, ___) =>
                        const Icon(Icons.music_note),
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
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            song.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.pink),
                      onPressed: () {
                        controller.toggleLike(song);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}