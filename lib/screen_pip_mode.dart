import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:pip_mode/widget_video_player.dart';

class ScreenPipMode extends StatefulWidget {
  const ScreenPipMode({super.key});

  @override
  State<ScreenPipMode> createState() => _ScreenPipModeState();
}

class _ScreenPipModeState extends State<ScreenPipMode> with WidgetsBindingObserver {
  final String videoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";

  late Floating pip;
  bool isPipAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pip = Floating();
    checkPiPAvailability();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden && isPipAvailable) {
      pip.enable(ImmediatePiP(aspectRatio: Rational.landscape()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenEnabled: WidgetVideoPlayer(videoUrl: videoUrl),
      childWhenDisabled: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              WidgetVideoPlayer(videoUrl: videoUrl),
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
    );
  }

  Future<void> checkPiPAvailability() async {
    isPipAvailable = await pip.isPipAvailable;
    setState(() {});
  }
}
