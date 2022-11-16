import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '_screen.dart';

class HomeOrderNewScreen extends StatefulWidget {
  const HomeOrderNewScreen({super.key});

  @override
  State<HomeOrderNewScreen> createState() => _HomeOrderNewScreenState();
}

class _HomeOrderNewScreenState extends State<HomeOrderNewScreen> {
  late Duration _totalDuration;

  @override
  void initState() {
    super.initState();
    _totalDuration = const Duration(seconds: 30);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Scaffold(
        body: BottomAppBar(
          elevation: 0.0,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeOrderNewAppBar(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HomeOrderNewLoading(),
                    const SizedBox(height: 16.0),
                    SlideCountdownSeparated(
                      duration: _totalDuration,
                      icon: Text(
                        'Vous avez ',
                        style: context.cupertinoTheme.textTheme.textStyle,
                      ),
                      suffixIcon: Text(
                        ' secondes',
                        style: context.cupertinoTheme.textTheme.textStyle,
                      ),
                      slideDirection: SlideDirection.up,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomOutlineButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Refuser'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Accepter'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
