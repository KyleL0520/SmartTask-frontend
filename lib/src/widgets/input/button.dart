import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback handle;

  const CustomButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.handle,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.handle,
        style: ElevatedButton.styleFrom(
          backgroundColor: TAppTheme.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            widget.isLoading
                ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Text(
                  widget.text,
                  style: TextStyle(
                    color: TAppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
      ),
    );
  }
}

class DeleteButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback handle;
  const DeleteButton({
    super.key,
    required this.isLoading,
    required this.handle,
  });

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.handle,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            widget.isLoading
                ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Text(
                  'Delete',
                  style: TextStyle(
                    color: TAppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
      ),
    );
  }
}
