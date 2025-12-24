import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? hintText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final Color? fillColor;
  final bool filled;
  final String? errorText;
  final String? helperText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final Color? cursorColor;
  final double? cursorHeight;
  final double? cursorWidth;
  final bool showCursor;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? minLines;
  final bool enableInteractiveSelection;
  final TextDirection? textDirection;
  final String? Function(String?)? onSaved;
  final AutovalidateMode? autovalidateMode;
  final Iterable<String>? autofillHints;
  final String obscuringCharacter;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final bool enablePredictiveText;
  final MouseCursor? mouseCursor;
  final bool? enableTapToSelectAll;
  final bool? enableTapToSelectAllOnFocus;
  final bool? enableTapToSelectAllOnLongPress;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.hintText,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.fillColor,
    this.filled = false,
    this.errorText,
    this.helperText,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.helperStyle,
    this.cursorColor,
    this.cursorHeight,
    this.cursorWidth,
    this.showCursor = true,
    this.expands = false,
    this.textAlignVertical,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.minLines,
    this.enableInteractiveSelection = true,
    this.textDirection,
    this.onSaved,
    this.autovalidateMode,
    this.autofillHints,
    this.obscuringCharacter = '•',
    this.scrollController,
    this.scrollPhysics,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.enablePredictiveText = true,
    this.mouseCursor,
    this.enableTapToSelectAll,
    this.enableTapToSelectAllOnFocus,
    this.enableTapToSelectAllOnLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: labelStyle ?? theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onSubmitted,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          focusNode: focusNode,
          textCapitalization: textCapitalization,
          textAlign: textAlign,
          autofocus: autofocus,
          style: theme.textTheme.bodyLarge,
          cursorColor: cursorColor ?? theme.colorScheme.primary,
          cursorHeight: cursorHeight,
          cursorWidth: cursorWidth ?? 2.0,
          showCursor: showCursor,
          expands: expands,
          textAlignVertical: textAlignVertical,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          minLines: minLines,
          enableInteractiveSelection: enableInteractiveSelection,
          textDirection: textDirection,
          onSaved: onSaved,
          autovalidateMode: autovalidateMode,
          autofillHints: autofillHints,
          obscuringCharacter: obscuringCharacter,
          scrollController: scrollController,
          scrollPhysics: scrollPhysics,
          restorationId: restorationId,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
          mouseCursor: mouseCursor,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: hintStyle ?? theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            isDense: true,
            contentPadding: contentPadding ?? const EdgeInsets.all(12),
            border: border ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),
            enabledBorder: enabledBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),
            focusedBorder: focusedBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: errorBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
              ),
            ),
            focusedErrorBorder: errorBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            fillColor: fillColor ?? theme.cardColor,
            filled: filled,
            errorText: errorText,
            errorStyle: errorStyle ?? theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            helperText: helperText,
            helperStyle: helperStyle ?? theme.textTheme.bodySmall,
            helperMaxLines: 2,
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}

// Example usage:
// CustomTextField(
//   controller: _emailController,
//   label: 'Email',
//   hint: 'Enter your email',
//   keyboardType: TextInputType.emailAddress,
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     if (!value.contains('@')) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   },
// )
