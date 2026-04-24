import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'loginscreen.dart';

class CircleRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  CircleRevealClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}


class TravelCarousel extends StatefulWidget {
  @override
  _TravelCarouselState createState() => _TravelCarouselState();
}

class _TravelCarouselState extends State<TravelCarousel>
    with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  late AnimationController _airplaneController;
  late Animation<double> _airplaneAnimation;

  double _scrollProgress = 0.0;
  bool _isAnimatingPlane = false;
  double _lastScrollPosition = 0.0;

  final List<Map<String, dynamic>> _timeContent = [
    {
      'title': 'PLAN\nSMART TRIPS',
      'subtitle': 'Dawn begins with Trevollet’s AI travel agent\ncrafting perfect journeys for you',
      'description': 'Dawn',
    },
    {
      'title': 'FIND\nBEST DEALS',
      'subtitle': 'Daylight uncovers exclusive packages\nand travel options at great value',
      'description': 'Day',
    },
    {
      'title': 'WIN\nREWARDS & DRAWS',
      'subtitle': 'Dusk brings exciting time-based draws\nwhere every traveler gets a chance',
      'description': 'Dusk',
    },
    {
      'title': 'SUBSCRIBE\nAND SAVE',
      'subtitle': 'Night unlocks premium benefits\nwith a monthly Trevollet membership',
      'description': 'Night',
    }
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    // Airplane animation
    _airplaneController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _airplaneAnimation = Tween<double>(
      begin: -1.2,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _airplaneController,
      curve: Curves.easeInOut,
    ));
  }

  void _onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    setState(() {
      _scrollProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    });

    // Trigger airplane animation on significant scroll
    double scrollDelta = (currentScroll - _lastScrollPosition).abs();
    if (scrollDelta > 100 && !_isAnimatingPlane) {
      _triggerAirplaneAnimation();
    }
    _lastScrollPosition = currentScroll;
  }

  void _triggerAirplaneAnimation() {
    if (!_isAnimatingPlane) {
      _isAnimatingPlane = true;
      _airplaneController.forward().then((_) {
        _airplaneController.reset();
        _isAnimatingPlane = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _airplaneController.dispose();
    super.dispose();
  }

  Color _interpolateColor(Color start, Color end, double progress) {
    return Color.lerp(start, end, progress) ?? start;
  }
  void _navigateToLogin(BuildContext context) {
    // Get screen center as fallback
    final screenSize = MediaQuery.of(context).size;
    Offset center = Offset(screenSize.width / 2, screenSize.height * 0.8);

    // Try to get button position safely
    try {
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final buttonPosition = renderBox.localToGlobal(Offset.zero);
        final buttonSize = renderBox.size;
        center = Offset(
          buttonPosition.dx + buttonSize.width / 2,
          buttonPosition.dy + buttonSize.height / 2,
        );
      }
    } catch (e) {
      // Use default center if there's any issue
      print('Using default center for animation');
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionDuration: Duration(milliseconds: 1200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Stack(
                children: [
                  // Your current carousel (fading out)
                  Opacity(
                    opacity: 1 - animation.value,
                    child: widget, // Reference to current widget
                  ),
                  // Expanding circle transition
                  ClipPath(
                    clipper: CircleRevealClipper(
                      center: center,
                      radius: animation.value * screenSize.height * 1.5,
                    ),
                    child: child,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Color> _getGradientColors(double progress) {
    // Define colors for each time of day
    List<List<Color>> timeGradients = [
      // Dawn (0.0 - 0.25)
      [
        Color(0xFF0f0f23),
        Color(0xFF1a1a2e),
        Color(0xFF16213e),
        Color(0xFF533483),
        Color(0xFFFF6B6B),
        Color(0xFFFFB347),
        Color(0xFFFFA726)
      ],
      // Day (0.25 - 0.5)
      [
        Color(0xFF87CEEB),
        Color(0xFF74b9ff),
        Color(0xFF0984e3),
        Color(0xFF74b9ff),
        Color(0xFFfdcb6e),
        Color(0xFFe17055),
        Color(0xFFfd79a8)
      ],
      // Dusk (0.5 - 0.75)
      [
        Color(0xFF2d3436),
        Color(0xFF636e72),
        Color(0xFF74b9ff),
        Color(0xFFa29bfe),
        Color(0xFFfd79a8),
        Color(0xFFfdcb6e),
        Color(0xFFe17055)
      ],
      // Night (0.75 - 1.0)
      [
        Color(0xFF000000),
        Color(0xFF0f0f23),
        Color(0xFF1a1a2e),
        Color(0xFF16213e),
        Color(0xFF2d3436),
        Color(0xFF533483),
        Color(0xFF2d3436)
      ]
    ];

    // Determine which gradients to interpolate between
    int currentIndex = (progress * 3).floor().clamp(0, 2);
    double localProgress = ((progress * 3) - currentIndex).clamp(0.0, 1.0);

    List<Color> currentGradient = timeGradients[currentIndex];
    List<Color> nextGradient = timeGradients[currentIndex + 1];

    List<Color> interpolatedGradient = [];
    for (int i = 0; i < currentGradient.length; i++) {
      interpolatedGradient.add(
          _interpolateColor(currentGradient[i], nextGradient[i], localProgress)
      );
    }

    return interpolatedGradient;
  }

  Widget _buildBackground() {
    List<Color> colors = _getGradientColors(_scrollProgress);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: [0.0, 0.15, 0.3, 0.45, 0.6, 0.8, 1.0],
        ),
      ),
    );
  }

  Widget _buildRotatingEarth() {
    double earthRotation = _scrollProgress * 2 * math.pi;

    return Positioned(
      bottom: -100,
      left: -50,
      right: -50,
      child: Transform.rotate(
        angle: earthRotation,
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.topLeft,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.3),
              ],
              stops: [0.0, 0.7, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: EarthSurfacePainter(),
          ),
        ),
      ),
    );
  }

  Widget _buildSunMoon() {
    // Sun rises from 0.0 to 0.5, then moon appears from 0.5 to 1.0
    double sunProgress = (_scrollProgress * 2).clamp(0.0, 1.0);
    bool isMoon = _scrollProgress > 0.5;

    // Calculate arc position
    double angle = sunProgress * math.pi;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double x = screenWidth * 0.5 + (screenWidth * 0.3 * math.cos(angle - math.pi / 2));
    double y = screenHeight * 0.6 - (screenHeight * 0.25 * math.sin(angle));

    return Positioned(
      left: x - 40,
      top: y - 40,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isMoon
                  ? Colors.white.withOpacity(0.3)
                  : Colors.yellow.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isMoon
                  ? [
                Color(0xFFE6E6FA),
                Color(0xFFD3D3D3),
                Color(0xFFA9A9A9),
              ]
                  : [
                Color(0xFFFFEB3B),
                Color(0xFFFFC107),
                Color(0xFFFF9800),
              ],
            ),
          ),
          child: isMoon
              ? CustomPaint(painter: MoonCratersPainter())
              : null,
        ),
      ),
    );
  }

  Widget _buildAirplane() {
    return AnimatedBuilder(
      animation: _airplaneAnimation,
      builder: (context, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        double progress = (_airplaneAnimation.value + 1.2) / 2.4;

        // Create flight path that follows scroll direction (horizontal)
        double x = screenWidth * progress;
        double y = screenHeight * 0.25 - (math.sin(progress * math.pi) * 40);

        return Positioned(
          left: x - 60,
          top: y,
          child: Transform.rotate(
            angle: math.sin(progress * math.pi) * 0.2,
            child: Opacity(
              opacity: _isAnimatingPlane ? 1.0 : 0.0,
              child: Container(
                width: 120,
                height: 60,
                child: Image.asset(
                  'images/flight.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTravelerSilhouette() {
    double travelerMovement = math.sin(_scrollProgress * 2 * math.pi) * 10;

    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.32,
      left: MediaQuery.of(context).size.width * 0.5 - 40 + travelerMovement,
      child: Container(
        width: 80,
        height: 120,
        child: Image.asset(
          'images/traveller.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildStars() {
    double starsOpacity = (_scrollProgress - 0.4).clamp(0.0, 1.0);
    if (starsOpacity <= 0) return SizedBox.shrink();

    return Positioned.fill(
      child: CustomPaint(
        painter: StarsPainter(
          opacity: starsOpacity,
          twinkle: _scrollProgress > 0.75,
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollingContent() {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: _timeContent.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> content = _timeContent[index];
        bool isLastSection = index == _timeContent.length - 1;
        bool showButton = _scrollProgress >= 0.95 && isLastSection;

        return Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Text(
                  content['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  content['subtitle'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                AnimatedOpacity(
                  opacity: showButton ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: showButton ? MediaQuery.of(context).size.width - 80 : 0,
                    height: showButton ? 56 : 0,
                    child: showButton
                        ? Builder(  // Add Builder widget here
                      builder: (buttonContext) => ElevatedButton(
                        onPressed: () {
                          _navigateToLogin(buttonContext); // Use buttonContext instead
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6B47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 12,
                          shadowColor: Color(0xFFFF6B47).withOpacity(0.4),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                        : SizedBox.shrink(),
                  ),
                ),
                SizedBox(height: 120),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScrollIndicator() {
    return Positioned(
      bottom: 50,
      left: 50,
      right: 50,
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white.withOpacity(0.3),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: _scrollProgress,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeIndicator() {
    return Positioned(
      bottom: 100,
      right: 30,
      child: AnimatedOpacity(
        opacity: _scrollProgress < 0.1 ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Swipe',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildStars(),
          _buildSunMoon(),
          _buildRotatingEarth(),
          _buildTravelerSilhouette(),
          _buildAirplane(),
          _buildHorizontalScrollingContent(),
          _buildScrollIndicator(),
          _buildSwipeIndicator(),
        ],
      ),
    );
  }
}

class EarthSurfacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw continent-like shapes
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.4, size.height * 0.2,
      size.width * 0.6, size.height * 0.35,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.4,
      size.width * 0.9, size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.7, size.height * 0.8,
      size.width * 0.3, size.height * 0.7,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MoonCratersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Draw moon craters
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.3), 4, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.4), 3, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), 5, paint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.6), 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StarsPainter extends CustomPainter {
  final double opacity;
  final bool twinkle;

  StarsPainter({required this.opacity, this.twinkle = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final stars = [
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.05),
      Offset(size.width * 0.7, size.height * 0.08),
      Offset(size.width * 0.9, size.height * 0.15),
      Offset(size.width * 0.15, size.height * 0.25),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.6, size.height * 0.2),
      Offset(size.width * 0.85, size.height * 0.12),
      Offset(size.width * 0.05, size.height * 0.4),
    ];

    for (int i = 0; i < stars.length; i++) {
      double radius = twinkle ? (2 + math.sin(i.toDouble()) * 1) : 2;
      canvas.drawCircle(stars[i], radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}