import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../data/models/daily_insight_model.dart';
import '../blocs/acitivity/activity_bloc.dart';
import '../blocs/acitivity/activity_event.dart';
import 'create_edit_daily_insight_page.dart.dart';


class DailyInsightDetailPage extends StatefulWidget {
  final DailyInsightModel insight;

  const DailyInsightDetailPage({
    super.key,
    required this.insight,
  });

  @override
  State<DailyInsightDetailPage> createState() =>
      _DailyInsightDetailPageState();
}

class _DailyInsightDetailPageState extends State<DailyInsightDetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // -------------------- ADMIN ACTIONS --------------------

  void _editInsight() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateEditDailyInsightPage(
          courseId: widget.insight.courseId,
          createdBy: widget.insight.createdBy,
          insight: widget.insight,
        ),
      ),
    );
  }

  void _deleteInsight() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Insight'),
        content: const Text(
          'Are you sure you want to delete this daily insight?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ActivityBloc>().add(
                    DeleteDailyInsightEvent(
                      courseId: widget.insight.courseId,
                      insightId: widget.insight.id,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- MEDIA --------------------

Future<void> _openPdf() async {
  final url = widget.insight.pdf?['url'];
  if (url == null) return;

  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}


  Future<void> _toggleAudio() async {
    final url = widget.insight.audioNote?['url'];
    if (url == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    }

    setState(() => _isPlaying = !_isPlaying);
  }

  String? _extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'];
    }

    if (uri.pathSegments.contains('embed')) {
      final index = uri.pathSegments.indexOf('embed');
      return uri.pathSegments.length > index + 1
          ? uri.pathSegments[index + 1]
          : null;
    }

    return null;
  }

  // -------------------- BUILD --------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Insight'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') _editInsight();
              if (value == 'delete') _deleteInsight();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            const SizedBox(height: 12),
            _description(),
            const SizedBox(height: 16),
            _youtubeSection(),
            const SizedBox(height: 16),
            _pdfSection(),
            const SizedBox(height: 12),
            _audioSection(),
            const SizedBox(height: 12),
            _externalLink(),
          ],
        ),
      ),
    );
  }

  // -------------------- UI SECTIONS --------------------

  Widget _title() {
    return Text(
      widget.insight.title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _description() {
    return Text(
      widget.insight.description,
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _youtubeSection() {
    final link = widget.insight.youtubeUrl;
    if (link == null || link.isEmpty) {
      return const SizedBox.shrink();
    }

    final videoId = _extractYoutubeId(link);
    if (videoId == null) return const SizedBox.shrink();

    return YoutubePlayer(
      controller: YoutubePlayerController.fromVideoId(
        videoId: videoId,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          origin: 'https://www.youtube-nocookie.com'
        ),
      ),
      aspectRatio: 16 / 9,
    );
  }

  Widget _pdfSection() {
    final pdf = widget.insight.pdf;
    if (pdf == null) return const SizedBox.shrink();

    return ListTile(
      leading: const Icon(Icons.picture_as_pdf),
      title: Text(pdf['name'] ?? 'View PDF'),
      trailing: const Icon(Icons.open_in_new),
      onTap: _openPdf,
    );
  }

  Widget _audioSection() {
    if (widget.insight.audioNote == null) {
      return const SizedBox.shrink();
    }

    return ListTile(
      leading: const Icon(Icons.audiotrack),
      title: const Text('Audio Note'),
      trailing: Icon(
        _isPlaying ? Icons.pause : Icons.play_arrow,
      ),
      onTap: _toggleAudio,
    );
  }

  Widget _externalLink() {
    final link = widget.insight.externalLink;
    if (link == null || link.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListTile(
      leading: const Icon(Icons.link),
      title: const Text('Open External Link'),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}
