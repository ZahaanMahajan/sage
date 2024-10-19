import 'package:flutter/material.dart';
import 'package:sage_app/core/constants/colors.dart';
import 'package:sage_app/core/constants/dimensions.dart';
import 'package:sage_app/core/constants/string_manager.dart';
import 'package:sage_app/core/utils/validators.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.controller,
    required this.label,
    required this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.borderRadius,
    this.filledColor,
    this.borderColor,
    this.readOnly,
    this.onTap,
    this.textStyle,
    this.onChanged,
    this.focusNode,
    super.key,
  });

  const InputField.name({
    required TextEditingController controller,
    String? label,
    TextInputAction textInputAction = TextInputAction.next,
    void Function()? onTap,
    TextStyle? textStyle,
    String? prefixIcon,
    Key? key,
    FocusNode? focusNode,
  }) : this(
          key: key,
          controller: controller,
          label: label ?? "Name",
          textInputAction: textInputAction,
          keyboardType: TextInputType.name,
          autofillHints: const [AutofillHints.name],
          validator: Validators.required,
          textStyle: textStyle,
          prefixIcon: prefixIcon,
          onTap: onTap,
          focusNode: focusNode,
        );

  const InputField.email({
    required TextEditingController controller,
    String? label,
    TextInputAction textInputAction = TextInputAction.next,
    TextStyle? textStyle,
    FocusNode? focusNode,
    Key? key,
  }) : this(
          key: key,
          controller: controller,
          label: label ?? 'Email',
          textInputAction: textInputAction,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          validator: Validators.email,
          textStyle: textStyle,
          prefixIcon: StringManager.personIcon,
          focusNode: focusNode,
        );

  const InputField.password({
    required TextEditingController controller,
    String? label,
    TextInputAction textInputAction = TextInputAction.next,
    ValueChanged<String>? onFieldSubmitted,
    TextStyle? textStyle,
    FocusNode? focusNode,
    Key? key,
  }) : this(
          key: key,
          controller: controller,
          label: label ?? 'Password',
          textInputAction: textInputAction,
          keyboardType: TextInputType.visiblePassword,
          autofillHints: const [AutofillHints.password],
          validator: Validators.password,
          onFieldSubmitted: onFieldSubmitted,
          textStyle: textStyle,
          prefixIcon: StringManager.passwordIcon,
          focusNode: focusNode,
        );

  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final int? maxLines;
  final List<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final double? borderRadius;
  final Color? filledColor;
  final Color? borderColor;
  final bool? readOnly;
  final void Function()? onTap;
  final String? prefixIcon;
  final TextStyle? textStyle;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;
  late bool _isPassword;
  late FocusNode _focusNode;
  late ValueNotifier<Color> _fillColor;

  @override
  void initState() {
    super.initState();
    _isPassword = widget.keyboardType == TextInputType.visiblePassword;
    _obscureText = _isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _fillColor = ValueNotifier<Color>(const Color(0xFFFFFFFF));
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _fillColor.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyboardType != widget.keyboardType) {
      _isPassword = widget.keyboardType == TextInputType.visiblePassword;
      _obscureText = _isPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    final validator =
        widget.validator ?? Validators.getValidator(widget.keyboardType);

    return ValueListenableBuilder<Color>(
        valueListenable: _fillColor,
        builder: (context, fillColor, child) {
          return TextFormField(
            maxLines: widget.maxLines ?? 1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: _obscureText,
            validator: validator,
            readOnly: widget.readOnly ?? false,
            autofillHints: widget.autofillHints,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            style: widget.textStyle ??
                const TextStyle(
                  color: Color(0xFF1A1E25),
                  fontSize: 18,
                ),
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Image.asset(
                        widget.prefixIcon ?? StringManager.searchIcon,
                        height: 24,
                        width: 24,
                        color: _focusNode.hasFocus ? primaryColor : greyColor,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? radiusRound,
                ),
                borderSide: BorderSide(
                  color: widget.borderColor ?? const Color(0xFFE3E3E7),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? radiusRound,
                ),
                borderSide: const BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? radiusRound,
                ),
                borderSide: BorderSide(
                  color: widget.borderColor ?? defaultBorderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? radiusRound,
                ),
                borderSide: BorderSide(
                  color: widget.borderColor ?? enabledBorderColor,
                ),
              ),
              filled: true,
              fillColor: fillColor,
              hintText: widget.label,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: greyColor,
                    fontWeight: FontWeight.w500,
                  ),
              suffixIcon: _isPassword
                  ? IconButton(
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                      icon: _obscureText
                          ? Icon(
                              Icons.visibility_off,
                              size: 22,
                              color: _focusNode.hasFocus
                                  ? primaryColor
                                  : greyColor,
                            )
                          : Icon(
                              Icons.visibility_sharp,
                              size: 22,
                              color: _focusNode.hasFocus
                                  ? primaryColor
                                  : greyColor,
                            ),
                    )
                  : null,
            ),
          );
        });
  }
}
