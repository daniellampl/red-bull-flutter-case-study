import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/repository/data/folder_data_source.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/repository/model/folder_model.dart';

class FolderRepository {
  FolderRepository([
    FolderDataSource? dataSource,
  ]) : _dataSource = dataSource ?? StaticFolderDataSource();

  final FolderDataSource _dataSource;

  final ValueNotifier<List<FolderModel>> _folders = ValueNotifier([]);
  ValueNotifier<List<FolderModel>> get folders => _folders;

  Future<void> get() async {
    _folders.value = await _dataSource.getAll();
  }
}
