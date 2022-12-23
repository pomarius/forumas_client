import 'package:flutter/material.dart';

import '../constants/theme/app_text_styles.dart';
import '../constants/theme/dimens.dart';
import '../utils/misc_utils.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final Widget? leading;
  final bool delay;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.delay = true,
    this.actions,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _startUpAnimation;
  double _expandedHeight = kToolbarHeight;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: widget.delay ? 0 : 1,
      duration: const Duration(milliseconds: 300),
    );
    _startUpAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        final double titleHeight = MiscUtils.getTextSize(Text(widget.title, style: AppTextStyles.title1),
                MediaQuery.of(context).size.width - Dimens.baselineGrid * 2)
            .height;
        _expandedHeight = titleHeight + kToolbarHeight + Dimens.baselineGrid * 4;
      });
    });

    if (widget.delay) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        if (mounted) {
          _animationController.forward();
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: _expandedHeight,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: AnimatedBuilder(
        animation: _startUpAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_expandedHeight + _expandedHeight * _startUpAnimation.value),
            child: child,
          );
        },
        child: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double percent = MiscUtils.getPercent(constraints.maxHeight, _expandedHeight, kToolbarHeight);

              return Stack(
                children: [
                  Container(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    height: kToolbarHeight,
                  ),
                  _buildTitle1(percent),
                  _buildTitle2(percent),
                  _buildDivider(),
                  if (widget.leading != null) _buildLeading(),
                  if (widget.actions != null) _buildActions(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle1(double percent) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimens.baselineGrid * 2,
          bottom: Dimens.baselineGrid * 2,
        ),
        child: Opacity(
          opacity: 1 - percent,
          child: Text(widget.title, style: AppTextStyles.title1),
        ),
      ),
    );
  }

  Widget _buildTitle2(double percent) {
    return Container(
      height: kToolbarHeight,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: widget.leading == null ? Dimens.baselineGrid * 2 : Dimens.baselineGrid * 2 + kToolbarHeight,
      ),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Transform.translate(
        offset: Offset(0, kToolbarHeight / 10 - (kToolbarHeight / 10) * percent),
        child: Opacity(
          opacity: percent,
          child: Text(widget.title, style: AppTextStyles.title2, maxLines: 1),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return SizedBox(
      height: kToolbarHeight,
      width: kToolbarHeight,
      child: widget.leading,
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(widget.actions!.length, (index) => widget.actions![index]),
    );
  }
}
