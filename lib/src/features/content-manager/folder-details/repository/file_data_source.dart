import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';

const _kPixabayApiBaseUrl = 'pixabay.com';

abstract interface class FileDataSource {
  Future<List<PhotoFileModel>> searchPhotos({String? searchTerm});

  Future<List<VideoFileModel>> searchVideos({String? searchTerm});
}

/// An implementation of [FolderDataSource] that return static [FolderModel]
/// data.
class PixabayFileDataSource implements FileDataSource {
  final http.Client _pixabayClient;

  PixabayFileDataSource([
    http.Client? pixabayClient,
  ]) : _pixabayClient = pixabayClient ?? http.Client();

  @override
  Future<List<PhotoFileModel>> searchPhotos({
    String? searchTerm,
  }) async {
    final response = await _pixabayClient.get(_buildApiUrl(
      q: searchTerm,
    ));

    final data = _PixabayPageResponse.fromJson(json.decode(response.body));
    return data.hits.map((e) => PhotoFileModel.fromJson(e)).toList();
  }

  @override
  Future<List<VideoFileModel>> searchVideos({
    String? searchTerm,
  }) async {
    final response = await _pixabayClient.get(_buildApiUrl(
      path: 'videos',
      q: searchTerm,
    ));

    final data = _PixabayPageResponse.fromJson(json.decode(response.body));
    return data.hits.map((e) => VideoFileModel.fromJson(e)).toList();
  }

  Uri _buildApiUrl({
    String path = '',
    String? q,
  }) {
    return Uri.https(_kPixabayApiBaseUrl, 'api/$path', {
      'key': const String.fromEnvironment('PIXABAY_API_KEY'),
      if (q != null) 'q': q.replaceAll(' ', '+'),
    });
  }
}

@immutable
class _PixabayPageResponse {
  const _PixabayPageResponse({
    required this.total,
    required this.totalHits,
    required this.hits,
  });

  final int total;
  final int totalHits;
  final List<Map<String, dynamic>> hits;

  factory _PixabayPageResponse.fromJson(Map<String, dynamic> json) =>
      _PixabayPageResponse(
        total: json['total'] as int,
        totalHits: json['totalHits'] as int,
        hits: (json['hits'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList(),
      );
}
