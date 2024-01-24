import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_scaffold.dart';

class FileDetailsView extends StatelessWidget {
  const FileDetailsView({
    required this.file,
    super.key,
  });

  final FileModel file;

  @override
  Widget build(BuildContext context) {
    return RbSheetWrapper(
      child: CupertinoPageScaffold(
        child: RbScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              border: null,
              largeTitle: Text(file.filename),
              stretch: true,
            ),
          ],
        ),
      ),
    );
  }
}
