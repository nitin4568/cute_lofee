import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lofeee/view/track_screen/track_screen.dart';
import 'package:lofeee/view_models/controller/music_controller.dart';
import 'package:lofeee/view_models/controller/home_controller/home_controller.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final MusicController controller = Get.find<MusicController>();
  final HomeController homeController = Get.find<HomeController>();

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        controller.loadMoreSongs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6)
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  controller.onSearchChanged(value);
                },
                onSubmitted: controller.searchSongs,
                decoration: const InputDecoration(
                  hintText: "Search songs...",
                  prefixIcon: Icon(Icons.search, color: Colors.pink),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          Obx(() {
            final searches = controller.recentSearches;

            if (searches.isEmpty) return const SizedBox();

            return SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: searches.length,
                itemBuilder: (_, index) {
                  final item = searches[index];

                  return GestureDetector(
                    onTap: () {
                      searchController.text = item;
                      controller.searchSongs(item);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: Text(item)),
                    ),
                  );
                },
              ),
            );
          }),


          Expanded(
            child: Obx(() {
              final songs = controller.songs;


              if (controller.isSearching.value) {
                return ListView.builder(
                  itemCount: 6,
                  itemBuilder: (_, __) => _shimmerTile(),
                );
              }


              if (songs.isEmpty) {
                return const Center(
                  child: Text(
                    "Search your favorite songs 🎧",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,


                itemCount: songs.length + (controller.isLoadingMore.value ? 1 : 0),

                itemBuilder: (context, index) {


                  if (index >= songs.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.pink,
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  }

                  final song = songs[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      onTap: () {
                        homeController.addRecent(song);
                        controller.playSong(song);
                        Get.to(() => TrackScreen(song: song));
                      },


                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.music_note),
                        ),
                      ),


                      title: Text(
                        song.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.pink.shade700,
                        ),
                      ),


                      subtitle: Text(song.artist),


                      trailing: Obx(() {
                        final isLiked = controller.isLiked(song);

                        return IconButton(
                          icon: Icon(
                            isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isLiked ? Colors.pink : Colors.grey,
                          ),
                          onPressed: () {
                            controller.toggleLike(song);
                          },
                        );
                      }),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _shimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.pink.shade100,
      highlightColor: Colors.pink.shade50,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(width: 50, height: 50, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 120, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(height: 10, width: 80, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}