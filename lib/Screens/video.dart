import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  const LocalVideoPlayer({super.key});

  @override
  _LocalVideoPlayerState createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  String? _videoPath;

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _videoPath = result.files.single.path;
      });
      _initializePlayer(_videoPath!);
    }
  }

  Future<void> _initializePlayer(String path) async {
    _controller = VideoPlayerController.file(File(path));
    await _controller!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      aspectRatio: _controller!.value.aspectRatio,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _videoPath == null
            ? ElevatedButton(
                onPressed: _pickVideo,
                child: const Text('Pick Video'),
              )
            : _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController!,
                  )
                : const CircularProgressIndicator(),
      ),
    );
  }
}
