import 'package:flutter/cupertino.dart';

class ContentManagerFoldersView extends StatelessWidget {
  const ContentManagerFoldersView({super.key});

  static const routeName = 'content-manager-folders';

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: Text('Folders go here'),
      ),
    );
  }
}
