import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:pip_mode/screen_local_player.dart';
import 'package:pip_mode/widget_video_player.dart';

class ScreenPipMode extends StatefulWidget {
  const ScreenPipMode({super.key});

  @override
  State<ScreenPipMode> createState() => _ScreenPipModeState();
}

class _ScreenPipModeState extends State<ScreenPipMode> with WidgetsBindingObserver {
  String videoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";

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
    if (state == AppLifecycleState.hidden && isPipAvailable && mounted) {
      if (ModalRoute.of(context)!.isCurrent) {
        pip.enable(ImmediatePiP(aspectRatio: Rational.landscape()));
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenEnabled: WidgetVideoPlayer(videoUrl: videoUrl),
      childWhenDisabled: Scaffold(
        appBar: AppBar(title: Text("PiP Mode"), foregroundColor: Colors.white, backgroundColor: Colors.purple.shade400),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20.0,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenLocalPlayer()));
          },
          child: Icon(Icons.video_library),
        ),
      ),
    );
  }

  Future<void> checkPiPAvailability() async {
    isPipAvailable = await pip.isPipAvailable;
    setState(() {});
  }
}
