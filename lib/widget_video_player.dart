import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WidgetVideoPlayer extends StatefulWidget {
  const WidgetVideoPlayer({super.key, required this.videoUrl, this.startPosition});

  final String videoUrl;
  final int? startPosition;

  @override
  State<WidgetVideoPlayer> createState() => WidgetVideoPlayerState();
}

class WidgetVideoPlayerState extends State<WidgetVideoPlayer> {
  late VideoPlayerController ctVideoPlayer;
  bool onTouch = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    ctVideoPlayer = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((value) {
        if (widget.startPosition != null) {
          ctVideoPlayer.seekTo(Duration(milliseconds: widget.startPosition!));
        }
        ctVideoPlayer.play();
        setState(() {
          onTouch = true;
        });

        setTimer();
      });
  }

  @override
  void dispose() {
    super.dispose();
    ctVideoPlayer.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ctVideoPlayer.value.isInitialized
        ? GestureDetector(
          onTap: () {
            setState(() {
              onTouch = true;
            });

            setTimer();
          },
          child: AspectRatio(
            aspectRatio: ctVideoPlayer.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(key: UniqueKey(), ctVideoPlayer),
                Visibility(
                  visible: onTouch,
                  child: Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: togglePlayPause,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                            child: Icon(
                              ctVideoPlayer.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
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
          ),
        )
        : Center(child: CircularProgressIndicator());
  }

  void setTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        onTouch = false;
      });
    });
    setState(() {});
  }

  void togglePlayPause() {
    timer?.cancel();

    setState(() {
      ctVideoPlayer.value.isPlaying ? ctVideoPlayer.pause() : ctVideoPlayer.play();
    });

    setTimer();
  }

  int getCurrentPosition() {
    return ctVideoPlayer.value.position.inMilliseconds;
  }
}
