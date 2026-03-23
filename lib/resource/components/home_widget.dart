import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../view_models/controller/home_controller/home_controller.dart';
import '../../models/song/song_model.dart';
import '../network.dart';
import '../snackbar.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      /// 🔥 FULL SCREEN GRADIENT (NO WHITE GAP)
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

      child: SafeArea(
        child: Obx(() {

          if (controller.isLoading.value) {
            return _fullShimmer();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchHomeData(isRefresh: true);
            },

            /// 🔥 FIXED SCROLL
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),

              /// 🔥 PERFECT SPACE FOR MINI PLAYER
              padding: EdgeInsets.only(bottom: 65.h),

              children: [

                if (controller.recentSongs.isNotEmpty)
                  _buildSection(
                    "Continue Listening ",
                    controller.recentSongs,
                  ),

                _buildSection("Suggested ", controller.suggestedSongs),
                _buildSection("Trending ", controller.trendingSongs),
                _buildSection("Romantic ", controller.romanticSongs),
                _buildSection("Lofi ", controller.lofiSongs),
                _buildSection("Party ", controller.partySongs),

              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _fullShimmer() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _shimmerSection(),
        _shimmerSection(),
        _shimmerSection(),
      ],
    );
  }

  Widget _shimmerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(12.w),
          child: Container(
            height: 20.h,
            width: 150.w,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 190.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (_, __) {
              return Container(
                width: 150.w,
                margin: EdgeInsets.only(left: 12.w),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    children: [
                      Container(
                        height: 120.h,
                        width: 150.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 12.h,
                        width: 100.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<SongModel> songs) {
    if (songs.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: EdgeInsets.all(12.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(
          height: 190.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (_, i) {
              final s = songs[i];

              return GestureDetector(
                onTap: () async {
                  if (!await NetworkUtils.isConnected()) {
                    AppSnackbar.error("No Internet ❌");
                    return;
                  }

                  controller.onSongClick(s);
                },
                child: _songCard(s),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _songCard(SongModel s) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.only(left: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: s.image,
              height: 120.h,
              width: 150.w,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: Colors.grey.shade200),
              errorWidget: (_, __, ___) => Container(
                color: Colors.white,
                child: const Icon(Icons.music_note, color: Colors.pink),
              ),
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            s.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),

          Text(
            s.artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}