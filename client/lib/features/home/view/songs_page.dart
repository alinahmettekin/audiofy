import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs = ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  hexToColor(currentSong.hex_code),
                  Pallete.transparentColor,
                ],
                stops: const [0.0, 0.3],
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 36),
            child: SizedBox(
              height: 280,
              child: GridView.builder(
                itemCount: recentlyPlayedSongs.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final song = recentlyPlayedSongs[index];

                  return GestureDetector(
                    onTap: () => ref.read(currentSongNotifierProvider.notifier).updateSong(song),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Pallete.borderColor,
                      ),
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(song.thumbnail_url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              maxLines: 1,
                              song.song_name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Latest Page',
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
            ),
          ),
          ref.watch(getAllSongsProvider).when(
                data: (songs) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return GestureDetector(
                          onTap: () {
                            ref.read(currentSongNotifierProvider.notifier).updateSong(song);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(songs[index].thumbnail_url),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    maxLines: 1,
                                    song.song_name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    maxLines: 1,
                                    song.artist,
                                    style: const TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, st) {
                  return Center(
                    child: Text(error.toString()),
                  );
                },
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
