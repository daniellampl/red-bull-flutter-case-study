import 'package:flutter/widgets.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

const _kDefaultTitleBig = TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.w700,
  height: 1.2,
  letterSpacing: -1.4,
);

const _kDefaultTitleMedium = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  height: 1.22,
  letterSpacing: -0.4,
);

const _kDefaultTitleSmall = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  height: 1.06,
  letterSpacing: -0.4,
);

const _kDefaultTextSmall = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w300,
  height: 1.30,
  letterSpacing: -0.4,
);

TextStyle titleBigOf(BuildContext context) {
  return _kDefaultTitleBig.copyWith(
    color: RbColors.of(context).labelPrimary,
  );
}

TextStyle titleMediumOf(BuildContext context) {
  return _kDefaultTitleMedium.copyWith(
    color: RbColors.of(context).labelSecondary,
  );
}

TextStyle titleSmallOf(BuildContext context) {
  return _kDefaultTitleSmall.copyWith(
    color: RbColors.of(context).labelSecondary,
  );
}

TextStyle textSmallOf(BuildContext context) {
  return _kDefaultTextSmall.copyWith(
    color: RbColors.of(context).labelSecondary,
  );
}
