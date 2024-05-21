import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

class LocalMusicPlayer extends StatefulWidget {
  const LocalMusicPlayer({super.key});

  @override
  _LocalMusicPlayerState createState() => _LocalMusicPlayerState();
}

class _LocalMusicPlayerState extends State<LocalMusicPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioPath;
  bool _isPlaying = false;

  Future<void> _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioPath = result.files.single.path;
      });
      _playAudio(_audioPath!);
    }
  }

  Future<void> _playAudio(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _resumeAudio() async {
    await _audioPlayer.resume();
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _audioPath == null
                ? ElevatedButton(
                    onPressed: _pickAudio,
                    child: const Text('Pick Audio'),
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _isPlaying ? _pauseAudio : _resumeAudio,
                        child: Text(_isPlaying ? 'Pause' : 'Play'),
                      ),
                      ElevatedButton(
                        onPressed: _stopAudio,
                        child: const Text('Stop'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
