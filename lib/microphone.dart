import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SoundDetector {
  late NoiseMeter noiseMeter;
  late StreamSubscription<NoiseReading> noiseSubscription;
  final recorder = FlutterSoundRecorder();
  final audioplayer = AudioPlayer();
  var path1;
  var audioFile;
  bool isRecording = false;
  double dbLevel = 0;

  void accessMicrophone() {
    noiseMeter = NoiseMeter();
  }

  void destroyMcrophone() {
    recorder.closeRecorder();
    audioplayer.dispose();
    noiseSubscription.cancel();
  }

  void startListening() {
    noiseSubscription =
        noiseMeter.noiseStream.listen((NoiseReading noiseReading) {});
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

  Future startRecording() async {
    final file = await _localFile;

    await recorder.openRecorder();
    await recorder.startRecorder(toFile: file.path);
  }

  Future stopRecording() async {
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
}
