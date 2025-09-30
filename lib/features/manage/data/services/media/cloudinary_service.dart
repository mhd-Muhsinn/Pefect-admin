import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:perfect_super_admin/core/constants/cloundinary.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/core/utils/snackbar_helper.dart';
import 'package:perfect_super_admin/features/manage/presentation/blocs/bloc/course_bloc.dart';
import 'dart:convert';

import 'package:perfect_super_admin/features/manage/presentation/cubits/course_thumbnail_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_video_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/cubit/course_selection_state_cubit.dart';

class CloudinaryService {
  String cloudName = Cloudinary.cloudName;
  String uploadPreset = Cloudinary.uploadPreset;
  String apiSecret = Cloudinary.apiSecret;
  String apikey = Cloudinary.apiKey;

  Future<Map<String, dynamic>?> uploadFile(File file,
      {bool isVideo = false}) async {
    final mediaType = isVideo ? 'video' : 'image';
    final uploadUrl = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/$mediaType/upload',
    );

    try {
      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = 'course_videos'
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final res = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        //check all other status code. handle all the cases
        final responseData = json.decode(res.body);
        return responseData;
      } else {
        return null;
        
      }
    } catch (e) {
      print("Exception during Cloudinary upload: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateFile({
    required File newFile,
    required String oldPublicId,
    required bool isVideo,
  }) async {
    // First delete the old file
    await deleteFile(oldPublicId, isVideo: isVideo);

    // Upload the new file
    return await uploadFile(newFile, isVideo: isVideo);
  }

  // DELETE by public_id using Admin API
  Future<void> deleteFile(String publicId, {bool isVideo = false}) async {
    final mediaType = isVideo ? 'video' : 'image';
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    try {
      final String signatureString =
          'public_id=$publicId&timestamp=$timestamp$apiSecret';
      final signature = sha1.convert(utf8.encode(signatureString)).toString();

      final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/$mediaType/destroy');

      final response = await http.post(url, body: {
        'public_id': publicId,
        'api_key': apikey,
        'timestamp': timestamp.toString(),
        'signature': signature,
        'resource_type': mediaType
      });
      if (response.statusCode == 200) {
        // Success
      } else if (response.statusCode == 400) {
        // Handle bad request
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Handle auth error
      } else if (response.statusCode == 404) {
        // Handle not found
      } else {
        // Handle other errors
      }
    } catch (e) {
      return;
    }
  }
}

void submit(
    BuildContext context,
    TextEditingController _nameController,
    TextEditingController _priceController,
    TextEditingController _descController) {
  final size = ResponsiveConfig(context);
  final thumbnail = context.read<CourseThumbnailCubit>().state;
  final videos = context.read<CourseVideosCubit>().state;
  final category = context.read<CourseSelectionCubit>().state.category;
  final subCategory = context.read<CourseSelectionCubit>().state.subCategory;
  final subSubCategory = context.read<CourseSelectionCubit>().state.subSubCategory;
  final language = context.read<CourseSelectionCubit>().state.language;
  final courseType = context.read<CourseSelectionCubit>().state.courseType;

  if (thumbnail == null) {
    showCustomSnackbar(
        context: context,
        message: 'Add thumbnail',
        size: size,
        backgroundColor: PColors.error);
    return;
  }
  if (videos.isEmpty) {
    showCustomSnackbar(
        context: context,
        message: 'Add atleast 1 video ',
        size: size,
        backgroundColor: PColors.error);
    return;
  }

  context.read<CourseBloc>().add(CreateCourseEvent(
        name: _nameController.text,
        description: _descController.text,
        price: _priceController.text,
        thumbnail: thumbnail,
        category: category!,
        subCategory: subCategory!,
        subSubCategory: subSubCategory!,
        language: language!,
        coursetype: courseType!,
        videos: videos
            .map((v) => {
                  'title': v.title,
                  'description': v.description,
                  'file': v.file,
                })
            .toList(),
      ));
}
