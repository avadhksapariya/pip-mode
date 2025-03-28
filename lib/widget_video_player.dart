import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WidgetVideoPlayer extends StatefulWidget {
  const WidgetVideoPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<WidgetVideoPlayer> createState() => _WidgetVideoPlayerState();
}

class _WidgetVideoPlayerState extends State<WidgetVideoPlayer> {
  late VideoPlayerController ctVideoPlayer;

  @override
  void initState() {
    super.initState();
    ctVideoPlayer = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((value) {
        ctVideoPlayer.setLooping(true);
        ctVideoPlayer.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    ctVideoPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ctVideoPlayer.value.isInitialized
        ? AspectRatio(
          aspectRatio: ctVideoPlayer.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(key: UniqueKey(), ctVideoPlayer),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(ctVideoPlayer, allowScrubbing: true, padding: EdgeInsets.zero),
              ),
            ],
          ),
        )
        : Center(child: CircularProgressIndicator());
  }
}
