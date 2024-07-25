import 'package:flutter/material.dart';
import 'package:smart_farm/components/sf_primary_button.dart';
import 'package:smart_farm/components/sf_single_page_scaffold.dart';
import 'package:smart_farm/components/sf_text_field.dart';
import 'package:smart_farm/data/models/user.dart';
import 'package:smart_farm/utils/firebase/user_utils.dart';
import 'package:smart_farm/utils/spacing.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.userData});

  final UserModel userData;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  final ValueNotifier<bool> _isFirstNameChanged = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isLastNameChanged = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isAccountTypeChanged = ValueNotifier<bool>(false);

  String? initialFirstName;
  String? initialLastName;
  String? initialAccountType;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // fetch user data
  void getUserData() async {
    UserModel userData = widget.userData;
    firstNameController.text = userData.firstName;
    lastNameController.text = userData.lastName;
    emailController.text = userData.email;

    // store initial values
    initialFirstName = userData.firstName;
    initialLastName = userData.lastName;

    addTextControllerListener();
  }

  // add listener to text controllers
  void addTextControllerListener() {
    firstNameController.addListener(_onFirstNameTextChanged);
    lastNameController.addListener(_onLastNameTextChanged);
  }

  // remove listener from text controllers
  void removeTextControllerListener() {
    firstNameController.removeListener(_onFirstNameTextChanged);
    lastNameController.removeListener(_onLastNameTextChanged);
  }

  // check if first name is changed
  void _onFirstNameTextChanged() {
    setState(() {
      _isFirstNameChanged.value = firstNameController.text != initialFirstName;
    });
  }

  // check if last name is changed
  void _onLastNameTextChanged() {
    setState(() {
      _isLastNameChanged.value = lastNameController.text != initialLastName;
    });
  }

  // dispose text controllers
  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
  }

  @override
  void dispose() {
    removeTextControllerListener();
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SFSinglePageScaffold(
      title: 'Edit Profile',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacing.medium,

            // first name
            SFTextField(
              labelText: 'First Name',
              controller: firstNameController,
              textInputType: TextInputType.name,
            ),

            // last name
            SFTextField(
              labelText: 'Last Name',
              controller: lastNameController,
              textInputType: TextInputType.name,
            ),

            AppSpacing.large,

            // continue cta
            SFPrimaryButton(
              text: 'Save',
              enable: (_isFirstNameChanged.value ||
                  _isLastNameChanged.value ||
                  _isAccountTypeChanged.value),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await updateUserInfo(
                    firstNameController.text,
                    lastNameController.text,
                    context,
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
