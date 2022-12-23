import 'package:flutter/material.dart';

import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const AppTextButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.cornerRadius)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Dimens.baselineGrid),
            child: Center(
              child: Theme(
                data: ThemeData(
                  colorScheme: Theme.of(context).colorScheme.copyWith(primary: Theme.of(context).colorScheme.primary),
                ),
                child: Text(
                  text,
                  style: AppTextStyles.textButton.copyWith(color: Theme.of(context).colorScheme.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
