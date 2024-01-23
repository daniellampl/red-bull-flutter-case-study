import 'package:flutter/widgets.dart';

const _kDefaultPrimaryColor = Color(0xFF022EA0);
const _kDefaultShadowColor = Color(0x40000000);

class RbColors extends InheritedWidget {
  const RbColors({
    required super.child,
    super.key,
    this.primary = _kDefaultPrimaryColor,
    this.shadow = _kDefaultShadowColor,
  });

  final Color primary;
  final Color shadow;

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static RbColors? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RbColors>();
  }

  static RbColors of(BuildContext context) {
    final RbColors? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RbColors oldWidget) => primary != oldWidget.primary;
}
