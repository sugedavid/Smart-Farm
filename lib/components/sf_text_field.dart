import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';
import '../utils/spacing.dart';

enum TextFieldType { email, name, password }

class SFTextField extends StatelessWidget {
  const SFTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.hintText,
    this.textInputType,
    this.obscureText = false,
    this.validate = true,
    this.showOptional = true,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.inputFormatters,
    this.focusNode,
  });

  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool? obscureText;
  final bool? validate;
  final bool? showOptional;
  final bool? enabled;
  final bool? readOnly;
  final Function()? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  String? Function(String?)? _validator() {
    // email validation
    if (textInputType == TextInputType.emailAddress) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${labelText.toLowerCase()}';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      };
    }
    // text validation
    else if (textInputType == TextInputType.text ||
        textInputType == TextInputType.name) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${labelText.toLowerCase()}';
        } else if (value.length < 2) {
          return 'Name must be at least 2 characters long';
        }
        return null;
      };
    }
    // password validation
    else if (obscureText == true) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${labelText.toLowerCase()}';
        } else if (validate! && value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      };
    }
    // phone validation
    else if (textInputType == TextInputType.phone) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${labelText.toLowerCase()}';
        } else if (validate! && value.length < 10) {
          return 'Phone must be at least 10 digits long';
        }
        return null;
      };
    }

    // streetAddress
    else if (textInputType == TextInputType.streetAddress) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${labelText.toLowerCase()}';
        }
        return null;
      };
    }

    // custom validation
    else if (validator != null) {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${labelText.toLowerCase()}';
        } else {
          return validator!();
        }
      };
    }
    // no validation
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String hint = hintText ?? 'Enter $labelText';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label
        if (labelText.isNotEmpty) ...{
          Row(
            children: [
              Text(
                labelText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                validate!
                    ? '*'
                    : showOptional!
                        ? ' (Optional)'
                        : '',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: validate! ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          AppSpacing.xSmall
        },

        // text field
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            enabled: enabled,
            readOnly: readOnly!,
            obscureText: obscureText!,
            controller: controller,
            keyboardType: textInputType,
            focusNode: focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundColor,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.all(12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.backgroundColor,
                ), // Change the border color here
                borderRadius: BorderRadius.circular(4.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.backgroundColor,
                ), // Change the border color here
                borderRadius: BorderRadius.circular(4.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  color: readOnly!
                      ? AppColors.backgroundColor
                      : AppColors.primaryColor,
                ), // Set focused border color to transparent
              ),
            ),
            validator: validate! ? _validator() : null,
            inputFormatters: inputFormatters,
          ),
        ),
        AppSpacing.large,
      ],
    );
  }
}

// sortcode formatter
class SortCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String formattedText = _formatSortCode(newValue.text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatSortCode(String input) {
    input = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (input.length >= 3) {
      return '${input.substring(0, 2)}-${input.substring(2, 4)}-${input.substring(4, input.length)}';
    } else if (input.length >= 2) {
      return '${input.substring(0, 2)}-${input.substring(2, input.length)}';
    } else {
      return input;
    }
  }
}
