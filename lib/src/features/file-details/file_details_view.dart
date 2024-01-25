import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/features/file-details/widgets/file_detail_icons.dart';
import 'package:red_bull_flutter_case_study/src/features/file-details/widgets/file_spec.dart';
import 'package:red_bull_flutter_case_study/src/features/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_network_file.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_scaffold.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_typography.dart';

class FileDetailsView extends StatelessWidget {
  const FileDetailsView({
    required this.file,
    super.key,
  });

  final FileModel file;

  Duration? get _duration =>
      file is VideoFileModel ? (file as VideoFileModel).duration : null;

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
            const SliverToBoxAdapter(
              child: SizedBox(height: 38),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              sliver: SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FilePreview(file: file),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DefaultTextStyle(
                        style: textSmallOf(context),
                        child: Column(
                          // forces Wrap expand to the maximum available width
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              spacing: 16,
                              runSpacing: 6,
                              alignment: WrapAlignment.spaceBetween,
                              runAlignment: WrapAlignment.center,
                              children: [
                                DurationFileSpec(_duration),
                                CreationDateFileSpec(DateTime.now()),
                                FileDetailIcons(file: file),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

const _kFilePreviewBorderRadius = BorderRadius.all(Radius.circular(25));

class _FilePreview extends StatelessWidget {
  const _FilePreview({
    required this.file,
  });

  final FileModel file;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: _kFilePreviewBorderRadius,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: RbColors.of(context).shadow,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: _kFilePreviewBorderRadius,
        child: AspectRatio(
          aspectRatio: file.aspectRatio,
          child: file is VideoFileModel
              ? RbNetworkVideo(url: file.url)
              : RbNetworkImage(url: file.url),
        ),
      ),
    );
  }
}
