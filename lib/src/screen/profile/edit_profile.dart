import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/user.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:frontend/src/widgets/input/button.dart';
import 'package:frontend/src/widgets/input/form_item.dart';
import 'package:frontend/src/widgets/label/label.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = false;
  bool _isPickingImage = false;
  late String _avatar;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();

  @override
  void initState() {
    _avatar = widget.user.avatarPhoto;
    _username.text = widget.user.username;
    super.initState();
  }

  Future pickImageFromGallery() async {
    if (_isPickingImage) return;

    _isPickingImage = true;

    try {
      final selectedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (selectedImage != null) {
        setState(() {
          _avatar = selectedImage.path;
        });
      }
    } catch (e) {
      print('Image picking failed: $e');
    } finally {
      _isPickingImage = false;
    }
  }

  Future<void> _hanldeUpdateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    widget.user.username = _username.text.trim();
    widget.user.avatarPhoto = _avatar;

    try {
      final response = await UserService().updateUser(context, widget.user);

      if (response == null) return;

      if (!mounted) return;
      UINotify.success(context, 'User edited');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile', isCenterTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _isPickingImage ? null : pickImageFromGallery,
                    child: Stack(
                      children: [
                        ClipOval(
                          child:
                              _avatar.startsWith('assets/')
                                  ? Image.asset(
                                    _avatar,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                  : _avatar.startsWith('http')
                                  ? Image.network(
                                    '$_avatar?v=${DateTime.now().millisecondsSinceEpoch}',
                                    key: ValueKey(_avatar),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.file(
                                    File(_avatar),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(Icons.edit, color: AppColors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomLabel(text: 'Name'),
                      const SizedBox(height: 10),
                      UsernameField(controller: _username),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Edit',
                    isLoading: _isLoading,
                    handle: _hanldeUpdateUser,
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
