import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/content_manager_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/repository/model/folder_model.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_list_tile.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_scaffold.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_spinner.dart';

const _kHorizontalPadding = EdgeInsets.symmetric(horizontal: 16);

class ContentManagerFoldersView extends StatelessWidget {
  const ContentManagerFoldersView({super.key});

  static const routeName = 'content-manager-folders';

  @override
  Widget build(BuildContext context) {
    return const RbScaffold(
      child: _Content(),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late final Future _foldersFuture;

  @override
  void initState() {
    final controller = Provider.of<ContentManagerController>(
      context,
      listen: false,
    );
    _foldersFuture = controller.getFolders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _foldersFuture,
      builder: (_, snapshot) => CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: null,
            largeTitle: Text(context.l10n.folders_title),
            stretch: true,
          ),
          SliverMainAxisGroup(
            slivers: [
              const SliverPadding(
                padding: _kHorizontalPadding,
                sliver: SliverToBoxAdapter(
                  // disable search field interactions since there is (yet) no
                  // functionality behind it.
                  child: IgnorePointer(
                    child: CupertinoSearchTextField(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 15),
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                const SliverToBoxAdapter(
                  child: RbSpinner(),
                )
              else
                const _SliverFoldersList(),
              // let's ignore the error state for now. Errors should be handled
              // as soon as we get the data from a location where errors could
              // occur (e.g. a network request)
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverFoldersList extends StatelessWidget {
  const _SliverFoldersList();

  @override
  Widget build(BuildContext context) {
    // since the folders are static (for now), we can assume, that we won't have
    // to deals with and empty list and therefore we don't have to handle it
    return Selector<ContentManagerController, List<FolderModel>>(
      selector: (_, controller) => controller.folders,
      builder: (_, folders, __) => SliverList.separated(
        itemCount: folders.length,
        itemBuilder: (_, index) => _FolderListItem(
          folder: folders[index],
          // TODO: navigate to images/videos
          onTap: () {},
        ),
        separatorBuilder: (_, __) => Padding(
          padding: _kHorizontalPadding,
          child: Container(
            color: RbColors.of(context).fillsTertiary,
            height: 0.5,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

class _FolderListItem extends StatelessWidget {
  const _FolderListItem({
    required this.folder,
    this.onTap,
  });

  final FolderModel folder;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RbListTile(
      innerPadding: const EdgeInsets.symmetric(vertical: 18),
      onTap: onTap,
      outerPadding: _kHorizontalPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage(
              'assets/images/folder.png',
            ),
            height: 45,
          ),
          const SizedBox(width: 29),
          Text(
            folder.name,
            style: TextStyle(
              color: RbColors.of(context).labelMedium,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.22,
              letterSpacing: -0.4,
            ),
          )
        ],
      ),
    );
  }
}
