import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_icons.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_typography.dart';

const _kIconSize = 15.0;

class FileDetailIcons extends StatelessWidget {
  const FileDetailIcons({
    required this.file,
    super.key,
  });

  final FileModel file;

  @override
  Widget build(BuildContext context) {
    final iconColor = RbColors.of(context).fillsSecondary;

    return IconTheme(
      data: IconThemeData(color: iconColor),
      child: Row(
        children: [
          Icon(
            _typeIcon,
            size: _kIconSize,
          ),
          if (file is VideoFileModel) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                height: _kIconSize,
                width: 0.4,
                color: iconColor,
              ),
            ),
            if (_videoResolutionIcon != null)
              Icon(
                _videoResolutionIcon,
                color: RbColors.of(context).fillsSecondary,
                size: _kIconSize,
              )
            else
              Text(
                file.resolution,
                style: textSmallOf(context).copyWith(
                  fontWeight: FontWeight.w300,
                ),
              )
          ]
        ],
      ),
    );
  }

  IconData get _typeIcon =>
      file is VideoFileModel ? RbIcons.video : RbIcons.photo;

  IconData? get _videoResolutionIcon {
    if (file is VideoFileModel) {
      final video = file as VideoFileModel;

      if (video.is4k) {
        return RbIcons.fourK;
      } else if (video.isFhd) {
        return RbIcons.fhd;
      }
    }

    return null;
  }
}
