import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavorites = ref.watch(currentUserNotifierProvider.select(
      (value) => value!.favorites,
    ));
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexToColor(currentSong!.hex_code),
            hexToColor(currentSong.hex_code).withValues(alpha: 0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Pallete.transparentColor,
              focusColor: Pallete.transparentColor,
              splashColor: Pallete.transparentColor,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox(height: 15)),
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
                      )
                    ],
                  ),
                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      final position = snapshot.data;
                      final duration = songNotifier.audioPlayer!.duration;
                      double sliderValue = 0.0;
                      if (position != null || duration != null) {
                        sliderValue = (position?.inMilliseconds)! / (duration!.inMilliseconds);
                      }

                      return Column(
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) => SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Pallete.whiteColor,
                                inactiveTrackColor: Pallete.subtitleText.withValues(alpha: 0.117),
                                thumbColor: Pallete.whiteColor,
                                trackHeight: 4,
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value: sliderValue,
                                min: 0,
                                max: 1,
                                onChanged: (value) {
                                  sliderValue = value;
                                },
                                onChangeEnd: songNotifier.seek,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${position?.inMinutes ?? 0}:${(position?.inSeconds ?? 0) < 10 ? '0' : ''}${position?.inSeconds.remainder(60) ?? 0}',
                                style: TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                '${duration?.inMinutes ?? 0}:${(duration?.inSeconds ?? 0) < 10 ? '0' : ''}${duration?.inSeconds.remainder(60) ?? 0}',
                                style: TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/shuffle.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/previus-song.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: songNotifier.playPause,
                        iconSize: 80,
                        icon: Icon(
                          songNotifier.isPlaying ? CupertinoIcons.pause_circle_fill : CupertinoIcons.play_circle_fill,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/next-song.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/repeat.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox(height: 25)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/connect-device.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/playlist.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
