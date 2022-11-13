import 'package:flutter/material.dart';

import '_screen.dart';

class AvailablityScreen extends StatelessWidget {
  const AvailablityScreen({super.key});

  static const String path = 'availablity';
  static const String name = 'availablity';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AvailablityAppBar(),
    );
  }
}
