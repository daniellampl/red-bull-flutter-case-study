import 'package:red_bull_flutter_case_study/src/features/folders/repository/folder_model.dart';

abstract interface class FolderDataSource {
  Future<List<FolderModel>> getAll();
}

/// An implementation of [FolderDataSource] that return static [FolderModel]
/// data.
class StaticFolderDataSource implements FolderDataSource {
  @override
  Future<List<FolderModel>> getAll() async {
    return [
      const FolderModel(
        id: '362df5e3-6654-425c-8996-623f7ff54df6',
        name: 'Red Bull',
        type: FolderContentType.photo,
      ),
      const FolderModel(
        id: 'b2e5c516-2292-492c-98a0-ef1aca9f25e2',
        name: 'Clouds',
        type: FolderContentType.photo,
      ),
      const FolderModel(
        id: '479cfb54-457f-4d56-8d38-fe2b582b31c0',
        name: 'Cars',
        type: FolderContentType.video,
      ),
      const FolderModel(
        id: '172b267e-3b4f-40dd-a2db-da2fa580615a',
        name: 'Urban',
        type: FolderContentType.photo,
      ),
      const FolderModel(
        id: '5d5ca58f-ac55-4169-9a2b-03bacb4e79ee',
        name: 'Concert',
        type: FolderContentType.photo,
      ),
      const FolderModel(
        id: '7c678446-76cc-4ff5-a36f-a65906a147f7',
        name: 'Software',
        type: FolderContentType.video,
      ),
    ];
  }
}
