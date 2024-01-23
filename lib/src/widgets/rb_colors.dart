import 'package:flutter/widgets.dart';

const _kDefaultBackground = Color(0xFFFFFFFF);
const _kDefaultLabelsPrimary = Color(0xFF000000);
const _kDefaultPrimary = Color(0xFF022EA0);
const _kDefaultShadow = Color(0x40000000);

class RbColors extends InheritedWidget {
  const RbColors({
    required super.child,
    super.key,
    this.background = _kDefaultBackground,
    this.labelPrimary = _kDefaultLabelsPrimary,
    this.primary = _kDefaultPrimary,
    this.shadow = _kDefaultShadow,
  });

  final Color background;
  final Color labelPrimary;
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
