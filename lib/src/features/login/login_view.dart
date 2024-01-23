import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/content_manager_folders_view.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_util.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_button.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const routeName = 'login';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          RbTextFormField(
            label: Text(context.l10n.login_email_label),
            leading: const Icon(CupertinoIcons.mail),
            validator: (value) =>
                LoginUtil.validateEmail(context.l10n, value: value),
          ),
          const SizedBox(height: 13),
          RbTextFormField(
            label: Text(context.l10n.login_password_label),
            leading: const Icon(CupertinoIcons.lock),
            obscureText: true,
            validator: (value) =>
                LoginUtil.validatePassword(context.l10n, value: value),
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      GoRouter.of(context).goNamed(ContentManagerFoldersView.routeName);
    }
  }
}
