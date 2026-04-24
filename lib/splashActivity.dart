import 'package:flutter/material.dart';

class TrevolletSplash extends StatefulWidget {
  final bool isLoader;
  final VoidCallback? onSplashComplete;
  final Duration splashDuration;

  const TrevolletSplash({
    Key? key,
    this.isLoader = false,
    this.onSplashComplete,
    this.splashDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<TrevolletSplash> createState() => _TrevolletSplashState();
}

class _TrevolletSplashState extends State<TrevolletSplash>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeInOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animations
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
    _rotateController.forward();

    // Start pulse animation
    _pulseController.repeat(reverse: true);

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // If not used as loader, navigate after splash duration
    if (!widget.isLoader && widget.onSplashComplete != null) {
      await Future.delayed(widget.splashDuration);
      widget.onSplashComplete!();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A1B69), // Deep purple top
              Color(0xFF4A2C7A), // Purple
              Color(0xFF8B4B9C), // Purple-pink
              Color(0xFFE65C00), // Orange
              Color(0xFFFF8C42), // Light orange
            ],
            stops: [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _fadeAnimation,
                      _scaleAnimation,
                      _rotateAnimation,
                      _pulseAnimation,
                    ]),
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Transform.scale(
                          scale: _scaleAnimation.value * _pulseAnimation.value,
                          child: Transform.rotate(
                            angle: _rotateAnimation.value * 0.05, // Subtle rotation
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(110),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF8C42).withOpacity(0.4),
                                    blurRadius: 40,
                                    spreadRadius: 15,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFE65C00).withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(110),
                                child: Image.asset(
                                  'images/logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback UI if image not found - matches the logo design
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: const RadialGradient(
                                          center: Alignment.center,
                                          colors: [
                                            Color(0xFF1E88E5), // Blue center
                                            Color(0xFF0D47A1), // Darker blue
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(110),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Money/bills flying animation
                                          Positioned.fill(
                                            child: CustomPaint(
                                              painter: MoneyBillsPainter(),
                                            ),
                                          ),
                                          // Wallet/card in center
                                          Center(
                                            child: Container(
                                              width: 120,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1976D2),
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'trevollet',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // App Name
              AnimatedBuilder(
                animation: _textFadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _textFadeAnimation,
                    child: const Text(
                      'trevollet',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Tagline
              AnimatedBuilder(
                animation: _textFadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _textFadeAnimation,
                    child: const Text(
                      'SAVE • TRAVEL • EXPLORE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFF3E0),
                        letterSpacing: 1.8,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Loader (only show if isLoader is true)
              if (widget.isLoader) ...[
                const SizedBox(height: 40),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8C42)),
                  strokeWidth: 3,
                ),
              ],

              // Bottom Section
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // AI Powered Text
                        AnimatedBuilder(
                          animation: _textFadeAnimation,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _textFadeAnimation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.psychology_outlined,
                                      color: const Color(0xFFFF8C42),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'AI Powered',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Version
                        AnimatedBuilder(
                          animation: _textFadeAnimation,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _textFadeAnimation,
                              child: Text(
                                'Version 1.0.0',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the money bills animation in fallback logo
class MoneyBillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF8C42)
      ..style = PaintingStyle.fill;

    // Draw floating money bills around the wallet
    final billPositions = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.8),
    ];

    for (final pos in billPositions) {
      // Draw simple bill representation
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: pos, width: 20, height: 12),
          const Radius.circular(2),
        ),
        paint,
      );

      // Draw circle in center of bill
      canvas.drawCircle(
        pos,
        3,
        Paint()..color = const Color(0xFFFFF3E0),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
// Example usage as Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TrevolletSplash(
      isLoader: false,
      splashDuration: const Duration(seconds: 3),
      onSplashComplete: () {
        // Navigate to your main app screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainApp(), // Replace with your main screen
          ),
        );
      },
    );
  }
}

// Example usage as Loader
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TrevolletSplash(
      isLoader: true, // This will show the loading indicator
    );
  }
}

// Placeholder for your main app screen
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to Trevollet!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}