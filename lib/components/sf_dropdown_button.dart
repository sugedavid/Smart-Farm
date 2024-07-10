import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/spacing.dart';

class SFDropdownButton extends StatefulWidget {
  const SFDropdownButton(
      {super.key,
      required this.labelText,
      required this.list,
      required this.controller});

  final String labelText;
  final List<String> list;
  final TextEditingController controller;

  @override
  State<SFDropdownButton> createState() => _SFDropdownButtonState();
}

class _SFDropdownButtonState extends State<SFDropdownButton> {
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.controller.text.isNotEmpty
        ? widget.controller.text
        : widget.list.first;
    widget.controller.text = dropdownValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label
        if (widget.labelText.isNotEmpty) ...{
          Row(
            children: [
              Text(
                widget.labelText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              const Text(
                '*',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          AppSpacing.xSmall
        },

        // dropdown
        SizedBox(
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              elevation: 16,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.backgroundColor,
                hintText: "Select",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide:
                      const BorderSide(color: AppColors.backgroundColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors
                          .backgroundColor), // Change the border color here
                  borderRadius: BorderRadius.circular(4.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                  ), // Set focused border color to transparent
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  widget.controller.text = dropdownValue;
                });
              },
              items: widget.list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),

        AppSpacing.large,
      ],
    );
  }
}
