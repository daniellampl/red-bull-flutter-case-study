import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/folder_details_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_list_tile.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_scaffold.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_spinner.dart';

class FoldersDetailsView extends StatelessWidget {
  const FoldersDetailsView({super.key});

  static const routeName = 'folder-details';

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        transitionBetweenRoutes: false,
      ),
      child: _Content(),
    );
  }
}

const _kContentPadding = EdgeInsets.symmetric(horizontal: 16);

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return RbScaffoldScrollView(
      slivers: [
        const SliverPadding(
          padding: _kContentPadding,
          sliver: SliverToBoxAdapter(
            child: IgnorePointer(
              child: CupertinoSearchTextField(),
            ),
          ),
        ),
        Consumer<FolderDetailsController>(
          builder: (_, controller, __) {
            if (controller.loading) {
              return const SliverFillRemaining(
                child: Center(
                  child: RbSpinner(),
                ),
              );
            } else if (controller.error != null) {
              // TODO: handle error properly
              return const Text('Error');
            } else {
              return const SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(height: 15),
                  ),
                  _SliverFilesList(),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}

const _kImageDimension = 65.0;

class _SliverFilesList extends StatelessWidget {
  const _SliverFilesList();

  @override
  Widget build(BuildContext context) {
    return Selector<FolderDetailsController, List<FileModel>>(
      selector: (_, controller) => controller.files,
      builder: (_, files, __) => SliverList.separated(
        itemCount: files.length,
        itemBuilder: (_, index) => _FilePhotoListItem(
          file: files[index],
        ),
        separatorBuilder: (_, __) => Padding(
          padding: _kContentPadding,
          child: Container(
            width: double.infinity,
            height: 0.5,
            color: RbColors.of(context).fillsTertiary,
          ),
        ),
      ),
    );
  }
}

class _FilePhotoListItem extends StatelessWidget {
  const _FilePhotoListItem({
    required this.file,
  });

  final FileModel file;

  @override
  Widget build(BuildContext context) {
    return RbListTile(
      innerPadding: const EdgeInsets.symmetric(vertical: 15),
      outerPadding: _kContentPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: _kImageDimension,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: file.thumbnail.toString(),
                placeholder: (_, __) => ColoredBox(
                  color: RbColors.of(context).fillsTertiary,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  file.filename,
                  style: TextStyle(
                    color: RbColors.of(context).labelMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.06,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  'Duration: ${file is VideoFileModel ? (file as VideoFileModel).duration : 'N/A'} ',
                  style: TextStyle(
                    color: RbColors.of(context).labelMedium,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    height: 1.30,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
