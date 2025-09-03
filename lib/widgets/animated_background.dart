import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;

  const AnimatedBackground({
    super.key,
    required this.child,
    required this.colors,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Bubble> _bubbles;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _bubbles = List.generate(12, (index) => Bubble.random());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.colors,
        ),
      ),
      child: Stack(
        children: [
          // 动画气泡背景
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: BubblePainter(
                  bubbles: _bubbles,
                  animation: _animationController,
                ),
                size: Size.infinite,
              );
            },
          ),
          // 主要内容
          widget.child,
        ],
      ),
    );
  }
}

class Bubble {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final Color color;
  final double phase;

  Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.color,
    required this.phase,
  });

  factory Bubble.random() {
    final random = math.Random();
    return Bubble(
      x: random.nextDouble(),
      y: random.nextDouble(),
      radius: 20 + random.nextDouble() * 60,
      speed: 0.5 + random.nextDouble() * 1.5,
      color: Colors.white.withOpacity(0.1 + random.nextDouble() * 0.15),
      phase: random.nextDouble() * 2 * math.pi,
    );
  }
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final Animation<double> animation;

  BubblePainter({
    required this.bubbles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final paint = Paint()
        ..color = bubble.color
        ..style = PaintingStyle.fill;

      // 计算气泡位置（带有浮动动画）
      final animationValue = animation.value;
      final x = (bubble.x * size.width) + 
          math.sin(animationValue * 2 * math.pi * bubble.speed + bubble.phase) * 30;
      final y = (bubble.y * size.height) + 
          math.cos(animationValue * 2 * math.pi * bubble.speed + bubble.phase) * 20;

      // 绘制气泡
      canvas.drawCircle(
        Offset(x, y),
        bubble.radius,
        paint,
      );

      // 绘制气泡的光晕效果
      final glowPaint = Paint()
        ..color = bubble.color.withOpacity(bubble.color.opacity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(
        Offset(x, y),
        bubble.radius * 1.5,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FloatingBubbleWidget extends StatefulWidget {
  final Widget child;

  const FloatingBubbleWidget({super.key, required this.child});

  @override
  State<FloatingBubbleWidget> createState() => _FloatingBubbleWidgetState();
}

class _FloatingBubbleWidgetState extends State<FloatingBubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        );
      },
    );
  }
}
