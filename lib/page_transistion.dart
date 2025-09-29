import 'package:flutter/material.dart';

// Custom Route Transition Class
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final AxisDirection direction;
  final Duration duration;
  final Curve curve;

  SlidePageRoute({
    required this.child,
    this.direction = AxisDirection.left, // Default: slide from right to left
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    super.settings,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // Define slide direction offsets
           Offset beginOffset;
           Offset endOffset = Offset.zero;

           switch (direction) {
             case AxisDirection.up:
               beginOffset = const Offset(0.0, 1.0); // From bottom
               break;
             case AxisDirection.down:
               beginOffset = const Offset(0.0, -1.0); // From top
               break;
             case AxisDirection.left:
               beginOffset = const Offset(1.0, 0.0); // From right
               break;
             case AxisDirection.right:
               beginOffset = const Offset(-1.0, 0.0); // From left
               break;
           }

           // Create slide transition
           var slideTween = Tween<Offset>(
             begin: beginOffset,
             end: endOffset,
           ).chain(CurveTween(curve: curve));

           var slideAnimation = animation.drive(slideTween);

           // Create fade transition for current page (exit animation)
           var fadeOutTween = Tween<double>(
             begin: 1.0,
             end: 0.0,
           ).chain(CurveTween(curve: curve));

           var fadeOutAnimation = secondaryAnimation.drive(fadeOutTween);

           return Stack(
             children: [
               // Fade out the current page
               FadeTransition(
                 opacity: fadeOutAnimation,
                 child: SlideTransition(
                   position:
                       Tween<Offset>(
                         begin: Offset.zero,
                         end: direction == AxisDirection.left
                             ? const Offset(
                                 -1.0,
                                 0.0,
                               ) // Current page slides left
                             : direction == AxisDirection.right
                             ? const Offset(
                                 1.0,
                                 0.0,
                               ) // Current page slides right
                             : direction == AxisDirection.up
                             ? const Offset(0.0, -1.0) // Current page slides up
                             : const Offset(
                                 0.0,
                                 1.0,
                               ), // Current page slides down
                       ).animate(
                         CurvedAnimation(
                           parent: secondaryAnimation,
                           curve: curve,
                         ),
                       ),
                   child: Container(), // Placeholder for current page
                 ),
               ),
               // Slide in the new page
               SlideTransition(position: slideAnimation, child: child),
             ],
           );
         },
       );
}

// First Screen
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade100, Colors.blue.shade300],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 100, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Welcome to First Screen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Navigation Buttons with different slide directions
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildNavigationButton(
                    context,
                    'Slide Right to Left',
                    Icons.arrow_forward,
                    AxisDirection.left,
                    Colors.green,
                  ),
                  _buildNavigationButton(
                    context,
                    'Slide Left to Right',
                    Icons.arrow_back,
                    AxisDirection.right,
                    Colors.orange,
                  ),
                  _buildNavigationButton(
                    context,
                    'Slide Bottom to Top',
                    Icons.arrow_upward,
                    AxisDirection.up,
                    Colors.purple,
                  ),
                  _buildNavigationButton(
                    context,
                    'Slide Top to Bottom',
                    Icons.arrow_downward,
                    AxisDirection.down,
                    Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String text,
    IconData icon,
    AxisDirection direction,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          SlidePageRoute(
            child: SecondScreen(fromDirection: direction, color: color),
            direction: direction,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
          ),
        );
      },
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 4,
      ),
    );
  }
}

// Second Screen
class SecondScreen extends StatelessWidget {
  final AxisDirection fromDirection;
  final Color color;

  const SecondScreen({
    super.key,
    required this.fromDirection,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    String directionText = _getDirectionText();
    IconData directionIcon = _getDirectionIcon();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(directionIcon, size: 100, color: color),
              const SizedBox(height: 24),
              Text(
                'Second Screen',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Animated from: $directionText',
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Navigation buttons
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back (Pop)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        SlidePageRoute(
                          child: const ThirdScreen(),
                          direction: AxisDirection.left,
                          duration: const Duration(milliseconds: 350),
                        ),
                      );
                    },
                    icon: const Icon(Icons.navigate_next),
                    label: const Text('Next Screen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
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

  String _getDirectionText() {
    switch (fromDirection) {
      case AxisDirection.left:
        return 'Right to Left';
      case AxisDirection.right:
        return 'Left to Right';
      case AxisDirection.up:
        return 'Bottom to Top';
      case AxisDirection.down:
        return 'Top to Bottom';
    }
  }

  IconData _getDirectionIcon() {
    switch (fromDirection) {
      case AxisDirection.left:
        return Icons.arrow_forward;
      case AxisDirection.right:
        return Icons.arrow_back;
      case AxisDirection.up:
        return Icons.arrow_upward;
      case AxisDirection.down:
        return Icons.arrow_downward;
    }
  }
}

// Third Screen (for demonstration)
class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade100, Colors.teal.shade300],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                'Third Screen',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Navigation with custom transitions!',
                style: TextStyle(fontSize: 16, color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to First Screen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
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
