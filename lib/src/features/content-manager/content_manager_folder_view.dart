import 'package:flutter/cupertino.dart';

class ContentManagerFolderView extends StatelessWidget {
  const ContentManagerFolderView({super.key});

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
