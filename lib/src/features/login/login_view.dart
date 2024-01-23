import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/content_manager_folders_view.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/login/service/login_validator.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_button.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    required this.pageRouteObserver,
    super.key,
  });

  final RouteObserver<PageRoute> pageRouteObserver;

  static const routeName = 'login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with RouteAware {
  @override
  void didChangeDependencies() {
    // register RouteObserver in order to listen to route changes. This is
    // necessary in order to be able to react to the user routing back to this
    // view to clear their authentication state.
    widget.pageRouteObserver
        .subscribe(this, ModalRoute.of(context)! as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    // trigger logout when user routes back to login view.
    Provider.of<LoginController>(context, listen: false).logout();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(child: SizedBox()),
            Text(
              context.l10n.login_title,
              style:
                  CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.login_subTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: -0.4,
                color: RbColors.black.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 28),
            const _LoginForm(),
            const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 71.0),
                  child: Image(
                    height: 45,
                    image: AssetImage('assets/images/black_bull.png'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          RbTextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            label: Text(context.l10n.login_email_label),
            leading: const Icon(CupertinoIcons.mail),
            validator: _emailValidator,
          ),
          const SizedBox(height: 13),
          RbTextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            label: Text(context.l10n.login_password_label),
            leading: const Icon(CupertinoIcons.lock),
            obscureText: true,
            validator: _passwordValidator,
          ),
          const SizedBox(height: 36),
          Align(
            alignment: Alignment.centerRight,
            child: RbButton(
              onPressed: _submit,
              trailing: const Icon(
                CupertinoIcons.arrow_right,
              ),
              child: Text(
                context.l10n.login_cta,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _emailValidator(String? value) {
    final validator = Provider.of<LoginValidator>(context, listen: false);

    return switch (validator.validateEmail(value)) {
      EmailValidationError.empty => context.l10n.login_email_error_empty,
      EmailValidationError.invalid => context.l10n.login_email_error_invalid,
      _ => null,
    };
  }

  String? _passwordValidator(String? value) {
    final validator = Provider.of<LoginValidator>(context, listen: false);

    return switch (validator.validatePassword(value)) {
      PasswordValidationError.empty => context.l10n.login_password_error_empty,
      PasswordValidationError.short => context.l10n
          .login_password_error_short(LoginValidator.defaultMinPasswordLength),
      PasswordValidationError.long => context.l10n
          .login_password_error_long(LoginValidator.defaultMaxPasswordLength),
      PasswordValidationError.invalid =>
        context.l10n.login_password_error_invalid,
      _ => null,
    };
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _removeFocus();

      final router = GoRouter.of(context);

      await Provider.of<LoginController>(context, listen: false).login(
        email: _emailController.value.text,
        password: _passwordController.value.text,
      );

      router.goNamed(ContentManagerFoldersView.routeName);

      // clear text fields after successful authentication and navigation. we
      // have to do this manually, because this view will stay in the background
      // even if we navigate to the next view.
      Future.delayed(const Duration(seconds: 1)).then((value) => _resetForm());
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _emailController.clear();
    _passwordController.clear();

    _removeFocus();
  }

  void _removeFocus() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }
}
