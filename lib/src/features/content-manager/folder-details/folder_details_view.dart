import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/folder_details_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
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

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RbScaffoldScrollView(
      controller: _scrollController,
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
          builder: (_, controller, __) => SliverMainAxisGroup(
            slivers: [
              if (controller.files != null) const _SliverFilesList(),
              if (controller.loading || controller.error != null)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: controller.loading
                        ? const RbSpinner()
                        : Center(
                            child:
                                Text(context.l10n.folder_details_error_unknown),
                          ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollChanged);
    super.dispose();
  }

  void _scrollChanged() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.sizeOf(context).width * 0.2;

    if (maxScroll - currentScroll <= delta) {
      final controller =
          Provider.of<FolderDetailsController>(context, listen: false);
      controller.loadNextPage();
    }
  }
}

const _kImageDimension = 65.0;

class _SliverFilesList extends StatefulWidget {
  const _SliverFilesList();

  @override
  State<_SliverFilesList> createState() => _SliverFilesListState();
}

class _SliverFilesListState extends State<_SliverFilesList> {
  @override
  Widget build(BuildContext context) {
    return Selector<FolderDetailsController, List<FileModel>>(
      selector: (_, controller) => controller.files ?? [],
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
                  _durationValue(context.l10n),
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

  String _durationValue(AppLocalizations l10n) {
    if (file is VideoFileModel) {
      return (file as VideoFileModel).duration.toString();
    }
    return l10n.folder_details_file_duration_not_available;
  }
}
