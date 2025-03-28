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
              Positioned.fill(
                child: Center(
                  child: GestureDetector(
                    onTap: togglePlayPause,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.5)),
                        child: Icon(
                          ctVideoPlayer.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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

  void togglePlayPause() {
    if (ctVideoPlayer.value.isPlaying) {
      ctVideoPlayer.pause();
    } else {
      ctVideoPlayer.play();
    }
    setState(() {});
  }
}
