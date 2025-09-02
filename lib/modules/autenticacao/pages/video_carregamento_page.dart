import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'dart:async';

import 'package:sisater_mobile/shared/utils/images.dart';

class VideoCarregamentoPage extends StatefulWidget {
  const VideoCarregamentoPage({super.key});

  @override
  State<VideoCarregamentoPage> createState() => _VideoCarregamentoPageState();
}

class _VideoCarregamentoPageState extends State<VideoCarregamentoPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  int _currentImageIndex = 0;
  final List<String> _images = [
    Images.imagem1,
    Images.imagem2,
    Images.imagem3,
    Images.imagem4,
  ];
  
  Timer? _imageTimer;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startImageSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  void _startImageSequence() {
    // Start with first image
    _fadeController.forward();
    
    // Change image every 1.75 seconds
    _imageTimer = Timer.periodic(const Duration(milliseconds: 1750), (timer) {
      if (mounted) {
        _transitionToNextImage();
        
        // Stop after 7 seconds (4 images * 1.75 seconds)
        if (_currentImageIndex >= _images.length - 1) {
          timer.cancel();
          _onSequenceComplete();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _transitionToNextImage() {
    if (_isTransitioning) return;
    
    setState(() {
      _isTransitioning = true;
    });

    // Fade out current image
    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _images.length;
        });
        
        // Fade in new image
        _fadeController.forward();
        
        // Add subtle scale animation
        _scaleController.forward().then((_) {
          _scaleController.reverse();
        });
        
        setState(() {
          _isTransitioning = false;
        });
      }
    });
  }

  void _onSequenceComplete() {
    // Wait a bit more for the last image to be fully visible
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Navigate to the appropriate screen based on user profile
        final appStore = Modular.get<AppStore>();
        final usuarioDados = appStore.usuarioDados;
        
        if (usuarioDados?.perfil == 'BENEFICIÁRIO') {
          Modular.to.pushReplacementNamed('/beneficiario', arguments: usuarioDados);
        } else {
          Modular.to.pushReplacementNamed('/home', arguments: usuarioDados);
        }
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _imageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([_fadeController, _scaleController]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_images[_currentImageIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Progress indicator at bottom
                      Positioned(
                        bottom: 50,
                        left: 20,
                        right: 20,
                        child: Column(
                          children: [
                            // Progress bar
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: (_currentImageIndex + 1) / _images.length,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            // Progress text
                            Text(
                              '${((_currentImageIndex + 1) / _images.length * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // App title overlay at top
                      // Positioned(
                      //   top: 100,
                      //   left: 0,
                      //   right: 0,
                      //   child: Center(
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(
                      //         horizontal: 20,
                      //         vertical: 10,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: Colors.black.withOpacity(0.5),
                      //         borderRadius: BorderRadius.circular(25),
                      //       ),
                      //       child: const Text(
                      //         'Sisater PaiDegua',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 24,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}