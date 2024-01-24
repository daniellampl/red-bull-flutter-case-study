import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_data_source.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';

class FolderRepository {
  FolderRepository([
    FolderDataSource? dataSource,
  ]) : _dataSource = dataSource ?? StaticFolderDataSource();

  final FolderDataSource _dataSource;

  List<FolderModel> _folders = [];

  Future<List<FolderModel>> getAll() async {
    _folders = await _dataSource.getAll();
    return _folders;
  }

  Future<FolderModel> get(String id) async {
    return (await _dataSource.getAll())
        .firstWhere((element) => element.id == id);
  }
}
