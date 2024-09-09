import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_for_everybody/presentation_layer/screens/folder_grid_screen.dart';

import '../bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<Alignment> _alignmentAnimation; // Animation for moving the text
  late SplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();

    // Animation controller for both position and bounce
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // Duration for the animation
    );

    // Bounce animation using Curves.bounceInOut
    _bounceAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );

    // Alignment animation to move from top to center
    _alignmentAnimation = AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.center,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation
    _controller.forward();

    // Once the entire animation completes, navigate to the next screen
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FolderGridScreen()), // Your target screen
        );
      }
    });

    _splashBloc = SplashBloc();
    _splashBloc.startSplashAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _splashBloc,
      child: Stack(
        children: [
          Container(
            color: Colors.white.withOpacity(0.5),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/img_1.png', // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.green.withOpacity(0.3),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  alignment: _alignmentAnimation.value, // Animate position
                  child: Transform.scale(
                    scale: _bounceAnimation.value, // Apply the bouncing effect
                    child: const Text(
                      'MemoRise',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
           const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200), // Add some spacing
                Material(
                 color: Colors.transparent,
                  child: Text(
                    'Capture Your Thoughts\nElevate Your Ideas',
                    style: TextStyle(

                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
