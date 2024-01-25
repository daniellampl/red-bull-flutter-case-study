import 'dart:math';

import 'package:flutter/foundation.dart';

@immutable
abstract class FileModel {
  const FileModel({
    required this.id,
    required this.height,
    required this.url,
    required this.thumbnail,
    required this.width,
    this.createdAt,
  });

  final DateTime? createdAt;
  final int height;
  final int id;
  final Uri thumbnail;
  final Uri url;
  final int width;

  double get aspectRatio => width / height;
  String get filename;
  String get resolution => '${width}x$height';
}

@immutable
class PhotoFileModel extends FileModel {
  const PhotoFileModel._({
    required super.height,
    required super.id,
    required super.url,
    required super.thumbnail,
    required super.width,
    super.createdAt,
  });

  factory PhotoFileModel.fromJson(Map<String, dynamic> json) {
    return PhotoFileModel._(
      createdAt: _extractDateTime(json['previewURL'] as String),
      height: json['imageHeight'] as int,
      id: json['id'] as int,
      url: Uri.parse(json['largeImageURL'] as String),
      thumbnail: Uri.parse(json['previewURL'] as String),
      width: json['imageWidth'] as int,
    );
  }

  @override
  String get filename => thumbnail.path.split('/').last;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PhotoFileModel &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, height, id, url, thumbnail, width);
}

@immutable
class VideoFileModel extends FileModel {
  const VideoFileModel._({
    required this.duration,
    required super.height,
    required super.id,
    required super.thumbnail,
    required super.url,
    required super.width,
    super.createdAt,
  });

  factory VideoFileModel.fromJson(Map<String, dynamic> json) =>
      VideoFileModel._(
        createdAt: _extractDateTime(json['userImageURL'] as String),
        duration: Duration(seconds: json['duration'] as int),
        height: _readVideoHeight(json, 'height'),
        id: json['id'] as int,
        thumbnail: Uri.parse(_readPhotoThumbnail(json, 'picture_id')),
        url: Uri.parse(_readVideoUrl(json, 'url')),
        width: _readVideoWidth(json, 'width'),
      );

  final Duration duration;

  @override
  String get filename => url.path.split('/').last;

  bool get is4k => _wideSideWidth == 3840 && _shortSideWidth == 2160;
  bool get isFhd => _wideSideWidth == 1920 && _shortSideWidth == 1080;

  int get _wideSideWidth => max(height, width);
  int get _shortSideWidth => min(height, width);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoFileModel &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, duration, height, id, thumbnail, url, width);
}

String _readPhotoThumbnail(Map json, String key) {
  // see https://pixabay.com/api/docs/
  final pictureId = json[key] as String;
  return 'https://i.vimeocdn.com/video/${pictureId}_250x250.jpg';
}

int _readVideoHeight(Map json, String key) {
  return _readVideoValue(json, 'height') as int;
}

int _readVideoWidth(Map json, String key) {
  return _readVideoValue(json, 'width') as int;
}

String _readVideoUrl(Map json, String key) {
  return _readVideoValue(json, 'url') as String;
}

dynamic _readVideoValue(Map json, String key) {
  final videos = json['videos'];

  // the large video is optional -> use medium as fallback
  final large = videos['large'];
  final url = large['url'];
  if (url != null && url != '') {
    return large[key];
  } else {
    final medium = videos['medium'];
    return medium[key];
  }
}

DateTime? _extractDateTime(String url) {
  final regex = RegExp(r'/(\d{4})/(\d{2})/(\d{2})/');
  final match = regex.firstMatch(url);

  if (match != null && match.groupCount >= 3) {
    try {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);

      return DateTime(year, month, day);
    } catch (e) {
      // if something goes wrong. better safe than sorry.
      return null;
    }
  } else {
    return null;
  }
}
