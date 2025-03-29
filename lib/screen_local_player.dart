import 'package:file_picker/file_picker.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:pip_mode/widget_video_player.dart';

class ScreenLocalPlayer extends StatefulWidget {
  const ScreenLocalPlayer({super.key});

  @override
  State<ScreenLocalPlayer> createState() => _ScreenLocalPlayerState();
}

class _ScreenLocalPlayerState extends State<ScreenLocalPlayer> {
  String videoUrl = "";
  late Floating pip;
  bool isPipAvailable = false;

  @override
  void initState() {
    super.initState();
    pickVideoFile();
    pip = Floating();
    checkPiPAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenEnabled:
          videoUrl.isNotEmpty ? WidgetVideoPlayer(videoUrl: videoUrl) : const Center(child: Text("No video selected")),
      childWhenDisabled: Scaffold(
        appBar: AppBar(
          title: Text("Local Player"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple.shade400,
        ),
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
    videoUrl.isNotEmpty ? await FilePicker.platform.clearTemporaryFiles() : null;
    final result = await FilePicker.platform.pickFiles(type: FileType.video, allowMultiple: false);
    if (result != null) {
      setState(() {
        videoUrl = result.files.single.path!;
      });
    }
  }
}
