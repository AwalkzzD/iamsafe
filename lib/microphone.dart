import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SoundDetector extends StatefulWidget {
  const SoundDetector({super.key});

  @override
  State<SoundDetector> createState() => _SoundDetectorState();
}

class _SoundDetectorState extends State<SoundDetector> {
  late NoiseMeter _noiseMeter;
  late StreamSubscription<NoiseReading> _noiseSubscription;
  final recorder = FlutterSoundRecorder();
  final audioplayer = AudioPlayer();
  var path1;
  var audioFile;
  bool isRecording = false;
  double _dbLevel = 0;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter();
    _startListening();
  }

  void _startListening() {
    _noiseSubscription =
        _noiseMeter.noiseStream.listen((NoiseReading noiseReading) {
      setState(() {
        _dbLevel = noiseReading.meanDecibel;
      });
    });
  }

  Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory =
        (await getExternalStorageDirectories(type: StorageDirectory.downloads))!
            .first;
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/samplerecording');
  }

  Future _startRecording() async {
    final file = await _localFile;

    await recorder.openRecorder();
    await recorder.startRecorder(toFile: file.path);

    if (_dbLevel > 80) {
      _stopRecording();
    }
  }

  Future _stopRecording() async {
    path1 = await recorder.stopRecorder();
    audioFile = File(path1!);

    print('Recorded audio: $audioFile');

    final Email email = Email(
      body: 'Test email 1',
      subject: 'Test Email',
      recipients: ['devarshi566@gmail.com'],
      cc: ['21ituod004@ddu.ac.in'],
      attachmentPaths: [path1],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  void dispose() {
    super.dispose();
    recorder.closeRecorder();
    audioplayer.dispose();
    _noiseSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Sound Detection"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                "Decibel Level",
                style: TextStyle(fontFamily: "RobotoSlab", fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '$_dbLevel',
                style: const TextStyle(fontSize: 30, fontFamily: "RobotoSlab"),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              if (isRecording == false) {
                _startRecording();
                isRecording = true;
              } else {
                _stopRecording();
                isRecording = false;
              }
            });
          },
        ),
      ),
    );
  }
}
