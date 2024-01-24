import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_scaffold.dart';

class FileDetailsView extends StatelessWidget {
  const FileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: RbScaffoldScrollView(
        slivers: [],
      ),
    );
  }
}
