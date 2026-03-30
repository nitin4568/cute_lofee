import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lofeee/resource/widgets/playlist_details.dart';

import '../../view_models/controller/playlist_controller.dart';

class PlaylistScreen extends StatelessWidget {
  PlaylistScreen({super.key});

  final PlaylistController controller =
  Get.put(PlaylistController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            /// 🔥 HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Your Library",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  /// ➕ CREATE PLAYLIST
                  GestureDetector(
                    onTap: () => _createPlaylist(context),
                    child:  CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  )
                ],
              ),
            ),

            /// 🎵 PLAYLIST LIST
            Expanded(
              child: Obx(() {
                if (controller.playlists.isEmpty) {
                  return  Center(
                    child: Text(
                      "No playlists yet 😢\nCreate one!",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = controller.playlists[index];

                    return ListTile(
                      onTap: () {
                        Get.to(() =>
                            PlaylistDetailScreen(index: index));
                      },

                      /// 🎨 ICON
                      leading: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:Icon(
                          Icons.music_note,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),

                      /// 📁 NAME
                      title: Text(
                        playlist.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      /// 🎵 COUNT
                      subtitle:
                      Text("${playlist.songs.length} songs"),

                      /// ❌ DELETE PLAYLIST
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () {
                          controller.playlists.removeAt(index);
                          controller.savePlaylists();
                        },
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 CREATE PLAYLIST DIALOG
  void _createPlaylist(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            SizedBox(height: 20),

            Text("Create Playlist",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter playlist name",
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;

                controller.createPlaylist(nameController.text.trim());
                Get.back();
              },
              child: Text(
                "Create",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }}
