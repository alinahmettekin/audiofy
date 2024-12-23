import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController _playerController = PlayerController();

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  void initAudioPlayer() async {
    await _playerController.preparePlayer(path: widget.path);
  }

  Future<void> playAndPasue() async {
    if (!_playerController.playerState.isPlaying) {
      await _playerController.startPlayer(forceRefresh: true);
    } else if (!_playerController.playerState.isPaused) {
      await _playerController.pausePlayer();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAndPasue,
          icon: Icon(
            _playerController.playerState.isPlaying ? CupertinoIcons.pause_solid : CupertinoIcons.play_arrow_solid,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Pallete.borderColor,
              liveWaveColor: Pallete.gradient2,
              spacing: 6,
              showSeekLine: false,
            ),
            playerController: _playerController,
            size: const Size(double.infinity, 100),
          ),
        ),
      ],
    );
  }
}
