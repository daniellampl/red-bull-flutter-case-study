import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/file-details/widgets/file_detail_icons.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/file-details/widgets/file_spec.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/folder_details_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/navigation.dart';
import 'package:red_bull_flutter_case_study/src/widgets/network_file.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_list_tile.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_scaffold.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_spinner.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_typography.dart';

class FolderDetailsView extends StatelessWidget {
  const FolderDetailsView({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return RbSheetWrapper(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 0),
          border: null,
          middle: const Text('Urban'),
          automaticallyImplyMiddle: false,
          leading: Navigator.of(context).canPop()
              ? CupertinoNavigationBarBackButton(
                  previousPageTitle: context.l10n.folders_title,
                )
              : null,
          automaticallyImplyLeading: false,
          transitionBetweenRoutes: false,
        ),
        child: const _Content(),
      ),
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
    return RbScrollView(
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
                        ? const Center(
                            child: RbSpinner(),
                          )
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

class _SliverFilesList extends StatelessWidget {
  const _SliverFilesList();

  @override
  Widget build(BuildContext context) {
    return Selector<FolderDetailsController, List<FileModel>>(
      selector: (_, controller) => controller.files ?? [],
      builder: (_, files, __) => SliverList.separated(
        itemCount: files.length,
        itemBuilder: (_, index) {
          final file = files[index];
          return _FileListItem(
            file: file,
            onTap: () => _navigateToFile(context, file),
          );
        },
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

  void _navigateToFile(BuildContext context, FileModel file) {
    final controller =
        Provider.of<FolderDetailsController>(context, listen: false);

    if (controller.folder != null) {
      AppNavigator.of(context).toFile(file: file);
    }
  }
}

class _FileListItem extends StatelessWidget {
  const _FileListItem({
    required this.file,
    this.onTap,
  });

  final FileModel file;
  final Function()? onTap;

  Duration? get _duration =>
      file is VideoFileModel ? (file as VideoFileModel).duration : null;

  @override
  Widget build(BuildContext context) {
    return RbListTile(
      innerPadding: const EdgeInsets.symmetric(vertical: 15),
      onTap: onTap,
      outerPadding: _kContentPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: _kImageDimension,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: RbNetworkImage(
                url: file.thumbnail,
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
                  style: titleSmallOf(context),
                ),
                DefaultTextStyle(
                  style: textSmallOf(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DurationFileSpec(_duration),
                      // TODO: use value from file
                      CreationDateFileSpec(DateTime.now())
                    ],
                  ),
                ),
                FileDetailIcons(file: file)
              ],
            ),
          ),
          Icon(
            CupertinoIcons.play_circle_fill,
            color: RbColors.of(context).fillsSecondary,
            size: 28,
          )
        ],
      ),
    );
  }
}
