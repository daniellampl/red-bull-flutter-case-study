import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/folders_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/navigation.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_list_tile.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_scaffold.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_spinner.dart';

const _kHorizontalPadding = EdgeInsets.symmetric(horizontal: 16);

class FoldersView extends StatelessWidget {
  const FoldersView({super.key});

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
  @override
  Widget build(BuildContext context) {
    return RbScaffoldScrollView(
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
            // let's ignore the error state for now. Errors should be handled
            // as soon as we get the data from a location where errors could
            // occur (e.g. a network request)
            Consumer<FoldersController>(
              builder: (_, controller, __) {
                if (controller.loading) {
                  return const SliverToBoxAdapter(child: RbSpinner());
                } else if (controller.error != null) {
                  // TODO: show error widget
                  return const SliverToBoxAdapter(child: SizedBox());
                } else {
                  return _SliverFoldersList(
                    folders: controller.folders ?? [],
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SliverFoldersList extends StatelessWidget {
  const _SliverFoldersList({
    required this.folders,
  });

  final List<FolderModel> folders;

  @override
  Widget build(BuildContext context) {
    // since the folders are static (for now), we can assume, that we won't have
    // to deals with and empty list and therefore we don't have to handle it
    return Selector<FoldersController, List<FolderModel>>(
      selector: (_, controller) => controller.folders ?? [],
      builder: (_, folders, __) {
        return SliverList.separated(
          itemCount: folders.length,
          itemBuilder: (_, index) {
            final folder = folders[index];

            return _FolderListItem(
              folder: folder,
              onTap: () => _navigateToFolderDetails(context, folder),
            );
          },
          separatorBuilder: (_, __) => Padding(
            padding: _kHorizontalPadding,
            child: Container(
              color: RbColors.of(context).fillsTertiary,
              height: 0.5,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }

  void _navigateToFolderDetails(BuildContext context, FolderModel folder) {
    AppNavigator.of(context).toFolderDetails(id: folder.id, folder: folder);
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
            _localizeName(context.l10n),
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

  String _localizeName(AppLocalizations l10n) {
    if (folder.type == FolderContentType.video) {
      return l10n.folders_item_video_title(folder.name);
    }
    return folder.name;
  }
}
