import 'package:flareline/pages/auth/sign_up/sign_up_provider.dart';
import 'package:flareline_uikit/core/mvvm/base_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flareline_uikit/components/buttons/button_widget.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline_uikit/components/forms/outborder_text_form_field.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpWidget extends BaseWidget<SignUpProvider> {
  SignUpWidget({super.key});

  @override
  Widget bodyWidget(
      BuildContext context, SignUpProvider viewModel, Widget? child) {
    return Scaffold(body: ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return Center(
            child: contentDesktopWidget(context,viewModel),
          );
        }

        return contentMobileWidget(context,viewModel);
      },
    ));
  }

  @override
  SignUpProvider viewModelBuilder(BuildContext context) {
    return SignUpProvider(context);
  }

  Widget contentDesktopWidget(BuildContext context, SignUpProvider viewModel) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: CommonCard(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Row(children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.appName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.slogan),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 350,
                      child: SvgPicture.asset(
                        'assets/signin/signup.svg',
                        semanticsLabel: '',
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: _formWidget(context, viewModel)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget contentMobileWidget(BuildContext context, SignUpProvider viewModel) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: CommonCard(
          padding: const EdgeInsets.all(16),
          child: _formWidget(context, viewModel),
        ),
      ),
    );
  }

  Widget _formWidget(BuildContext context, SignUpProvider viewModel) {
    String? selectedInputMethod;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                OutBorderTextFormField(
                  labelText: 'Name',
                  hintText: 'Enter your full name',
                  controller: viewModel.nameController,
                ),
                const SizedBox(height: 16),

                OutBorderTextFormField(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                  keyboardType: TextInputType.number,
                  controller: viewModel.ageController,
                ),
                const SizedBox(height: 16),

                Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: viewModel.genderController.text,
                        onChanged: (value) {
                          viewModel.genderController.text = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: viewModel.genderController.text,
                        onChanged: (value) {
                          viewModel.genderController.text = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Other'),
                        value: 'Other',
                        groupValue: viewModel.genderController.text,
                        onChanged: (value) {
                          viewModel.genderController.text = value!;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                OutBorderTextFormField(
                  labelText: 'Email',
                  hintText: 'Enter email',
                  keyboardType: TextInputType.emailAddress,
                  controller: viewModel.emailController,
                ),
                const SizedBox(height: 16),

                OutBorderTextFormField(
                  obscureText: true,
                  labelText: 'Password',
                  hintText: 'Enter password',
                  controller: viewModel.passwordController,
                ),
                const SizedBox(height: 16),

                OutBorderTextFormField(
                  obscureText: true,
                  labelText: 'Retype Password',
                  hintText: 'Confirm password',
                  controller: viewModel.rePasswordController,
                ),
                const SizedBox(height: 20),

                Text("How would you like to provide your skin type?"),
                ListTile(
                  title: const Text("Upload Photo"),
                  leading: Radio<String>(
                    value: "photo",
                    groupValue: selectedInputMethod,
                    onChanged: (value) => setState(() {
                      selectedInputMethod = value;
                    }),
                  ),
                ),
                ListTile(
                  title: const Text("Take Survey"),
                  leading: Radio<String>(
                    value: "survey",
                    groupValue: selectedInputMethod,
                    onChanged: (value) => setState(() {
                      selectedInputMethod = value;
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                ButtonWidget(
                  type: ButtonType.primary.type,
                  btnText: 'Next',
                  onTap: () {
                    final name = viewModel.nameController.text.trim();
                    final age = viewModel.ageController.text.trim();
                    final gender = viewModel.genderController.text.trim();
                    final email = viewModel.emailController.text.trim();
                    final password = viewModel.passwordController.text.trim();
                    final rePassword = viewModel.rePasswordController.text.trim();

                    if (name.isEmpty ||
                        age.isEmpty ||
                        gender.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty ||
                        rePassword.isEmpty ||
                        selectedInputMethod == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields and select skin type input method.")),
                      );
                      return;
                    }

                    if (password != rePassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    final userData = {
                      "name": name,
                      "age": int.parse(age),
                      "gender": gender,
                      "email": email,
                      "password": password,
                      "rePassword": rePassword,
                    };

                    if (selectedInputMethod == "photo") {
                      Navigator.pushNamed(context, '/skintypePhoto', arguments: userData);
                    } else {
                      Navigator.pushNamed(context, '/skintypeSurvey', arguments: userData);
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  bool get isPage => true;

  @override
  bool get showTitle => false;

  @override
  bool get isAlignCenter => true;
}


  // Widget _formWidget(BuildContext context, SignUpProvider viewModel) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 50),
  //     child: SingleChildScrollView(
  //       child: ConstrainedBox(
  //         constraints: BoxConstraints(
  //           minHeight: MediaQuery.of(context).size.height * 0.6,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             OutBorderTextFormField(
  //               labelText: 'Name',
  //               hintText: 'Enter your full name',
  //               controller: viewModel.nameController,
  //             ),
  //             const SizedBox(height: 16),

  //             OutBorderTextFormField(
  //               labelText: 'Age',
  //               hintText: 'Enter your age',
  //               keyboardType: TextInputType.number,
  //               controller: viewModel.ageController,
  //             ),
  //             const SizedBox(height: 16),

  //             OutBorderTextFormField(
  //               labelText: 'Gender',
  //               hintText: 'Male / Female / Other',
  //               controller: viewModel.genderController,
  //             ),
  //             const SizedBox(height: 16),

  //             OutBorderTextFormField(
  //               labelText: 'Skin Type',
  //               hintText: 'e.g., Type I, II, III...',
  //               controller: viewModel.skinTypeController,
  //             ),
  //             const SizedBox(height: 16),

  //             OutBorderTextFormField(
  //               labelText: 'Email',
  //               hintText: 'Enter email',
  //               keyboardType: TextInputType.emailAddress,
  //               controller: viewModel.emailController,
  //             ),
  //             const SizedBox(height: 16),

  //             OutBorderTextFormField(
  //               obscureText: true,
  //               labelText: 'Password',
  //               hintText: 'Enter password',
  //               controller: viewModel.passwordController,
  //             ),
  //             const SizedBox(height: 16),

  //             OutBorderTextFormField(
  //               obscureText: true,
  //               labelText: 'Retype Password',
  //               hintText: 'Confirm password',
  //               controller: viewModel.rePasswordController,
  //             ),
  //             const SizedBox(height: 20),

  //             ButtonWidget(
  //               type: ButtonType.primary.type,
  //               btnText: 'Create Account',
  //               onTap: () => viewModel.signUp(context),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
