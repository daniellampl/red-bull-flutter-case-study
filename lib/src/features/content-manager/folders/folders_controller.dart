import 'package:flutter/foundation.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';

class FoldersController extends ChangeNotifier {
  FoldersController(this._folderRepository) {
    _loadFolders();
  }

  final FolderRepository _folderRepository;

  List<FolderModel> _folders = [];
  List<FolderModel> get folders => _folders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> _loadFolders() async {
    _isLoading = true;
    notifyListeners();

    _folders = await _folderRepository.getAll();

    _isLoading = false;
    notifyListeners();
  }
}
