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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<FileModel> _files = [];
  List<FileModel> get files => _files;

  Future<void> _loadFiles() async {
    _isLoading = true;
    notifyListeners();

    // load folder if not available
    _folder ??= await _folderRepository.get(id);

    // TODO: replace with values from folder
    _files = await _fileRepository.getPage(
      type: FileTypeQuery.video,
      searchTerm: _folder!.name,
    );

    _isLoading = false;
    notifyListeners();
  }
}
