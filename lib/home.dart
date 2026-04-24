import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:trevollet/transition.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    Center(child: Text('Trips', style: TextStyle(color: Colors.white, fontSize: 24))),
    Center(child: Text('Wallet', style: TextStyle(color: Colors.white, fontSize: 24))),
    Center(child: Text('Profile', style: TextStyle(color: Colors.white, fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2D42),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildGlassBottomNav(),
    );
  }

  Widget _buildGlassBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: SafeArea(
          top: false, // avoid extra padding at top
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildNavItem(0, Icons.home_rounded, 'Home')),
                Expanded(child: _buildNavItem(1, Icons.map_rounded, 'Trips')),
                Expanded(child: _buildNavItem(2, Icons.chat, 'AI')),
                Expanded(child: _buildNavItem(3, Icons.person_rounded, 'Profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF4ECDC4).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? Color(0xFF4ECDC4) : Colors.white.withOpacity(0.6),
              size: 24,
            ),
          ),
          SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: TextStyle(
              color: isSelected ? Color(0xFF4ECDC4) : Colors.white.withOpacity(0.6),
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(label, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _starController;
  late AnimationController _balanceController;
  late AnimationController _cardController;
  late AnimationController _floatingController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _balanceCountAnimation;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _staggerController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _starController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _balanceController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _balanceCountAnimation = Tween<double>(
      begin: 0.0,
      end: 2850.0,
    ).animate(CurvedAnimation(
      parent: _balanceController,
      curve: Curves.easeOut,
    ));

    _cardSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    ));

    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(Duration(milliseconds: 200), () {
      _staggerController.forward();
    });

    Future.delayed(Duration(milliseconds: 800), () {
      _balanceController.forward();
      _cardController.forward();
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      _starController.repeat(reverse: true);
      _floatingController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _starController.dispose();
    _balanceController.dispose();
    _cardController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedStar(double left, double top, double size) {
    return AnimatedBuilder(
      animation: _starController,
      builder: (context, child) {
        return Positioned(
          left: left,
          top: top + (5 * _starController.value),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 1000),
            opacity: 0.3 + (0.4 * _starController.value),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: size * 2,
                    spreadRadius: size * 0.3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required Color iconColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _cardSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _cardSlideAnimation.value),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              onTap();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF3A3D5C).withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedTripCard(String place, String duration, String price) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 5 * _floatingAnimation.value),
          child: Container(
            width: 140,
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF3A3D5C).withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  duration,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    color: Color(0xFF4ECDC4),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2D42),
      body: SafeArea(
        child: Stack(
          children: [
            // Animated stars
            _buildAnimatedStar(100, 150, 2),
            _buildAnimatedStar(300, 120, 1.5),
            _buildAnimatedStar(50, 300, 1.8),
            _buildAnimatedStar(320, 280, 2.2),
            _buildAnimatedStar(200, 400, 1.5),
            _buildAnimatedStar(80, 500, 1.8),
            _buildAnimatedStar(350, 450, 2),

            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    // Travel Balance Card
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF3A3D5C).withOpacity(0.9),
                                Color(0xFF2B2D42).withOpacity(0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFB800),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.credit_card,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Travel Balance',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    AnimatedBuilder(

                                      animation: _balanceCountAnimation,
                                      builder: (context, child) {
                                        return Text(
                                          '₹${_balanceCountAnimation.value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4ECDC4).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color(0xFF4ECDC4),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '+ Add',
                                  style: TextStyle(
                                    color: Color(0xFF4ECDC4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Greeting
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Hey Traveler! ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '👋',
                                  style: TextStyle(fontSize: 28),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ready to explore the world?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Quick Actions
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    _buildQuickActionCard(
                      title: 'Plan with AI',
                      subtitle: 'Get personalized itineraries',
                      iconColor: Color(0xFF6366F1),
                      icon: Icons.psychology,
                      onTap: () {},
                    ),

                  _buildQuickActionCard(
                    title: 'Browse Packages',
                    subtitle: 'Curated trips & deals',
                    iconColor: const Color(0xFF4ECDC4),
                    icon: Icons.explore,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfullPurchase(),
                        ),
                      );
                    },
                  ),


                  SizedBox(height: 20),

                    // Current Contest
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Text(
                            '🎉 ',
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            'Current Contest',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    AnimatedBuilder(
                      animation: _cardSlideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _cardSlideAnimation.value),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFB800).withOpacity(0.2),
                                  Color(0xFFFF8C00).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xFFFFB800).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFB800),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.emoji_events,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Win a trip to Goa!',
                                        style: TextStyle(
                                          color: Color(0xFFFFB800),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Monthly draw for subscribers',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Ends in 12 days',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFB800),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '₹15,000',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 30),

                    // Saved Trips
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Text(
                            '🏞️ ',
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            'Saved Trips',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildSavedTripCard('Kerala', '5 days', '₹8,500'),
                          _buildSavedTripCard('Rajasthan', '7 days', '₹12,000'),
                          _buildSavedTripCard('Himachal', '6 days', '₹9,800'),
                        ],
                      ),
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}