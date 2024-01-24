import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

class RbScaffold extends StatelessWidget {
  const RbScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: RbColors.of(context).canvas,
      child: child,
    );
  }
}

class RbSheetWrapper extends StatelessWidget {
  const RbSheetWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: RbColors.of(context).canvas,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
            child: Center(
              child: _DragIndicator(),
            ),
          ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}

class _DragIndicator extends StatelessWidget {
  const _DragIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 36,
      decoration: ShapeDecoration(
        color: RbColors.of(context).labelTertiary,
        shape: const StadiumBorder(),
      ),
    );
  }
}

class RbScrollView extends StatelessWidget {
  const RbScrollView({
    required this.slivers,
    this.controller,
    super.key,
  });

  final ScrollController? controller;
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        ...slivers,
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 63, bottom: 71),
                child: Image(
                  height: 45,
                  image: AssetImage('assets/images/black_bull.png'),
                ),
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ),
        ),
      ],
    );
  }
}
