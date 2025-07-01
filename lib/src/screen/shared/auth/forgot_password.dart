import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/util/services/api/auth.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:frontend/src/widgets/input/button.dart';
import 'package:frontend/src/widgets/input/form_item.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isLoading = false;
  bool _isSubmitted = false;
  bool _canResend = false;
  int _countdown = 60;
  Timer? _timer;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _otpCode = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _otpCode.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool? success = await AuthService().forgotPassword(_email.text.trim());

      if (!mounted) return;

      if (success != null && success) {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _isSubmitted = true;
        });
        _startCountdown();
      }
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
    });

    _otpCode.clear();

    try {
      bool? success = await AuthService().forgotPassword(_email.text.trim());

      if (!mounted) return;

      if (success != null && success) {
        await Future.delayed(const Duration(seconds: 1));
        _startCountdown();
      }
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleValidate() async {
    if (_otpCode.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool? success = await AuthService().validate(
        _email.text.trim(),
        _otpCode.text.trim(),
      );

      if (!mounted) return;

      if (success != null && success) {
        UINotify.success(context, "OTP validates successfully");
        AutoRouter.of(
          context,
        ).push(ResetPasswordRoute(email: _email.text.trim()));
      } else {
        UINotify.error(context, "OTP validates unsuccessfully");
      }
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _temp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', isCenterTitle: true),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child:
                  !_isSubmitted
                      ? Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Forgot Password',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'Enter your email associated with your account and we\'ll send an email with instructions to reset your password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.7,
                                color: AppColors.grey,
                              ),
                            ),
                            SizedBox(height: 30),
                            EmailField(controller: _email),
                            const SizedBox(height: 30),
                            CustomButton(
                              text: 'Send',
                              isLoading: _isLoading,
                              handle: _handleSubmit,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                      : Column(
                        children: [
                          Text(
                            'OTP Verifications',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            'We have send an OTP on given email. Kindly check your email and enter the 6 digit code given.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7,
                              color: AppColors.grey,
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: OtpTextField(
                              enabled: _isSubmitted,
                              numberOfFields: 6,
                              borderColor: TAppTheme.primaryColor,
                              focusedBorderColor: TAppTheme.secondaryColor,
                              showFieldAsBox: true,
                              onSubmit: (String otp) {
                                setState(() {
                                  _otpCode.text = otp;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'Verify',
                            isLoading: _isLoading,
                            handle: _handleValidate,
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                _canResend ? _resendOTP() : _temp();
                              },
                              child:
                                  _canResend
                                      ? Text(
                                        'Resend OTP',
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.9,
                                        ),
                                      )
                                      : Text(
                                        'Resend OTP in ${_countdown.toString()}s',
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.9,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
