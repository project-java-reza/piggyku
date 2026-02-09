import 'package:flutter/material.dart';

/// Flip Page Route - 3D Flip animation for page transitions
/// Uses scale X to create flip effect without mirroring content
class FlipPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final bool enterFromRight;

  FlipPageRoute({
    required this.child,
    this.enterFromRight = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Create flip animation using scale X (like flipping a card)
            var flipAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ));

            // Fade animation for smooth transition
            var fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ));

            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                // Use scale X to create flip effect without rotation
                // This simulates a card flip without mirroring content
                return Transform.scale(
                  scaleX: flipAnimation.value,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: fadeAnimation.value,
                    child: child,
                  ),
                );
              },
              child: child,
            );
          },
        );
}
