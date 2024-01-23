import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

const _kInnerHorizontalPadding = EdgeInsets.symmetric(horizontal: 15);

class RbListTile extends StatelessWidget {
  const RbListTile({
    required this.child,
    super.key,
    this.innerPadding,
    this.onTap,
    this.outerPadding,
  });

  final Widget child;
  final EdgeInsets? innerPadding;
  final Function()? onTap;
  final EdgeInsets? outerPadding;

  @override
  Widget build(BuildContext context) {
    final padding = _kInnerHorizontalPadding
        .add(innerPadding ?? EdgeInsets.zero)
        .add(outerPadding ?? EdgeInsets.zero);

    // use platform specific implementation of a list tile to provide native
    // selection effects.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoListTile(
        onTap: onTap,
        padding: padding,
        title: child,
      );
    } else {
      return Material(
        child: ListTile(
          contentPadding: padding,
          dense: true,
          onTap: onTap,
          tileColor: RbColors.of(context).background,
          title: child,
        ),
      );
    }
  }
}
