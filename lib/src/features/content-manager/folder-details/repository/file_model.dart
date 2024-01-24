import 'package:flutter/foundation.dart';

@immutable
abstract class FileModel {
  const FileModel({
    required this.id,
    required this.height,
    required this.url,
    required this.thumbnail,
    required this.width,
  });

  final int height;
  final int id;
  final Uri thumbnail;
  final Uri url;
  final int width;

  String get filename => url.path.split('/').last;
}

@immutable
class PhotoFileModel extends FileModel {
  const PhotoFileModel._({
    required super.height,
    required super.id,
    required super.url,
    required super.thumbnail,
    required super.width,
  });

  factory PhotoFileModel.fromJson(Map<String, dynamic> json) =>
      PhotoFileModel._(
        height: json['imageHeight'] as int,
        id: json['id'] as int,
        url: Uri.parse(json['largeImageURL'] as String),
        thumbnail: Uri.parse(json['previewURL'] as String),
        width: json['imageWidth'] as int,
      );

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
  });

  factory VideoFileModel.fromJson(Map<String, dynamic> json) =>
      VideoFileModel._(
        duration: Duration(seconds: json['duration'] as int),
        height: _readVideoHeight(json, 'height'),
        id: json['id'] as int,
        thumbnail: Uri.parse(_readPhotoThumbnail(json, 'picture_id')),
        url: Uri.parse(_readVideoUrl(json, 'url')),
        width: _readVideoWidth(json, 'width'),
      );

  final Duration duration;

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
