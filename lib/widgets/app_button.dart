import 'package:flutter/material.dart';

import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({super.key, required this.child, this.onTap, this.backgroundColor, this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(Dimens.cornerRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.baselineGrid * 3),
            child: Center(
              child: Theme(
                data: ThemeData(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                child: DefaultTextStyle(
                  style: AppTextStyles.button.copyWith(
                    color: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
