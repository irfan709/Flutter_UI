import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to ChatApp',
      description:
          'Connect with friends and family instantly with our secure messaging platform',
      icon: Icons.chat_bubble_outline_rounded,
      color: Color(0xFF6C63FF),
      gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
      backgroundGradient: [
        Color(0xFF1a1a2e),
        Color(0xFF16213e),
        Color(0xFF0f3460),
      ],
    ),
    OnboardingData(
      title: 'Real-time Messaging',
      description:
          'Send and receive messages instantly with read receipts and typing indicators',
      icon: Icons.flash_on_outlined,
      color: Color(0xFF00D4AA),
      gradient: [Color(0xFF11998e), Color(0xFF38ef7d)],
      backgroundGradient: [Color(0xFF134e5e), Color(0xFF71b280)],
    ),
    OnboardingData(
      title: 'Secure & Private',
      description:
          'Your conversations are protected with end-to-end encryption for complete privacy',
      icon: Icons.security_outlined,
      color: Color(0xFFFF6B6B),
      gradient: [Color(0xFFee0979), Color(0xFFff6a00)],
      backgroundGradient: [Color(0xFF2c1810), Color(0xFF8b4513)],
    ),
    OnboardingData(
      title: 'Rich Media Sharing',
      description:
          'Share photos, videos, documents and voice messages with ease',
      icon: Icons.collections_outlined,
      color: Color(0xFF4ECDC4),
      gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      backgroundGradient: [Color(0xFF232526), Color(0xFF414345)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    HapticFeedback.selectionClick();
    _animationController.reset();
    _scaleController.reset();
    _animationController.forward();
    _scaleController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AuthenticationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _pages[_currentPage].backgroundGradient,
          ),
        ),
        child: Stack(
          children: [
            // Floating Particles Background
            ...List.generate(
              20,
              (index) => _buildFloatingParticle(size, index),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    children: [
                      // Navigation Header with Glassmorphism
                      _buildGlassHeader(),

                      // PageView Content
                      SizedBox(
                        height: size.height * 0.55,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemCount: _pages.length,
                          itemBuilder: (context, index) {
                            return _buildPageContent(_pages[index], size);
                          },
                        ),
                      ),

                      // Bottom Controls with Glass Effect
                      _buildGlassBottomControls(size),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(Size size, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          left: (index * 37.0) % size.width,
          top: (index * 23.0) % size.height,
          child: Transform.translate(
            offset: Offset(
              20 * _animationController.value * (index.isEven ? 1 : -1),
              30 * _animationController.value,
            ),
            child: Container(
              width: 4 + (index % 3) * 2.0,
              height: 4 + (index % 3) * 2.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1 + (index % 3) * 0.05),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _buildGlassHeader() {
  //   return Container(
  //     margin: const EdgeInsets.all(20),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(25),
  //       child: BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withValues(alpha: 0.1),
  //             borderRadius: BorderRadius.circular(25),
  //             border: Border.all(
  //               color: Colors.white.withValues(alpha: 0.2),
  //               width: 1.5,
  //             ),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               if (_currentPage > 0)
  //                 _buildGlassButton(
  //                   icon: Icons.arrow_back_ios_rounded,
  //                   text: 'Back',
  //                   onTap: _previousPage,
  //                 )
  //               else
  //                 const SizedBox(width: 60),
  //
  //               if (_currentPage < _pages.length - 1)
  //                 _buildGlassButton(text: 'Skip', onTap: _skipOnboarding)
  //               else
  //                 const SizedBox(width: 60),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGlassHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            _buildGlassButton(
              icon: Icons.arrow_back_ios_rounded,
              text: 'Back',
              onTap: _previousPage,
            )
          else
            const SizedBox(width: 60),

          if (_currentPage < _pages.length - 1)
            _buildGlassButton(text: 'Skip', onTap: _skipOnboarding)
          else
            const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    IconData? icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingData data, Size size) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Glassmorphism Icon Container
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: data.gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(data.icon, size: 60, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),

              // Title with Enhanced Typography
              Text(
                data.title,
                style: TextStyle(
                  fontSize: size.width > 350 ? 32 : 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: size.height * 0.02),

              // Description with Glass Background
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  data.description,
                  style: TextStyle(
                    fontSize: size.width > 350 ? 16 : 14,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.6,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildGlassBottomControls(Size size) {
  //   return Container(
  //     height: size.height * 0.25,
  //     padding: const EdgeInsets.all(30),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(30),
  //       child: BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
  //         child: Container(
  //           padding: const EdgeInsets.all(25),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withValues(alpha: 0.1),
  //             borderRadius: BorderRadius.circular(30),
  //             border: Border.all(
  //               color: Colors.white.withValues(alpha: 0.2),
  //               width: 1.5,
  //             ),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               // Enhanced Page Indicators
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: _buildEnhancedPageIndicators(),
  //               ),
  //
  //               const SizedBox(height: 8),
  //
  //               // Modern Progress Bar
  //               Container(
  //                 height: 6,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white.withValues(alpha: 0.2),
  //                   borderRadius: BorderRadius.circular(3),
  //                 ),
  //                 child: Stack(
  //                   children: [
  //                     AnimatedContainer(
  //                       duration: const Duration(milliseconds: 400),
  //                       width:
  //                           (size.width - 120) *
  //                           ((_currentPage + 1) / _pages.length),
  //                       decoration: BoxDecoration(
  //                         gradient: LinearGradient(
  //                           colors: _pages[_currentPage].gradient,
  //                         ),
  //                         borderRadius: BorderRadius.circular(3),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 15),
  //
  //               // Enhanced Action Button
  //               Container(
  //                 width: double.infinity,
  //                 height: 55,
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: _pages[_currentPage].gradient,
  //                     begin: Alignment.topLeft,
  //                     end: Alignment.bottomRight,
  //                   ),
  //                   borderRadius: BorderRadius.circular(30),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: _pages[_currentPage].color.withValues(
  //                         alpha: 0.4,
  //                       ),
  //                       blurRadius: 20,
  //                       offset: const Offset(0, 10),
  //                     ),
  //                   ],
  //                 ),
  //                 child: ElevatedButton(
  //                   onPressed: _nextPage,
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.transparent,
  //                     shadowColor: Colors.transparent,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(30),
  //                     ),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         _currentPage == _pages.length - 1
  //                             ? 'Get Started'
  //                             : 'Continue',
  //                         style: const TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 10),
  //                       const Icon(
  //                         Icons.arrow_forward_rounded,
  //                         color: Colors.white,
  //                         size: 20,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGlassBottomControls(Size size) {
    return Container(
      height: size.height * 0.22, // Reduced from 0.25 to 0.22
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Reduced vertical padding
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed from spaceEvenly
              children: [
                // Enhanced Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildEnhancedPageIndicators(),
                ),

                // Modern Progress Bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: (size.width - 120) * ((_currentPage + 1) / _pages.length),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _pages[_currentPage].gradient,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),

                // Enhanced Action Button
                Container(
                  width: double.infinity,
                  height: 50, // Reduced from 55 to 50
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _pages[_currentPage].gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25), // Adjusted radius
                    boxShadow: [
                      BoxShadow(
                        color: _pages[_currentPage].color.withValues(alpha: 0.4),
                        blurRadius: 15, // Reduced blur
                        offset: const Offset(0, 8), // Reduced offset
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                          style: const TextStyle(
                            fontSize: 16, // Reduced from 18 to 16
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8), // Reduced from 10 to 8
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18, // Reduced from 20 to 18
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEnhancedPageIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 10,
          width: _currentPage == i ? 30 : 10,
          decoration: BoxDecoration(
            gradient: _currentPage == i
                ? LinearGradient(colors: _pages[i].gradient)
                : null,
            color: _currentPage == i
                ? null
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(5),
            boxShadow: _currentPage == i
                ? [
                    BoxShadow(
                      color: _pages[i].color.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
        ),
      );
    }
    return indicators;
  }
}

// Enhanced Data Model
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final List<Color> backgroundGradient;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.backgroundGradient,
  });
}

// Enhanced Authentication Screen
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // Glass Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF667eea,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.verified_user_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 30),

                            const Text(
                              'Ready to start chatting!',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 15),

                            Text(
                              'Join millions of users worldwide',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 40),

                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF667eea,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => LoginScreen(),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Continue to Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
