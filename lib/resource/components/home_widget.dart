import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../view/home_page/settings_page.dart';
import '../../view_models/controller/home_controller/home_controller.dart';
import '../../models/song/song_model.dart';
import '../network.dart';
import '../snackbar.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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

      child: SafeArea(
        child: Obx(() {

          /// 🔄 LOADING
          if (controller.isLoading.value) {
            return _fullShimmer(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchHomeData(isRefresh: true);
            },

            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 65.h),

              children: [

                /// 🔥 CONTINUE LISTENING
                if (controller.recentSongs.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          "Continue Listening",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Get.to(() => SettingsScreen());
                          },
                        ),
                      ],
                    ),
                  ),

                if (controller.recentSongs.isNotEmpty)
                  SizedBox(
                    height: 190.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.recentSongs.length,
                      itemBuilder: (_, i) {
                        final s = controller.recentSongs[i];
                        return _songCard(context, s); // ✅ FIXED
                      },
                    ),
                  ),

                /// ❌ OFFLINE UI
                if (!controller.isConnected.value)
                  Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            "assets/Error 404.json",
                            height: 200,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No Internet Connection",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),

                /// ✅ ONLINE DATA
                if (controller.isConnected.value) ...[
                  _buildSection(context, "Suggested ", controller.suggestedSongs),
                  _buildSection(context, "Trending ", controller.trendingSongs),
                  _buildSection(context, "Romantic ", controller.romanticSongs),
                  _buildSection(context, "Lofi ", controller.lofiSongs),
                  _buildSection(context, "Party ", controller.partySongs),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  /// 🔥 SHIMMER
  Widget _fullShimmer(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _shimmerSection(context),
        _shimmerSection(context),
        _shimmerSection(context),
      ],
    );
  }

  Widget _shimmerSection(BuildContext context) {
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
                  baseColor: Theme.of(context).dividerColor,
                  highlightColor: Theme.of(context).hoverColor,
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

  Widget _buildSection(BuildContext context, String title, List<SongModel> songs) {
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
              return _songCard(context, s); // ✅ CLEAN
            },
          ),
        ),
      ],
    );
  }

  /// 🔥 FINAL SONG CARD (CLICK FIXED HERE)
  Widget _songCard(BuildContext context, SongModel s) {
    return GestureDetector(
      onTap: () async {
        if (!await NetworkUtils.isConnected()) {
          AppSnackbar.error("No Internet ❌");
          return;
        }

        /// 🔥 MAIN FUNCTION (OPEN TRACK SCREEN + PLAY)
        controller.onSongClick(s);
      },

      child: Container(
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
                  child: Icon(
                    Icons.music_note,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              s.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              s.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}