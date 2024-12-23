import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/music_player.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavorites = ref.watch(currentUserNotifierProvider.select(
      (value) => value!.favorites,
    ));

    if (currentSong != null) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                final tween = Tween(begin: Offset(0, 1), end: Offset.zero).chain(
                  CurveTween(curve: Curves.easeIn),
                );

                final offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) {
                return const MusicPlayer();
              },
            ),
          );
        },
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 66,
              width: MediaQuery.of(context).size.width - 16,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor(currentSong.hex_code),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'music-image',
                        child: Container(
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(currentSong.thumbnail_url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Pallete.subtitleText,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await ref.read(homeViewModelProvider.notifier).favSong(songId: currentSong.id);
                        },
                        icon: Icon(
                          userFavorites.where((element) => element.song_id == currentSong.id).toList().isNotEmpty
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => songNotifier.playPause(),
                        icon: Icon(
                          songNotifier.isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            StreamBuilder(
              stream: songNotifier.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final position = snapshot.data;
                  final duration = songNotifier.audioPlayer!.duration;
                  double sliderValue = 0.0;
                  if (position != null && duration != null) {
                    sliderValue = (position.inMilliseconds) / (duration.inMilliseconds);
                  }

                  return Positioned(
                    left: 8,
                    bottom: 0,
                    child: Container(
                      width: sliderValue * (MediaQuery.of(context).size.width - 32),
                      height: 2,
                      decoration: BoxDecoration(
                        color: Pallete.whiteColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Positioned(
              left: 8,
              bottom: 0,
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Pallete.inactiveSeekColor,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox(
        child: Text("Hi"),
      );
    }

    // return Container(
    //   height: 60,
    //   color: Colors.black,
    //   child: Row(
    //     children: [
    //       Image.network(
    //         currentSong.thumbnail_url,
    //         width: 50,
    //         height: 50,
    //         fit: BoxFit.cover,
    //       ),
    //       const SizedBox(width: 10),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             currentSong.song_name,
    //             style: const TextStyle(color: Colors.white),
    //           ),
    //           Text(
    //             currentSong.artist,
    //             style: const TextStyle(color: Colors.white),
    //           ),
    //         ],
    //       ),
    //       const Spacer(),
    //       IconButton(
    //         onPressed: () {},
    //         icon: const Icon(
    //           Icons.close,
    //           color: Colors.white,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
