import 'package:flutter/foundation.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_repository.dart';

class FolderDetailsController extends ChangeNotifier {
  FolderDetailsController(
    this._fileRepository,
    this._folderRepository, {
    required this.id,
  }) {
    _loadFiles();
  }

  final FileRepository _fileRepository;
  final FolderRepository _folderRepository;
  final String id;

  FolderModel? _folder;

  List<FileModel> _files = [];
  List<FileModel> get files => _files;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  Future<void> _loadFiles() async {
    _loading = true;
    notifyListeners();

    try {
      // load folder if not available
      _folder ??= await _folderRepository.get(id);

      _files = await _fileRepository.getPage(
        // TODO: replace with values from folder
        type: FileTypeQuery.photo,
        searchTerm: _folder!.name,
      );
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
