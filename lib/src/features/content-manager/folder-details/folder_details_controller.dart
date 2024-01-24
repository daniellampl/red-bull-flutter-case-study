import 'package:flutter/foundation.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_repository.dart';

const _kItemsPerPage = 25;

class FolderDetailsController extends ChangeNotifier {
  FolderDetailsController(
    this._fileRepository,
    this._folderRepository, {
    required this.id,
  }) {
    _load();
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
    return _load();
  }

  Future<void> _load() async {
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
    _folder ??= await _folderRepository.get(id);

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
}
