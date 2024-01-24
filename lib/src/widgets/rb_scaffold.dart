import 'package:flutter/cupertino.dart';

class RbScaffold extends StatelessWidget {
  const RbScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: child,
    );
  }
}

class RbScaffoldScrollView extends StatelessWidget {
  const RbScaffoldScrollView({
    required this.slivers,
    super.key,
  });

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
