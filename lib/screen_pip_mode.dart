import 'package:file_picker/file_picker.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:pip_mode/widget_video_player.dart';

class ScreenPipMode extends StatefulWidget {
  const ScreenPipMode({super.key});

  @override
  State<ScreenPipMode> createState() => _ScreenPipModeState();
}

class _ScreenPipModeState extends State<ScreenPipMode> with WidgetsBindingObserver {
  String videoUrl = /*"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"*/ "";

  late Floating pip;
  bool isPipAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pip = Floating();
    checkPiPAvailability();
  }

  /*@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden && isPipAvailable) {
      pip.enable(ImmediatePiP(aspectRatio: Rational.landscape()));
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenEnabled:
          videoUrl.isNotEmpty ? WidgetVideoPlayer(videoUrl: videoUrl) : const Center(child: Text("No video selected")),
      childWhenDisabled: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20.0,
              children: [
                videoUrl.isNotEmpty
                    ? Expanded(child: WidgetVideoPlayer(videoUrl: videoUrl))
                    : const Center(child: Text("Pick a video to play")),
                ElevatedButton(onPressed: pickVideoFile, child: Text("Pick video from device")),
                ElevatedButton(
                  onPressed: () {
                    if (isPipAvailable) {
                      pip.enable(ImmediatePiP(aspectRatio: Rational.landscape()));
                    }
                  },
                  child: Text(isPipAvailable ? "Enable PIP" : "PIP not available"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkPiPAvailability() async {
    isPipAvailable = await pip.isPipAvailable;
    setState(() {});
  }

  Future<void> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video, allowMultiple: false);
    if (result != null) {
      setState(() {
        videoUrl = result.files.single.path!;
      });
    }
  }
}
