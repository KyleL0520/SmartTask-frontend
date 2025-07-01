import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/util/services/api/auth.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:frontend/src/widgets/input/button.dart';
import 'package:frontend/src/widgets/input/form_item.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool? success = await AuthService().resetPassword(
        widget.email.trim(),
        _password.text.trim(),
      );

      if (!mounted) return;

      if (success != null && success) {
        UINotify.success(context, "Reset password successfully");
        AutoRouter.of(context).replaceAll([const BaseLayoutRoute()]);
      }
    } catch (e) {
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', isCenterTitle: true),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Reser Password',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    PasswordField(controller: _password),
                    const SizedBox(height: 10),
                    ConfirmPasswordField(
                      passwordController: _password,
                      confirmPasswordController: _confirmPassword,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Reset',
                      isLoading: _isLoading,
                      handle: _handleSubmit,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
