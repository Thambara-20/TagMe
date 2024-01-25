// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class AnimatedStraightLine extends StatefulWidget {
  final double width;
  final double height;
  final Duration duration;
  final Color color;

  AnimatedStraightLine({
    required this.width,
    required this.height,
    this.duration = const Duration(seconds: 2),
    this.color = Colors.blue,
  });

  @override
  _AnimatedStraightLineState createState() => _AnimatedStraightLineState();
}

class _AnimatedStraightLineState extends State<AnimatedStraightLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: StraightLinePainter(_animation.value, widget.color),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class StraightLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  StraightLinePainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    const double startX = 0.0;
    final double endX = size.width * progress;
    final double startY = size.height / 2;
    final double endY = size.height / 2;

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
