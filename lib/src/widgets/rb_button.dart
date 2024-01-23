import 'package:flutter/cupertino.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

const _kMinHeight = 46.0;

class RbButton extends StatelessWidget {
  const RbButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.trailing,
  });

  final Widget child;
  final Function() onPressed;
  final Icon? trailing;

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle.copyWith(
          color: RbColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 1,
          letterSpacing: -0.4,
        );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: _kMinHeight,
        ),
        decoration: ShapeDecoration(
          color: RbColors.of(context).primary,
          shadows: [
            BoxShadow(
              color: RbColors.of(context).shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
          shape: const StadiumBorder(),
        ),
        padding:
            const EdgeInsets.only(top: 16, bottom: 16, left: 21, right: 14),
        child: DefaultTextStyle(
          style: textStyle,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              if (trailing != null) ...[
                const SizedBox(width: 25),
                IconTheme(
                  data: IconTheme.of(context).copyWith(
                    color: RbColors.white,
                  ),
                  child: trailing!,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
