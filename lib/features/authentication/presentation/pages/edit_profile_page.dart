import 'dart:io';

import 'package:bloom/features/authentication/data/repositories/auth_repository.dart';
import 'package:bloom/features/authentication/data/repositories/local_auth_repository.dart';
import 'package:bloom/features/authentication/presentation/bloc/edit_profile/edit_profile_cubit.dart';
import 'package:bloom/features/authentication/presentation/widgets/exit_edit_profile_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit(
        context.read<AuthRepository>(),
        context.read<LocalUserDataRepository>(),
      ),
      child: const EditProfilePageContent(),
    );
  }
}

class EditProfilePageContent extends StatelessWidget {
  const EditProfilePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _pickProfilePicture() async {
      final fileData = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (fileData != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: fileData.path,
          cropStyle: CropStyle.circle,
          compressFormat: ImageCompressFormat.png,
          compressQuality: 100,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Photo Crop',
              toolbarColor: Colors.black,
              toolbarWidgetColor: naturalWhite,
              initAspectRatio: CropAspectRatioPreset.original,
              statusBarColor: Colors.black,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          ],
        );
        if (croppedFile != null) {
          // ignore: use_build_context_synchronously
          context.read<EditProfileCubit>().changedTempPicture(
                File(croppedFile.path),
              );
        }
      }
    }

    return Scaffold(
      backgroundColor: naturalWhite,
      resizeToAvoidBottomInset: false,
      body: BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.status == EditProfileStatus.success) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Edit Profile Success"),
                ),
              );
          } else if (state.status == EditProfileStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Error: ${state.errorMessage}"),
                ),
              );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Text(
                "Edit Profile",
                style: mainSubTitle,
              ),
              SizedBox(height: getHeight(32, context)),
              BlocBuilder<EditProfileCubit, EditProfileState>(
                builder: (context, state) {
                  if (state.isPictureChanged) {
                    return CircleAvatar(
                      radius: 40,
                      backgroundImage: FileImage(
                        state.profilePictureTemp,
                      ),
                    );
                  } else {
                    return CachedNetworkImage(
                      imageUrl: state.initPhoto,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          width: 80.0,
                          height: 80.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: naturalBlack,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    );
                  }
                },
              ),
              SizedBox(height: getHeight(8, context)),
              GestureDetector(
                onTap: () => _pickProfilePicture(),
                child: Text(
                  "Change Profile Picture",
                  style: textParagraph,
                ),
              ),
              SizedBox(height: getHeight(30, context)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: buttonSmall.copyWith(fontSize: 14),
                ),
              ),
              SizedBox(height: getHeight(8, context)),
              Container(
                padding: const EdgeInsets.all(8),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: greyDark),
                  color: const Color(0xffF2F2F2),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/mail.png",
                      width: 24,
                      color: greyDark,
                    ),
                    SizedBox(width: getWidth(8, context)),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        initialValue: BlocProvider.of<EditProfileCubit>(context)
                            .state
                            .initEmail,
                        style: textForm.copyWith(
                          color: greyDark,
                          fontWeight: FontWeight.w600,
                        ),
                        cursorColor: naturalBlack,
                        decoration: InputDecoration.collapsed(
                          enabled: false,
                          hintText: 'Your email',
                          hintStyle: textForm.copyWith(color: greyDark),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getHeight(16, context)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Name",
                  style: buttonSmall.copyWith(fontSize: 14),
                ),
              ),
              SizedBox(height: getHeight(8, context)),
              Container(
                padding: const EdgeInsets.all(8),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: naturalBlack),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/person.png", width: 24),
                    SizedBox(width: getWidth(8, context)),
                    Expanded(
                      child: BlocBuilder<EditProfileCubit, EditProfileState>(
                        buildWhen: (previous, current) {
                          return previous.newName != current.newName;
                        },
                        builder: (context, state) {
                          return TextFormField(
                            initialValue:
                                BlocProvider.of<EditProfileCubit>(context)
                                    .state
                                    .initName,
                            onChanged: (value) {
                              context
                                  .read<EditProfileCubit>()
                                  .changedName(value);
                            },
                            style: textForm,
                            cursorColor: naturalBlack,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Your name',
                              hintStyle: textForm.copyWith(color: greyDark),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.read<EditProfileCubit>().saveProfile();
                },
                child: Container(
                  width: 202,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: naturalBlack,
                  ),
                  child: Center(
                      child: BlocBuilder<EditProfileCubit, EditProfileState>(
                    builder: (context, state) {
                      if (state.status == EditProfileStatus.submitting) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: naturalWhite,
                              ),
                            ),
                            SizedBox(width: getWidth(8, context)),
                            Text(
                              "Saving..",
                              style: buttonSmall.copyWith(color: naturalWhite),
                            ),
                          ],
                        );
                      } else {
                        return Text(
                          "Save",
                          style: buttonSmall.copyWith(color: naturalWhite),
                        );
                      }
                    },
                  )),
                ),
              ),
              SizedBox(height: getHeight(16, context)),
              GestureDetector(
                onTap: () {
                  if (BlocProvider.of<EditProfileCubit>(context)
                          .state
                          .isPictureChanged ||
                      BlocProvider.of<EditProfileCubit>(context)
                              .state
                              .initName !=
                          BlocProvider.of<EditProfileCubit>(context)
                              .state
                              .newName) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const ExitEditProfileDialog();
                      },
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Cancel", style: textParagraph),
              ),
              SizedBox(height: getHeight(72, context)),
            ],
          ),
        ),
      ),
    );
  }
}
