import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/file-details/widgets/file_detail_icons.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/file-details/widgets/file_spec.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/widgets/network_file.dart';
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
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: AspectRatio(
                        aspectRatio: file.aspectRatio,
                        child: file is VideoFileModel
                            ? RbNetworkVideo(url: file.url)
                            : RbNetworkImage(url: file.url),
                      ),
                    ),
                    const SizedBox(height: 34.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DefaultTextStyle(
                        style: textSmallOf(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CreationDateFileSpec(DateTime.now()),
                            DurationFileSpec(_duration),
                            FileDetailIcons(file: file),
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
