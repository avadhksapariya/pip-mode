import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ScreenYoutubePlayer extends StatefulWidget {
  const ScreenYoutubePlayer({super.key});

  @override
  State<ScreenYoutubePlayer> createState() => _ScreenYoutubePlayerState();
}

class _ScreenYoutubePlayerState extends State<ScreenYoutubePlayer> {
  String videoId = 'LCI2OZiV5UQ';
  // Youtube video full URL : https://youtu.be/LCI2OZiV5UQ?si=rPEuk2MLSC0Fm2gX

  late YoutubePlayerController ctYoutubePlayer;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    ctYoutubePlayer = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    ctYoutubePlayer.addListener(() {
      if (ctYoutubePlayer.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = ctYoutubePlayer.value.isFullScreen;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        setState(() {
          isFullScreen = false;
        });
      },
      player: YoutubePlayer(controller: ctYoutubePlayer, liveUIColor: Colors.amber, showVideoProgressIndicator: true),
      builder: (context, player) {
        return Scaffold(body: Padding(padding: const EdgeInsets.all(20.0), child: ListView(children: [player])));
      },
    );
  }
}
