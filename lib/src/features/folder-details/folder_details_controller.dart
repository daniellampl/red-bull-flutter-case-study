import 'package:flutter/foundation.dart';
import 'package:red_bull_flutter_case_study/src/features/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/features/folder-details/repository/file_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/folders/repository/folder_model.dart';
import 'package:red_bull_flutter_case_study/src/features/folders/repository/folder_repository.dart';

const _kItemsPerPage = 25;

class FolderDetailsController extends ChangeNotifier {
  FolderDetailsController(
    this._fileRepository,
    this._folderRepository, {
    required this.id,
    FolderModel? folder,
  }) : _folder = folder {
    load();
  }

  final FileRepository _fileRepository;
  final FolderRepository _folderRepository;
  final String id;

  int _page = 1;

  FolderModel? _folder;
  FolderModel? get folder => _folder;

  /// We assume that we reached the end if a page response has less items than
  /// requested.
  bool _reachedEnd = false;

  List<FileModel>? _files;
  List<FileModel>? get files => _files;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  bool get _canLoadMore => !_reachedEnd && !loading && error == null;

  Future<void> loadNextPage() async {
    if (!_canLoadMore) {
      return;
    }

    _page++;
    return load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    try {
      final page = await _fetchFilesPage(_page);

      _reachedEnd = page.length < _kItemsPerPage;
      _files = [...files ?? [], ...page];
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<List<FileModel>> _fetchFilesPage(int page) async {
    // load folder if not available
    await _loadFolderIfNecessary();

    final fileType = _folder!.type == FolderContentType.video
        ? FileTypeQuery.video
        : FileTypeQuery.photo;

    return _fileRepository.getPage(
      page: _page,
      size: _kItemsPerPage,
      type: fileType,
      searchTerm: _folder!.name,
    );
  }

  Future<void> _loadFolderIfNecessary() async {
    if (_folder == null) {
      _folder = await _folderRepository.get(id);
      notifyListeners();
    }
  }
}
