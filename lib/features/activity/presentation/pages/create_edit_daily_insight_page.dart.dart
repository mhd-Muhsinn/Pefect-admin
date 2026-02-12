import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../core/enums/media_type.dart';
import '../../../../core/utils/id_generator.dart';
import '../../data/models/daily_insight_model.dart';
import '../blocs/acitivity/activity_bloc.dart';
import '../blocs/acitivity/activity_event.dart';
import '../blocs/acitivity/activity_state.dart';
import '../blocs/media/media_bloc.dart';
import '../blocs/media/media_event.dart';
import '../blocs/media/media_state.dart';

class CreateEditDailyInsightPage extends StatefulWidget {
  final String courseId;
  final String createdBy;
  final DailyInsightModel? insight;

  const CreateEditDailyInsightPage({
    super.key,
    required this.courseId,
    required this.createdBy,
    this.insight,
  });

  @override
  State<CreateEditDailyInsightPage> createState() =>
      _CreateEditDailyInsightPageState();
}

class _CreateEditDailyInsightPageState
    extends State<CreateEditDailyInsightPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _youtubeController;
  late final TextEditingController _externalLinkController;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  File? pdfFile; // newly selected
  Map<String, dynamic>? existingPdf; // from insight (Cloudinary)
  bool removePdf = false;

  // Audio
  File? audioFile;
  Map<String, dynamic>? existingAudio;
  bool removeAudio = false;

  Map<String, dynamic>? uploadedPdf;
  Map<String, dynamic>? uploadedAudio;

  bool get isEdit => widget.insight != null;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.insight?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.insight?.description ?? '');
    _youtubeController =
        TextEditingController(text: widget.insight?.youtubeUrl ?? '');
    _externalLinkController =
        TextEditingController(text: widget.insight?.externalLink ?? '');
    existingPdf = widget.insight?.pdf;
    existingAudio = widget.insight?.audioNote;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _youtubeController.dispose();
    _externalLinkController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ------------------ FILE PICKERS ------------------
  Map<String, dynamic>? _resolvePdf() {
    if (removePdf) return null; // user explicitly removed
    if (uploadedPdf != null) return uploadedPdf; // user replaced
    return existingPdf; // keep old
  }

  Map<String, dynamic>? _resolveAudio() {
    if (removeAudio) return null;
    if (uploadedAudio != null) return uploadedAudio;
    return existingAudio;
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    setState(() => pdfFile = File(result.files.single.path!));
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result == null) return;

    setState(() => audioFile = File(result.files.single.path!));
  }

  // ------------------ PREVIEW ------------------

  Future<void> _previewPdf() async {
    if (pdfFile == null) return;

    await OpenFilex.open(pdfFile!.path);
  }

  Future<void> _toggleRemoteAudio(String url) async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _toggleLocalAudio() async {
    if (audioFile == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setFilePath(audioFile!.path);
      await _audioPlayer.play();
    }

    setState(() => _isPlaying = !_isPlaying);
  }

  // ------------------ SUBMIT ------------------

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    bool hasUpload = false;

    // Upload new PDF (replace or add)
    if (pdfFile != null) {
      hasUpload = true;
      context.read<MediaBloc>().add(
            UploadMediaEvent(
              file: pdfFile!,
              type: MediaType.pdf,
              name: path.basename(pdfFile!.path),
            ),
          );
    }

    // Upload new Audio (replace or add)
    if (audioFile != null) {
      hasUpload = true;
      context.read<MediaBloc>().add(
            UploadMediaEvent(
              file: audioFile!,
              type: MediaType.audio,
            ),
          );
    }

    // If nothing to upload → proceed directly
    if (!hasUpload) {
      _finalizeEditOrCreate();
    }
  }

  void _finalizeEditOrCreate() {
    // Delete existing PDF if removed or replaced
    if (removePdf && existingPdf != null) {
      context.read<MediaBloc>().add(
            DeleteMediaEvent(
              publicId: existingPdf!['publicId'],
              type: MediaType.pdf,
            ),
          );
    }

    // Delete existing Audio if removed or replaced
    if (removeAudio && existingAudio != null) {
      context.read<MediaBloc>().add(
            DeleteMediaEvent(
              publicId: existingAudio!['publicId'],
              type: MediaType.audio,
            ),
          );
    }

    _createOrUpdateInsight();
  }

  void _createOrUpdateInsight() {
    final insight = DailyInsightModel(
      id: widget.insight?.id ?? IdGenerator.uuid(),
      courseId: widget.courseId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      youtubeUrl: _youtubeController.text.trim().isEmpty
          ? null
          : _youtubeController.text.trim(),
      externalLink: _externalLinkController.text.trim().isEmpty
          ? null
          : _externalLinkController.text.trim(),

      // 🔥 FIX IS HERE
      pdf: _resolvePdf(),
      audioNote: _resolveAudio(),

      createdBy: widget.createdBy,
      createdAt: widget.insight?.createdAt ?? DateTime.now(),
    );

    context.read<ActivityBloc>().add(
          isEdit
              ? UpdateDailyInsightEvent(insight)
              : CreateDailyInsightEvent(insight),
        );
  }

  bool _allUploadsDone() {
    if (pdfFile != null && uploadedPdf == null) return false;
    if (audioFile != null && uploadedAudio == null) return false;
    return true;
  }

  // ------------------ BUILD ------------------

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MediaBloc, MediaState>(
          listener: (context, state) {
            if (state is MediaUploadSuccess) {
              if (state.media.type == MediaType.pdf) {
                uploadedPdf = {
                  'url': state.media.url,
                  'publicId': state.media.publicId,
                  'name': state.media.name,
                };
              } else {
                uploadedAudio = {
                  'url': state.media.url,
                  'publicId': state.media.publicId,
                };
              }

              if (_allUploadsDone()) {
                _createOrUpdateInsight();
              }
            }
          },
        ),
        BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state is ActivitySuccess) {
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Edit Daily Insight' : 'Create Daily Insight'),
        ),
        body: _buildForm(),
      ),
    );
  }

  // ------------------ UI ------------------

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(_titleController, 'Title'),
          _field(_descriptionController, 'Description', max: 4),
          _field(
            _youtubeController,
            'YouTube link (optional)',
            onChanged: (_) => setState(() {}),
          ),
          _youtubePreview(),
          _field(_externalLinkController, 'External link (optional)'),
          const SizedBox(height: 16),
          _mediaTile(
            label: 'PDF',
            value: pdfFile != null
                ? path.basename(pdfFile!.path)
                : existingPdf != null
                    ? existingPdf!['name']
                    : null,
            onAdd: _pickPdf,
            onPreview: pdfFile != null
                ? _previewPdf
                : existingPdf != null
                    ? () => {}
                    : null,
            onRemove: () {
              setState(() {
                pdfFile = null;
                removePdf = true;
                existingPdf = null;
              });
            },
          ),
          _mediaTile(
            label: 'Audio',
            value: audioFile != null
                ? 'New audio selected'
                : existingAudio != null
                    ? 'Existing audio'
                    : null,
            onAdd: _pickAudio,
            onPreview: audioFile != null
                ? _toggleLocalAudio
                : existingAudio != null
                    ? () => _toggleRemoteAudio(existingAudio!['url'])
                    : null,
            previewIcon: _isPlaying ? Icons.pause : Icons.play_arrow,
            onRemove: () {
              _audioPlayer.stop();
              setState(() {
                audioFile = null;
                removeAudio = true;
                existingAudio = null;
                _isPlaying = false;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            child: Text(isEdit ? 'Update Insight' : 'Create Insight'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    int max = 1,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLines: max,
        onChanged: onChanged,
        validator: (v) =>
            v == null || v.trim().isEmpty ? '$label required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _mediaTile({
    required String label,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
    VoidCallback? onPreview,
    IconData previewIcon = Icons.visibility,
    String? value,
  }) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(value ?? 'Not selected'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onPreview != null)
              IconButton(
                icon: Icon(previewIcon),
                onPressed: onPreview,
              ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
            if (value != null)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: onRemove,
              ),
          ],
        ),
      ),
    );
  }

  Widget _youtubePreview() {
    final link = _youtubeController.text.trim();
    if (link.isEmpty) return const SizedBox.shrink();

    final videoId = _extractYoutubeId(link);
    if (videoId == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: YoutubePlayer(
        controller: YoutubePlayerController.fromVideoId(
          videoId: videoId,
          params: const YoutubePlayerParams(
              showControls: true,
              showFullscreenButton: true,
              origin: 'https://www.youtube-nocookie.com'),
        ),
        aspectRatio: 16 / 9,
      ),
    );
  }

  String? _extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // youtu.be/<id>
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    // youtube.com/watch?v=<id>
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'];
    }

    // youtube.com/embed/<id>
    if (uri.pathSegments.contains('embed')) {
      final index = uri.pathSegments.indexOf('embed');
      return uri.pathSegments.length > index + 1
          ? uri.pathSegments[index + 1]
          : null;
    }

    return null;
  }
}
