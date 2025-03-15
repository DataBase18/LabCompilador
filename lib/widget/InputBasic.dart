import 'package:flutter/material.dart';

class InputBasic extends StatelessWidget {
  const InputBasic(
      {super.key,
      this.labelText,
      this.leftIcon,
      this.placeholderHelp,
      this.rightIcon,
      this.inTextHelper,
      this.downTextHelper,
      this.validator,
      this.onChange,
      this.controller,
      this.isPassword,
      this.enabled,
      this.maxLines = 1,
      this.focus,
      this.autoFocus,
      this.onSubmit,
      this.controllerSelector,
      this.internPadding,
      this.fontSize,
      this.keyboard,
      this.onTabLeftIcon,
      this.onTabRightIcon,
      this.readOnly = false,
      this.onTab,
      this.onExitFocus,
      this.labelTopPosition=false, this.textInputAction});

  final String? labelText;
  final Widget? leftIcon;
  final Function? onTabLeftIcon;
  final String? placeholderHelp;
  final Widget? rightIcon;
  final Function? onTabRightIcon;
  final String? inTextHelper;
  final String? downTextHelper;
  final String? Function(String?)? validator;
  final Function(String)? onChange;
  final TextEditingController? controller;
  final bool? isPassword;
  final bool? enabled;
  final int? maxLines;
  final bool? autoFocus;
  final Function()? onSubmit;
  final TextSelectionControls? controllerSelector;
  final EdgeInsetsGeometry? internPadding;
  final double? fontSize;
  final TextInputType? keyboard;
  final bool readOnly;
  final Function()? onTab;
  final FocusNode? focus;
  final Function()? onExitFocus;
  final bool labelTopPosition;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    if (focus != null && onExitFocus != null) {
      focus!.addListener(() {
        if (!focus!.hasFocus) {
          onExitFocus!();
        }
      });
    }
    return TextFormField(
      readOnly: readOnly,
      keyboardType: keyboard,
      style: TextStyle(fontSize: fontSize),
      onFieldSubmitted: (String data) async {
        if (onSubmit != null) {
          await onSubmit!();
        }
      },
      textInputAction: textInputAction,
      onTap: onTab,
      selectionControls: controllerSelector,
      autofocus: autoFocus ?? false,
      maxLines: maxLines,
      enabled: enabled,
      obscureText: isPassword ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      onChanged: onChange,
      validator: validator,
      focusNode: focus,
      decoration: InputDecoration(
          alignLabelWithHint: labelTopPosition,
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: placeholderHelp,
          contentPadding: internPadding,
          suffixIcon: rightIcon != null
              ? GestureDetector(
                  child: SizedBox(
                    width: 50,
                    child: rightIcon,
                  ),
                  onTap: () {
                    if (onTabRightIcon != null) {
                      onTabRightIcon!();
                    }
                  },
                )
              : null,
          prefixIcon: leftIcon != null
              ? GestureDetector(
                  child: SizedBox(
                    width: 50,
                    child: leftIcon,
                  ),
                  onTap: () {
                    if (onTabLeftIcon != null) {
                      onTabLeftIcon!();
                    }
                  },
                )
              : null),
    );
  }
}
