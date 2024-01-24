import 'package:flutter/foundation.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';

class FoldersController extends ChangeNotifier {
  FoldersController(this._folderRepository) {
    _loadFolders();
  }

  final FolderRepository _folderRepository;

  List<FolderModel>? _folders;
  List<FolderModel>? get folders => _folders;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  Future<void> _loadFolders() async {
    _loading = true;
    notifyListeners();

    try {
      _folders = await _folderRepository.getAll();
      _error = null;
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
