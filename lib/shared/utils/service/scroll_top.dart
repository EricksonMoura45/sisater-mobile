import 'package:flutter/material.dart';

void scrollToTop(ScrollController scrollController) {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }