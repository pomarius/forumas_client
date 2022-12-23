import 'package:flutter/material.dart';

import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';

class UserTile extends StatelessWidget {
  final int index;
  final int lastIndex;
  final String username;

  const UserTile({super.key, required this.index, required this.lastIndex, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.baselineGrid * 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: index == 0 && index == lastIndex
            ? BorderRadius.circular(Dimens.cornerRadius)
            : index == 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(Dimens.cornerRadius),
                    topRight: Radius.circular(Dimens.cornerRadius),
                  )
                : index == lastIndex
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(Dimens.cornerRadius),
                        bottomRight: Radius.circular(Dimens.cornerRadius),
                      )
                    : null,
        border: index == 0
            ? Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))
            : Border(
                top: index != 0
                    ? BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))
                    : BorderSide.none,
                bottom: index == lastIndex
                    ? BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2))
                    : BorderSide.none,
                left: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
                right: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: AppTextStyles.description.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
