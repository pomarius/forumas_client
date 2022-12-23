import 'package:flutter/material.dart';

class AnimatedIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const AnimatedIndexedStack({
    Key? key,
    required this.index,
    required this.children,
  }) : super(key: key);

  @override
  State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeOutAnimation;
  late final Animation<double> _fadeInAnimation;
  late final Animation<double> _scaleAnimation;
  late int _index;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeOutAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _scaleAnimation = Tween(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _index = widget.index;
    _controller.addListener(_controllerListener);
    _controller.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != _index) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: widget.index == _index ? _fadeInAnimation.value : _fadeOutAnimation.value,
          child: Transform.scale(
            scale: widget.index == _index ? _scaleAnimation.value : 1,
            child: child,
          ),
        );
      },
      child: IndexedStack(
        index: _index,
        children: widget.children,
      ),
    );
  }

  void _controllerListener() {
    if (_controller.value >= 0.3 && widget.index != _index) {
      setState(() => _index = widget.index);
    }
  }
}
