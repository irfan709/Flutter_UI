import 'package:flutter/material.dart';

class TransitionsExampleScreen extends StatefulWidget {
  const TransitionsExampleScreen({super.key});

  @override
  State<TransitionsExampleScreen> createState() =>
      _TransitionsExampleScreenState();
}

class _TransitionsExampleScreenState extends State<TransitionsExampleScreen>
    with TickerProviderStateMixin {
  // Animation Controllers for explicit animations
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _sizeController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _sizeAnimation;

  Alignment _alignment = Alignment.center;
  double _leftPosition = 50.0;
  double _topPosition = 50.0;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controllers
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _sizeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize Animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation =
        Tween<double>(
          begin: 0.0,
          end: 2.0, // 2 full rotations
        ).animate(
          CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
        );

    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sizeController, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Transitions Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Fade Transition
            _buildTransitionSection(
              '1. Fade Transition',
              'Animates opacity from 0 to 1',
              _buildFadeTransitionDemo(),
              () {
                if (_fadeController.status == AnimationStatus.completed) {
                  _fadeController.reverse();
                } else {
                  _fadeController.forward();
                }
              },
            ),

            const SizedBox(height: 24),

            // 2. Slide Transition
            _buildTransitionSection(
              '2. Slide Transition',
              'Animates position with offset values',
              _buildSlideTransitionDemo(),
              () {
                if (_slideController.status == AnimationStatus.completed) {
                  _slideController.reverse();
                } else {
                  _slideController.forward();
                }
              },
            ),

            const SizedBox(height: 24),

            // 3. Scale Transition
            _buildTransitionSection(
              '3. Scale Transition',
              'Animates size scaling from center',
              _buildScaleTransitionDemo(),
              () {
                if (_scaleController.status == AnimationStatus.completed) {
                  _scaleController.reverse();
                } else {
                  _scaleController.forward();
                }
              },
            ),

            const SizedBox(height: 24),

            // 4. Rotation Transition
            _buildTransitionSection(
              '4. Rotation Transition',
              'Rotates widget around its center',
              _buildRotationTransitionDemo(),
              () {
                if (_rotationController.status == AnimationStatus.completed) {
                  _rotationController.reset();
                }
                _rotationController.forward();
              },
            ),

            const SizedBox(height: 24),

            // 5. Size Transition
            _buildTransitionSection(
              '5. Size Transition',
              'Animates widget size with clipping',
              _buildSizeTransitionDemo(),
              () {
                if (_sizeController.status == AnimationStatus.completed) {
                  _sizeController.reverse();
                } else {
                  _sizeController.forward();
                }
              },
            ),

            const SizedBox(height: 24),

            // 6. Positioned Transition (AnimatedPositioned)
            _buildTransitionSection(
              '6. Positioned Transition',
              'Animates position within a Stack',
              _buildPositionedTransitionDemo(),
              () {
                setState(() {
                  _leftPosition = _leftPosition == 50.0 ? 200.0 : 50.0;
                  _topPosition = _topPosition == 50.0 ? 150.0 : 50.0;
                });
              },
            ),

            const SizedBox(height: 24),

            // 7. Align Transition (AnimatedAlign)
            _buildTransitionSection(
              '7. Align Transition',
              'Animates alignment within container',
              _buildAlignTransitionDemo(),
              () {
                setState(() {
                  _alignment = _alignment == Alignment.center
                      ? Alignment.bottomRight
                      : Alignment.center;
                });
              },
            ),

            const SizedBox(height: 32),

            // Control Panel
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionSection(
    String title,
    String description,
    Widget demo,
    VoidCallback onAnimate,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onAnimate,
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Animate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: demo,
            ),
          ],
        ),
      ),
    );
  }

  // 1. Fade Transition Demo
  Widget _buildFadeTransitionDemo() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(Icons.star, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  // 2. Slide Transition Demo
  Widget _buildSlideTransitionDemo() {
    return Center(
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.rocket_launch, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  // 3. Scale Transition Demo
  Widget _buildScaleTransitionDemo() {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  // 4. Rotation Transition Demo
  Widget _buildRotationTransitionDemo() {
    return Center(
      child: RotationTransition(
        turns: _rotationAnimation,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.refresh, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  // 5. Size Transition Demo
  Widget _buildSizeTransitionDemo() {
    return Center(
      child: SizeTransition(
        sizeFactor: _sizeAnimation,
        axis: Axis.horizontal,
        axisAlignment: 0.0,
        child: Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.expand_more, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  // 6. Positioned Transition Demo (using AnimatedPositioned)
  Widget _buildPositionedTransitionDemo() {
    return ClipRect(
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            left: _leftPosition,
            top: _topPosition,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. Align Transition Demo (using AnimatedAlign)
  Widget _buildAlignTransitionDemo() {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      alignment: _alignment,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.adjust, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      elevation: 4,
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.control_camera, color: Colors.deepPurple.shade700),
                const SizedBox(width: 8),
                Text(
                  'Animation Control Panel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildControlButton('Play All Forward', Icons.play_arrow, () {
                  _fadeController.forward();
                  _slideController.forward();
                  _scaleController.forward();
                  _rotationController.forward();
                  _sizeController.forward();
                }, Colors.green),
                _buildControlButton('Reset All', Icons.refresh, () {
                  _fadeController.reset();
                  _slideController.reset();
                  _scaleController.reset();
                  _rotationController.reset();
                  _sizeController.reset();
                  setState(() {
                    _leftPosition = 50.0;
                    _topPosition = 50.0;
                    _alignment = Alignment.center;
                  });
                }, Colors.orange),
                _buildControlButton('Reverse All', Icons.skip_previous, () {
                  _fadeController.reverse();
                  _slideController.reverse();
                  _scaleController.reverse();
                  _rotationController.reverse();
                  _sizeController.reverse();
                }, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
