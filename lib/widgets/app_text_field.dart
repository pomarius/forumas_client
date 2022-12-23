import 'package:flutter/material.dart';

import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool expands;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.obscureText = false,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) _buildLabel(context),
        _buildTextField(context),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.baselineGrid),
      child: Text(
        labelText!.toUpperCase(),
        style: AppTextStyles.label.copyWith(color: Theme.of(context).colorScheme.onSurface),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Flexible(
      child: TextField(
        // expands: obscureText ? false : expands,
        maxLines: obscureText || !expands ? 1 : null,
        keyboardType: expands ? TextInputType.multiline : null,
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        cursorColor: Theme.of(context).colorScheme.onSurfaceVariant,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          prefixIcon: prefixIcon != null
              ? IconTheme(
                  data: IconThemeData(color: Theme.of(context).colorScheme.onSurfaceVariant, size: 24),
                  child: prefixIcon!,
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(Dimens.cornerRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(Dimens.cornerRadius),
          ),
        ),
      ),
    );
  }
}
