import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPlayerContainer extends StatefulWidget {
  final File? file;
  final String? videoUrl;
  final double height;
  final double width;

  const VideoPlayerContainer({
    Key? key,
    this.file,
    this.videoUrl,
    this.height = 200,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  State<VideoPlayerContainer> createState() => _VideoPlayerContainerState();
}

class _VideoPlayerContainerState extends State<VideoPlayerContainer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

   if (widget.file != null) {
      _controller = VideoPlayerController.file(widget.file!);
    }else if (widget.videoUrl != null) {
      _controller = VideoPlayerController.network(widget.videoUrl!);
    } 

    _controller?.initialize().then((_) {
      setState(() {});
      _controller?.play(); // Auto-play
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Container(
    height: widget.height,
    width: widget.width,
    color: Colors.transparent,

    child: _controller != null && _controller!.value.isInitialized
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
              VideoProgressIndicator(
                _controller!,
                allowScrubbing: true,
                padding: const EdgeInsets.all(8),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
              
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_10, color: Colors.white),
                      onPressed: () {
                        final currentPosition =
                            _controller!.value.position.inSeconds;
                        _controller!.seekTo(
                          Duration(seconds: currentPosition - 10),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _controller!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_10, color: Colors.white),
                      onPressed: () {
                        final currentPosition =
                            _controller!.value.position.inSeconds;
                        _controller!.seekTo(
                          Duration(seconds: currentPosition + 10),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator()),
  );
}

}
