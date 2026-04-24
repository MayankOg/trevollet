import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:trevollet/signup.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    Future.delayed(Duration(milliseconds: 200), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1b3a),
              Color(0xFF2d2f5f),
              Color(0xFF4a4d7c),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildStars(),
              _buildContent(),
              buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStars() {
    return Positioned.fill(
      child: CustomPaint(
        painter: LoginStarsPainter(),
      ),
    );
  }

  Widget _buildContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 400),
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildWelcomeText(context),
                  SizedBox(height: 40),
                  _buildEmailField(),
                  SizedBox(height: 20),
                  _buildPasswordField(),
                  SizedBox(height: 16),
                  _buildForgotPassword(),
                  SizedBox(height: 32),
                  _buildSignInButton(),
                  SizedBox(height: 32),
                  _buildDivider(),
                  SizedBox(height: 24),
                  _buildSocialButtons(),
                  SizedBox(height: 32),
                  _buildSignUpLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side text (expands, avoids overflow)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis, // prevent overflow
              ),
              SizedBox(height: 8),
              Text(
                'Sign in to continue your journey',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        SizedBox(width: 12),

        // Glassy "Skip" button
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04, // scale with screen
            vertical: MediaQuery.of(context).size.height * 0.008,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          child: InkWell(
            onTap: () {
              // Navigate as guest
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.035, // scalable font
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _emailController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Email or Phone',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          hintText: 'Enter your email or phone number',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _passwordController,
        style: TextStyle(color: Colors.white),
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          hintText: 'Enter your password',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Handle forgot password
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle sign in
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          'Sign In',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            'Google',
            Icons.g_mobiledata,
                () {
              // Handle Google sign in
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildSocialButton(
            'Apple',
            Icons.apple,
                () {
              // Handle Apple sign in
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(String text, IconData icon, VoidCallback onTap) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, BottomUpRoute(page: SignUpScreen()));
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF667eea),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSkipSignInButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navigate to your main/home screen
        Navigator.pushReplacementNamed(context, '/home');
      },
      child: Text(
        'Skip Sign In',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

}
Widget buildBottomBar(BuildContext context) {
  void _showBottomSheet(String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF1a1b3a),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        content,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      height: 82,
      decoration: BoxDecoration(
        color: Color(0xFF1a1b3a).withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'By continuing, you agree to our',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _showBottomSheet("Privacy Policy", _privacyPolicy);
                  },
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Color(0xFF667eea),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  ' and ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showBottomSheet("Terms of Service", _termsOfService);
                  },
                  child: Text(
                    'Terms of Service',
                    style: TextStyle(
                      color: Color(0xFF667eea),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

const String _privacyPolicy = """
Trevollet Privacy Policy

Effective Date: August 29, 2025

Trevollet values your privacy. This policy explains how we collect, use, and protect your personal data.

1. Data We Collect
- Account details: Name, email, phone number (for login and communication).
- Subscription details: Payment information processed securely via third-party providers.
- Usage data: Your travel preferences, packages viewed, and AI trip planning interactions.

2. How We Use Your Data
- To provide AI-powered travel planning.
- To manage subscriptions and payments.
- To recommend travel packages and offers.
- To notify you about monthly draws, updates, and promotions.

3. Data Sharing
- We do not sell your data.
- Payments are securely processed through trusted providers.
- Data may be shared with travel partners for bookings only with your consent.

4. Your Rights
- You can request data deletion or modification anytime.
- You may opt out of promotional messages.

For any privacy concerns, contact us at support@trevollet.com.
""";
const String _termsOfService = """
Trevollet Terms of Service

Effective Date: August 29, 2025

Welcome to Trevollet! By using our app, you agree to these terms.

1. Service Scope
Trevollet provides AI-based trip planning, travel package browsing, subscription benefits, and monthly draws.

2. Subscriptions & Payments
- Premium subscription is billed monthly.
- Payments are non-refundable once processed.
- Access to premium features requires an active subscription.

3. User Responsibilities
- Provide accurate account details.
- Use Trevollet for personal, non-commercial purposes.
- Do not misuse the platform or attempt fraudulent bookings.

4. Rewards & Draws
- Monthly draws are subject to eligibility.
- Trevollet’s decision on winners is final.

5. Liability
- Trevollet is a facilitator for travel planning and not responsible for third-party service issues (e.g., hotels, flights).
- We strive for accurate AI suggestions but cannot guarantee absolute accuracy.

6. Changes
- Trevollet may update these terms from time to time.
- Continued use of the app means you accept the updated terms.

For support or queries, contact support@trevollet.com.
""";

class LoginStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
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

    for (var star in stars) {
      canvas.drawCircle(star, 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BottomUpRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  BottomUpRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;

      final tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
