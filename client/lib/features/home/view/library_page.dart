import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getFavSongsProvider).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UploadSongPage(),
                    )),
                    title: const Text(
                      "Upload New Song",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    leading: const CircleAvatar(
                      radius: 35,
                      backgroundColor: Pallete.backgroundColor,
                      child: Icon(CupertinoIcons.plus),
                    ),
                  );
                }
                final song = data[index];
                return ListTile(
                  onTap: () => ref.read(currentSongNotifierProvider.notifier).updateSong(song),
                  title: Text(
                    song.song_name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    song.song_name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundColor: Pallete.backgroundColor,
                    backgroundImage: NetworkImage(
                      song.thumbnail_url,
                    ),
                  ),
                );
              },
            );
          },
          error: (error, st) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => const Loader(),
        );
  }
}
