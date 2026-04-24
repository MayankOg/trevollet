import 'package:flutter/material.dart';
import 'dart:math' as math;

class SuccessfullPurchase extends StatefulWidget {
  const SuccessfullPurchase({Key? key}) : super(key: key);

  @override
  State<SuccessfullPurchase> createState() => _SuccessfullPurchaseState();
}

class _SuccessfullPurchaseState extends State<SuccessfullPurchase>
    with TickerProviderStateMixin {
  late AnimationController _handshakeController;
  late AnimationController _transitionController;
  late AnimationController _planeController;

  late Animation<double> _handshakeAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _planePathAnimation;
  late Animation<double> _planeRotationAnimation;
  late Animation<double> _scaleAnimation;

  bool _showPlane = false;

  @override
  void initState() {
    super.initState();

    // Handshake animation controller
    _handshakeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Transition animation controller
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Plane flight animation controller
    _planeController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Setup animations
    _handshakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _handshakeController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.elasticOut,
    ));

    _planePathAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _planeController,
      curve: Curves.easeInOut,
    ));

    _planeRotationAnimation = Tween<double>(
      begin: 0.2,
      end: -0.1,
    ).animate(CurvedAnimation(
      parent: _planeController,
      curve: Curves.easeInOut,
    ));

    // Start animation sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await _handshakeController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _showPlane = true;
    });
    _transitionController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _planeController.forward();
  }

  @override
  void dispose() {
    _handshakeController.dispose();
    _transitionController.dispose();
    _planeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1a1a3e),
            Color(0xFF2d1b69),
            Color(0xFF0f0c29),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background stars
          ...List.generate(20, (index) => _buildStar(index)),

          // Handshake animation
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: AnimatedBuilder(
                  animation: _handshakeAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(200, 200),
                      painter: HandshakePainter(
                        progress: _handshakeAnimation.value,
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Plane animation
          if (_showPlane)
            AnimatedBuilder(
              animation: Listenable.merge([
                _scaleAnimation,
                _planePathAnimation,
                _planeRotationAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: AnimatedBuilder(
                    animation: _planePathAnimation,
                    builder: (context, child) {
                      final path = _calculatePlanePath(_planePathAnimation.value);
                      return Transform.translate(
                        offset: path,
                        child: Transform.rotate(
                          angle: _planeRotationAnimation.value,
                          child: CustomPaint(
                            size: Size(80, 80),
                            painter: PlanePainter(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStar(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 3 + 1;
    final left = random.nextDouble() * 400;
    final top = random.nextDouble() * 800;
    final delay = random.nextDouble() * 2;

    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: _planeController,
        builder: (context, child) {
          return Opacity(
            opacity: (math.sin(_planeController.value * math.pi * 2 + delay) + 1) / 2,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }

  Offset _calculatePlanePath(double t) {
    final x = math.sin(t * math.pi) * 100 - 50;
    final y = -t * 200 + 100;
    return Offset(x, y);
  }
}

class HandshakePainter extends CustomPainter {
  final double progress;

  HandshakePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Gradient effect
    paint.shader = LinearGradient(
      colors: [
        Color(0xFF6b5b95),
        Color(0xFF9b59b6),
        Color(0xFFe74c3c),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final center = Offset(size.width / 2, size.height / 2);

    // Left hand
    final leftHandPath = Path();
    final leftHandX = center.dx - 30 + (progress * 10);
    leftHandPath.moveTo(leftHandX - 30, center.dy);
    leftHandPath.quadraticBezierTo(
      leftHandX - 10, center.dy - 10,
      leftHandX + 10, center.dy,
    );
    leftHandPath.lineTo(leftHandX + 10, center.dy + 20);
    leftHandPath.lineTo(leftHandX - 10, center.dy + 20);
    leftHandPath.lineTo(leftHandX - 10, center.dy + 5);

    // Right hand
    final rightHandPath = Path();
    final rightHandX = center.dx + 30 - (progress * 10);
    rightHandPath.moveTo(rightHandX + 30, center.dy);
    rightHandPath.quadraticBezierTo(
      rightHandX + 10, center.dy - 10,
      rightHandX - 10, center.dy,
    );
    rightHandPath.lineTo(rightHandX - 10, center.dy + 20);
    rightHandPath.lineTo(rightHandX + 10, center.dy + 20);
    rightHandPath.lineTo(rightHandX + 10, center.dy + 5);

    // Draw hands with shake effect
    canvas.save();
    canvas.translate(0, math.sin(progress * math.pi * 4) * 5);
    canvas.drawPath(leftHandPath, paint);
    canvas.drawPath(rightHandPath, paint);
    canvas.restore();

    // Draw connection lines
    if (progress > 0.3) {
      final sparkPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white.withOpacity(progress);

      for (int i = 0; i < 5; i++) {
        final angle = (math.pi * 2 / 5) * i + progress * math.pi;
        final sparkX = center.dx + math.cos(angle) * 40 * progress;
        final sparkY = center.dy + math.sin(angle) * 40 * progress;
        canvas.drawCircle(Offset(sparkX, sparkY), 2, sparkPaint);
      }
    }
  }

  @override
  bool shouldRepaint(HandshakePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class PlanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Plane gradient
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF9b59b6),
        Color(0xFFe74c3c),
        Color(0xFFf39c12),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    // Plane body
    path.moveTo(center.dx - 30, center.dy);
    path.lineTo(center.dx + 25, center.dy - 5);
    path.lineTo(center.dx + 30, center.dy);
    path.lineTo(center.dx + 25, center.dy + 5);
    path.lineTo(center.dx - 30, center.dy);

    // Wings
    path.moveTo(center.dx - 10, center.dy - 20);
    path.lineTo(center.dx + 5, center.dy);
    path.lineTo(center.dx - 10, center.dy + 20);
    path.lineTo(center.dx - 15, center.dy);
    path.close();

    // Tail
    path.moveTo(center.dx - 30, center.dy - 8);
    path.lineTo(center.dx - 20, center.dy);
    path.lineTo(center.dx - 30, center.dy + 8);

    canvas.drawPath(path, paint);

    // Trail effect
    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.5);

    for (int i = 0; i < 3; i++) {
      final trailPath = Path();
      trailPath.moveTo(center.dx - 30 - (i * 10), center.dy + (i * 2));
      trailPath.lineTo(center.dx - 40 - (i * 15), center.dy + (i * 2));
      canvas.drawPath(trailPath, trailPaint..color = Colors.white.withOpacity(0.5 - i * 0.15));
    }
  }

  @override
  bool shouldRepaint(PlanePainter oldDelegate) => false;
}