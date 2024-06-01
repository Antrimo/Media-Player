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
  bool _isPlaying = false;

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
      looping: false,
      autoInitialize: true,
    );

    setState(() {
      _isPlaying = _controller!.value.isPlaying;
      _controller!.addListener(() {
        setState(() {
          _isPlaying = _controller!.value.isPlaying;
        });
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _videoPath == null
                  ? ElevatedButton(
                      onPressed: _pickVideo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Pick Video'),
                    )
                  : _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                      ? Column(
                          children: [
                            AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: Chewie(controller: _chewieController!),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPlaying ? _controller!.pause() : _controller!.play();
                                      _isPlaying = !_isPlaying;
                                    });
                                  },
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  icon: const Icon(
                                    Icons.stop,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    _controller!.seekTo(Duration.zero);
                                    _controller!.pause();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Colors.blue,
                                backgroundColor: Colors.white,
                                bufferedColor: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_controller!.value.position),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  _formatDuration(_controller!.value.duration),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
