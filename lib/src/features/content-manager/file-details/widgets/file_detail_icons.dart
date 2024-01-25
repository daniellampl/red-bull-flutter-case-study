import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

const _kIconSize = 18.0;

class FileDetailIcons extends StatelessWidget {
  const FileDetailIcons({
    required this.file,
    super.key,
  });

  final FileModel file;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _typeIcon,
          color: RbColors.of(context).fillsSecondary,
          size: _kIconSize,
        ),
      ],
    );
  }

  IconData get _typeIcon => file is VideoFileModel
      ? CupertinoIcons.video_camera_solid
      : CupertinoIcons.photo_fill;
}
