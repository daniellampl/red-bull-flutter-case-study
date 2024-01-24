import 'package:flutter/foundation.dart';

enum FolderContentType { photo, video }

@immutable
class FolderModel {
  const FolderModel({
    required this.id,
    required this.name,
    required this.type,
  });

  final String id;
  final String name;
  final FolderContentType type;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FolderModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, type);

  @override
  String toString() {
    return 'FolderModel(id: $id, name: $name, type: $type)';
  }
}
