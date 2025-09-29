import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AdvancedScrollableFABScreen extends StatefulWidget {
  const AdvancedScrollableFABScreen({super.key});

  @override
  State<AdvancedScrollableFABScreen> createState() =>
      _AdvancedScrollableFABScreenState();
}

class _AdvancedScrollableFABScreenState
    extends State<AdvancedScrollableFABScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final ScrollDirection direction =
        _scrollController.position.userScrollDirection;

    if (direction == ScrollDirection.reverse && !_isScrollingDown) {
      // Scrolling down
      setState(() {
        _isScrollingDown = true;
      });
      _fabAnimationController.forward();
    } else if (direction == ScrollDirection.forward && _isScrollingDown) {
      // Scrolling up
      setState(() {
        _isScrollingDown = false;
      });
      _fabAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced FAB Animation'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'List Item $index',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }, childCount: 100),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_fabAnimation.value * 0.3),
            child: _isScrollingDown
                ? FloatingActionButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Normal FAB pressed!')),
                      );
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add, color: Colors.white),
                  )
                : Transform.scale(
                    scale: 1.5,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Extended FAB pressed!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Create New',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      extendedPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      elevation: 6.0,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
