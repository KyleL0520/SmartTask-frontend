import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/auth.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:frontend/src/widgets/input/button.dart';
import 'package:frontend/src/widgets/input/form_item.dart';
import 'package:frontend/src/widgets/label/label.dart';

@RoutePage()
class EditPasswordScreen extends StatefulWidget {
  final User user;
  const EditPasswordScreen({super.key, required this.user});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _password.dispose();
    _confirmPassword.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool? success = await AuthService().resetPassword(
        widget.user.email.trim(),
        _password.text.trim(),
      );

      if (!mounted) return;

      if (success != null && success) {
        UINotify.success(context, "Reset password successfully");
        Navigator.of(context).pop();
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
      appBar: CustomAppBar(title: 'Edit Password', isCenterTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          CustomLabel(text: 'New Password'),
                          const SizedBox(height: 10),
                          PasswordField(controller: _password),
                          const SizedBox(height: 20),
                          CustomLabel(text: 'Confirm Password'),
                          const SizedBox(height: 10),
                          ConfirmPasswordField(
                            passwordController: _password,
                            confirmPasswordController: _confirmPassword,
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'Edit',
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
    );
  }
}
