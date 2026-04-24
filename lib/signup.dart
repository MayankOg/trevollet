import 'package:flutter/material.dart';

import 'loginscreen.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  TextEditingController _nameController = TextEditingController();
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 200), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
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
              Positioned.fill(child: CustomPaint(painter: LoginStarsPainter())),
              _buildContent(context),
              buildBottomBar(context), // reuses your bottom bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
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
                  _buildTitle(context),
                  SizedBox(height: 40),
                  _buildNameField(),
                  SizedBox(height: 20),
                  _buildEmailField(),
                  SizedBox(height: 20),
                  _buildPasswordField(),
                  SizedBox(height: 32),
                  _buildSignUpButton(),
                  SizedBox(height: 24),
                  _buildSignInLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Join Trevollet to start exploring',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
        _buildSkipButton(context),
      ],
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: Text(
          "Skip",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() => _buildGlassField(
    controller: _nameController,
    label: "Full Name",
    hint: "Enter your name",
  );

  Widget _buildEmailField() => _buildGlassField(
    controller: _emailController,
    label: "Email",
    hint: "Enter your email",
    keyboardType: TextInputType.emailAddress,
  );

  Widget _buildPasswordField() => _buildGlassField(
    controller: _passwordController,
    label: "Password",
    hint: "Create a password",
    obscureText: _obscurePassword,
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
  );

  Widget _buildGlassField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
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
          // Handle sign up logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
        child: Text(
          'Sign Up',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // go back to login
          },
          child: Text(
            'Sign In',
            style: TextStyle(color: Color(0xFF667eea), fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
