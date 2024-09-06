import 'package:flutter/cupertino.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool enabled;
  final Widget? suffix;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.textEditingController,
    this.enabled = true,
    this.suffix,
    this.placeholder,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.obscureText = false,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscureText = false;

  @override
  void initState() {
    isObscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: widget.textEditingController,
      onChanged: widget.onChanged,
      onSubmitted: (value) {
        widget.onSubmitted != null ? widget.onSubmitted!(value) : null;
      },
      obscureText: isObscureText,
      suffix: suffixWidget(),
      placeholder: widget.placeholder,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      padding: const EdgeInsets.all(10),
      style: const TextStyle(
        color: CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.black,
          darkColor: CupertinoColors.white,
        ),
      ),
      enabled: widget.enabled,
      prefix: widget.prefixIcon != null
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              child: Icon(
                widget.prefixIcon,
                color: const Color(0xFF007bfc),
              ),
            )
          : null,
      decoration: BoxDecoration(
        color: const Color(0xFFe3e3e8),
        border: Border.all(
          color: const Color(0xFF3a3a3c),
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      cursorColor: const Color(0xFF007bfc),
    );
  }

  Widget suffixWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.suffix ?? const SizedBox(),
        widget.obscureText
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  isObscureText
                      ? CupertinoIcons.eye_solid
                      : CupertinoIcons.eye_slash_fill,
                  color: const Color(0xFFa4a4aa),
                ),
                onPressed: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
              )
            : const SizedBox(),
      ],
    );
  }
}
