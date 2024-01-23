import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

const _kBorderRadius = BorderRadius.all(Radius.circular(8));
const _kIconSize = 28.0;
const _kLabelTextColor = Color(0xFF808080);

typedef RbTextFormFieldValidator = String? Function(String?);

class RbTextFormField extends StatefulWidget {
  const RbTextFormField({
    this.controller,
    this.focusNode,
    super.key,
    this.keyboardType,
    this.label,
    this.leading,
    this.obscureText = false,
    this.placeholder,
    this.validator,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Widget? label;
  final Icon? leading;
  final bool obscureText;
  final String? placeholder;
  final RbTextFormFieldValidator? validator;

  @override
  State<RbTextFormField> createState() => _RbTextFormFieldState();
}

class _RbTextFormFieldState extends State<RbTextFormField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool _obscured = true;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  bool get _hasFocus => _focusNode.hasFocus;

  @override
  Widget build(BuildContext context) {
    _focusNode.addListener(_onFocusChanged);

    return FormField(
      validator: widget.validator,
      builder: (state) {
        final borderColor = state.hasError
            ? Colors.red
            : (_hasFocus ? RbColors.of(context).primary : RbColors.white);

        return GestureDetector(
          onTap: _focusNode.requestFocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                  borderRadius: _kBorderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: RbColors.of(context).shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  color: RbColors.white,
                ),
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 7,
                  left: 17,
                  right: 22,
                ),
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (widget.leading != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            size: _kIconSize,
                            color: state.hasError
                                ? Colors.red
                                : (_hasFocus
                                    ? RbColors.of(context).primary
                                    : RbColors.black),
                          ),
                          child: widget.leading!,
                        ),
                        const SizedBox(width: 20),
                      ],
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.label != null)
                              DefaultTextStyle(
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle
                                    .copyWith(
                                      color: state.hasError
                                          ? Colors.red
                                          : (_hasFocus
                                              ? RbColors.of(context).primary
                                              : _kLabelTextColor),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      height: 2.2,
                                      letterSpacing: -0.4,
                                    ),
                                child: widget.label!,
                              ),
                            EditableText(
                              backgroundCursorColor: RbColors.white,
                              controller: _controller,
                              cursorColor: RbColors.of(context).primary,
                              focusNode: _focusNode,
                              keyboardType: widget.keyboardType,
                              obscureText: widget.obscureText && _obscured,
                              onChanged: state.didChange,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    height: 1.46,
                                    letterSpacing: -0.4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.obscureText)
                        GestureDetector(
                          onTap: _toggleObscured,
                          child: Icon(
                            _obscured
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            color: _kLabelTextColor,
                            size: 20,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              if (state.hasError && state.errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  state.errorText!,
                  style:
                      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: -0.4,
                          ),
                )
              ]
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _toggleObscured() {
    setState(() => _obscured = !_obscured);
  }
}
