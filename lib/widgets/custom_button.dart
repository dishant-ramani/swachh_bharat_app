import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final Color? textColor;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final bool isLoading;
  final Color? disabledColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.textColor,
    this.fullWidth = true,
    this.padding,
    this.elevation,
    this.borderRadius,
    this.height,
    this.width,
    this.isLoading = false,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor ?? Colors.white,
          elevation: elevation ?? 2,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          disabledBackgroundColor: disabledColor ?? theme.disabledColor.withOpacity(0.5),
          disabledForegroundColor: Colors.white70,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : child,
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = color ?? theme.primaryColor;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: decoration,
        ),
        child: child,
      ),
    );
  }
}
