import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef ValueWidgetListener<T> = void Function(BuildContext context, T value);

typedef ValueChangedBuilder<T> = Widget Function(BuildContext context, T value);

class ValueListenableListener<T> extends StatefulWidget {
  const ValueListenableListener({
    Key? key,
    required this.valueListenable,
    required this.listener,
    this.initiated = false,
    required this.child,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final ValueWidgetListener<T> listener;
  final bool initiated;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _ValueListenableListenerState<T>();
}

class _ValueListenableListenerState<T>
    extends State<ValueListenableListener<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.initiated) _valueChanged();
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(ValueListenableListener<T> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      widget.valueListenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    widget.listener(context, widget.valueListenable.value);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class ValueListenableConsumer<T> extends StatelessWidget {
  const ValueListenableConsumer({
    Key? key,
    required this.valueListenable,
    this.initiated = false,
    required this.listener,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final ValueWidgetListener<T> listener;
  final ValueWidgetBuilder<T> builder;
  final bool initiated;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableListener(
      valueListenable: valueListenable,
      initiated: initiated,
      listener: listener,
      child: ValueListenableBuilder(
        valueListenable: valueListenable,
        builder: builder,
        child: child,
      ),
    );
  }
}

class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    Key? key,
    required this.builder,
    this.androidBuilder,
    this.fuchsiaBuilder,
    this.iOSBuilder,
    this.linuxBuilder,
    this.macOSBuilder,
    this.windowsBuilder,
  }) : super(key: key);

  final WidgetBuilder builder;
  final WidgetBuilder? iOSBuilder;
  final WidgetBuilder? androidBuilder;
  final WidgetBuilder? macOSBuilder;
  final WidgetBuilder? windowsBuilder;
  final WidgetBuilder? linuxBuilder;
  final WidgetBuilder? fuchsiaBuilder;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder?.call(context) ?? builder(context);
      case TargetPlatform.iOS:
        return iOSBuilder?.call(context) ?? builder(context);
      case TargetPlatform.macOS:
        return macOSBuilder?.call(context) ?? builder(context);
      case TargetPlatform.windows:
        return windowsBuilder?.call(context) ?? builder(context);
      case TargetPlatform.linux:
        return linuxBuilder?.call(context) ?? builder(context);
      case TargetPlatform.fuchsia:
        return fuchsiaBuilder?.call(context) ?? builder(context);
      default:
        return builder(context);
    }
  }
}

abstract class DefaultAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const DefaultAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(45.0);

  @override
  Widget build(BuildContext context);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}

class CustomOrientationBuilder extends StatelessWidget {
  const CustomOrientationBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final OrientationWidgetBuilder builder;

  Widget _buildWithConstraints(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final orientation = MediaQuery.of(context).orientation;
    return builder(context, orientation);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildWithConstraints);
  }
}

enum BoxSize {
  small,
  large,
  medium,
}

class AdaptativeWidget extends StatelessWidget {
  const AdaptativeWidget({
    Key? key,
    required this.builder,
    this.largeBuilder,
    this.mediumBuilder,
    this.smallBuilder,
  }) : super(key: key);

  final ValueChangedBuilder<BoxSize> builder;

  final WidgetBuilder? mediumBuilder;
  final WidgetBuilder? smallBuilder;
  final WidgetBuilder? largeBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width <= 640) {
          return smallBuilder?.call(context) ?? builder(context, BoxSize.small);
        } else if (width >= 1008) {
          return largeBuilder?.call(context) ?? builder(context, BoxSize.large);
        } else if (width > 640) {
          return mediumBuilder?.call(context) ??
              builder(context, BoxSize.medium);
        }
        return builder(context, BoxSize.small);
      },
    );
  }
}

class ScrollListener extends StatefulWidget {
  const ScrollListener({
    Key? key,
    this.percentListener,
    required this.child,
    this.percent = 0.5,
    this.listener,
  }) : super(key: key);

  final Widget child;
  final double percent;
  final ValueWidgetListener<double>? listener;
  final ValueChanged<BuildContext>? percentListener;

  @override
  State<ScrollListener> createState() => _ScrollListenerState();
}

class _ScrollListenerState extends State<ScrollListener> {
  ScrollDirection? _scrollDirection;

  bool _onNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      _scrollDirection = notification.direction;
    } else if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      final value = metrics.pixels / metrics.maxScrollExtent;
      widget.listener?.call(context, value);
      if (value >= widget.percent && _scrollDirection == ScrollDirection.idle) {
        widget.percentListener?.call(context);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      child: widget.child,
    );
  }
}

class CustomKeepAlive extends StatefulWidget {
  const CustomKeepAlive({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<CustomKeepAlive> createState() => _CustomKeepAliveState();
}

class _CustomKeepAliveState extends State<CustomKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class CounterBuilder extends StatefulWidget {
  const CounterBuilder({
    Key? key,
    this.child,
    required this.builder,
    this.timeout = const Duration(seconds: 1),
    this.duration = const Duration(seconds: 30),
  }) : super(key: key);

  final Widget? child;
  final Duration timeout;
  final Duration duration;
  final ValueWidgetBuilder<Duration> builder;

  @override
  State<CounterBuilder> createState() => _CounterBuilderState();
}

class _CounterBuilderState extends State<CounterBuilder> {
  late Duration _duration;
  Timer? _timer;

  void _restartTimer() {
    _timer?.cancel();
    _duration = widget.duration;
    _timer = Timer.periodic(
      widget.timeout,
      (timer) {
        if (_duration.inSeconds == 0) {
          timer.cancel();
        } else {
          setState(() {
            _duration -= widget.timeout;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  @override
  void didUpdateWidget(covariant CounterBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.timeout != widget.timeout) {
      _restartTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _duration, widget.child);
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  const CustomScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}

class AlignAspectRatio extends StatelessWidget {
  const AlignAspectRatio({
    Key? key,
    this.alignment = Alignment.center,
    required this.aspectRatio,
    this.heightFactor,
    this.widthFactor,
    this.child,
  }) : super(key: key);

  final AlignmentGeometry alignment;
  final double? heightFactor;
  final double? widthFactor;
  final double aspectRatio;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      heightFactor: heightFactor,
      widthFactor: widthFactor,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: child,
      ),
    );
  }
}

class CustomVerticalButtons extends StatelessWidget {
  const CustomVerticalButtons({
    Key? key,
    required this.children,
    this.separator = const Divider(),
    this.elevation = 0.8,
    this.shape = const ContinuousRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
    ),
  }) : super(key: key);

  final List<Widget> children;
  final ShapeBorder? shape;
  final Widget separator;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: SingleChildScrollView(
        child: Material(
          shape: shape,
          elevation: elevation,
          child: ListBody(
            children: List.generate(
              max(0, children.length * 2 - 1),
              (index) {
                if (index.isEven) {
                  index ~/= 2;
                  return children[index];
                }
                return separator;
              },
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetSize extends StatefulWidget {
  const WidgetSize({
    Key? key,
    required this.child,
    this.onSizeChange,
  }) : super(key: key);

  final Widget child;
  final ValueChanged<Size>? onSizeChange;

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  late final GlobalKey _globalKey;

  void _getWidgetInfo(_) {
    final context = _globalKey.currentContext;
    final renderBox = context?.findRenderObject() as RenderBox;
    widget.onSizeChange?.call(renderBox.size);
  }

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback(_getWidgetInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _globalKey,
      child: widget.child,
    );
  }
}
