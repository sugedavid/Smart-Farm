import 'package:flutter/material.dart';

import '../../core/utils/spacing.dart';

class SFDropdownButton extends StatefulWidget {
  const SFDropdownButton({
    super.key,
    required this.labelText,
    required this.list,
    required this.controller,
    required this.onChanged,
    this.required = true,
  });

  final String labelText;
  final bool required;
  final List<String> list;
  final TextEditingController controller;
  final Function() onChanged;

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
                ),
              ),
              if (widget.required)
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
                fillColor: Theme.of(context).colorScheme.surface,
                hintText: "Select",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.surfaceVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ), // Set focused border color to transparent
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  widget.controller.text = dropdownValue;
                  widget.onChanged();
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
