import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../view_models/controller/music_controller.dart';
import '../../view_models/controller/playlist_controller.dart';
import '../components/mini_song_widget.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final int index;
  PlaylistDetailScreen({required this.index});

  final playlistController = Get.find<PlaylistController>();
  final musicController = Get.find<MusicController>();

  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text(playlistController.playlists[index].name),
      ),

      body: Obx(() {
        final playlist = playlistController.playlists[index];

        return Column(
          children: [

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.5),
                    theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Column(
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: playlist.coverImage.isNotEmpty
                          ? (playlist.coverImage.startsWith("http")
                          ? Image.network(
                        playlist.coverImage,
                        fit: BoxFit.cover,
                      )
                          : File(playlist.coverImage).existsSync()
                          ? Image.file(
                        File(playlist.coverImage),
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.music_note, size: 50))
                          : Icon(Icons.music_note, size: 50),
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    playlist.name,
                    style: theme.textTheme.titleLarge,
                  ),

                  Text("${playlist.songs.length} songs"),

                  SizedBox(height: 10),


                  ElevatedButton.icon(
                    icon: Icon(Icons.play_arrow),
                    label: Text("Play All"),
                    onPressed: () async {
                      if (playlist.songs.isEmpty) return;

                      await musicController.playPlaylist(
                        playlist.songs,
                        0,
                      );

                      musicController.currentSong.refresh();
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: playlist.songs.isEmpty
                  ? Center(child: Text("No songs added"))
                  : ListView.builder(
                itemCount: playlist.songs.length,
                itemBuilder: (context, i) {
                  final song = playlist.songs[i];

                  return ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12),


                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 50,
                        width: 50,

                        child: song.image.isNotEmpty
                            ? (song.image.startsWith("http")

                        /// 🌐 ONLINE IMAGE
                            ? Image.network(
                          song.image,
                          fit: BoxFit.cover,
                        )


                            : File(song.image).existsSync()
                            ? Image.file(
                          File(song.image),
                          fit: BoxFit.cover,
                        )

                        /// 🔥 REAL OFFLINE ARTWORK
                            : QueryArtworkWidget(
                          id: int.tryParse(song.id) ?? 0,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget:
                          Icon(Icons.music_note),
                        ))
                            : QueryArtworkWidget(
                          id: int.tryParse(song.id) ?? 0,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget:
                          Icon(Icons.music_note),
                        ),
                      ),
                    ),

                    title: Text(
                      song.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    subtitle: Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [


                        Obx(() => IconButton(
                          icon: Icon(
                            musicController.currentSong.value?.id ==
                                song.id &&
                                musicController.isPlaying.value
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: () async {
                            await musicController.playPlaylist(
                              playlist.songs,
                              i,
                            );

                            musicController.currentSong.refresh();
                          },
                        )),


                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            playlistController.removeSong(index, i);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// 🎧 MINI PLAYER
            MiniPlayer(),
          ],
        );
      }),
    );
  }
}