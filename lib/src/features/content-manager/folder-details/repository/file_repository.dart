import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_data_source.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';

enum FileTypeQuery { photo, video }

class FileRepository {
  FileRepository({
    FileDataSource? dataSource,
  }) : _dataSource = dataSource ?? PixabayFileDataSource();

  final FileDataSource _dataSource;

  Future<List<FileModel>> getPage({
    required int page,
    required int size,
    required FileTypeQuery type,
    String? searchTerm,
  }) async {
    if (type == FileTypeQuery.photo) {
      return await _dataSource.searchPhotos(
        page: page,
        size: size,
        searchTerm: searchTerm,
      );
    } else {
      return await _dataSource.searchVideos(
        page: page,
        size: size,
        searchTerm: searchTerm,
      );
    }
  }
}
