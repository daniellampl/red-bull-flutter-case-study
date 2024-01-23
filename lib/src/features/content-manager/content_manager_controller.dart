import 'package:flutter/foundation.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/repository/folder_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/repository/model/folder_model.dart';

class ContentManagerController extends ChangeNotifier {
  ContentManagerController(this._folderRepository) {
    _folderRepository.folders.addListener(notifyListeners);
  }

  final FolderRepository _folderRepository;

  List<FolderModel> get folders => _folderRepository.folders.value;

  Future<void> getFolders() async {
    await _folderRepository.get();
  }

  @override
  void dispose() {
    _folderRepository.folders.removeListener(notifyListeners);
    super.dispose();
  }
}
