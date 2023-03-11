import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class SoundDetector extends StatefulWidget {
  const SoundDetector({super.key});

  @override
  State<SoundDetector> createState() => _SoundDetectorState();
}

class _SoundDetectorState extends State<SoundDetector> {
  Record myRecording = Record();
  Timer? timer;

  double volume = 0.0;
  double minVolume = -45.0;

  startTimer() async {
    timer ??= Timer.periodic(
        const Duration(milliseconds: 50), ((timer) => updateVolume()));
  }

  updateVolume() async {
    Amplitude amplitude = await myRecording.getAmplitude();
    if (amplitude.current > minVolume) {
      setState(() {
        volume = (amplitude.current - minVolume) / minVolume;
      });
      print("VOLUME: $volume");
    }
  }

  int volume0to(int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }

  Future<bool> startRecording() async {
    if (await myRecording.hasPermission()) {
      if (!await myRecording.isRecording()) {
        await myRecording.start();
      }
      startTimer();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: startRecording(),
      builder: ((context, AsyncSnapshot<bool> snapshot) {
        return Scaffold(
          body: Center(
              child: Text(
                  snapshot.hasData ? volume0to(200).toString() : "NO DATA")),
        );
      }),
    );
  }
}
