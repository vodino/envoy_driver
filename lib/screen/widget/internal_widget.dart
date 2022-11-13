import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.borderRadius,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    bool isThreeLine = false,
    this.shape = const RoundedRectangleBorder(),
    this.style,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.selected = false,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.height,
  }) : super(key: key);

  final EdgeInsetsGeometry? contentPadding;

  final BorderRadius? borderRadius;
  final ShapeBorder shape;
  final TextStyle? style;

  final double? height;

  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? title;
  final bool selected;
  final bool enabled;

  final Color? selectedTileColor;
  final Color? tileColor;
  final Color? selectedColor;
  final Color? iconColor;
  final Color? textColor;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final FocusNode? focusNode;
  final bool autofocus;

  Color? _textColor(ThemeData theme) {
    return selected ? selectedColor ?? theme.colorScheme.primary : textColor;
  }

  Color? _iconColor(ThemeData theme) {
    return selected ? selectedColor ?? theme.colorScheme.primary : iconColor;
  }

  Color? get _tileColor {
    return selected ? selectedTileColor : tileColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ShapeDecoration? decoration;
    if (tileColor != null) {
      decoration = ShapeDecoration(
        color: _tileColor,
        shape: shape,
      );
    }

    const EdgeInsetsDirectional padding = EdgeInsetsDirectional.only(
      start: 16.0,
      end: 16.0,
    );
    return InkWell(
      onTap: onTap,
      focusNode: focusNode,
      autofocus: autofocus,
      hoverColor: hoverColor,
      focusColor: focusColor,
      mouseCursor: mouseCursor,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      customBorder: shape,
      child: Container(
        padding: contentPadding ?? padding,
        decoration: decoration,
        height: height ?? ((title != null && subtitle != null) ? 55.0 : 48.0),
        child: Theme(
          data: theme,
          child: IconTheme.merge(
            data: IconThemeData(color: _iconColor(theme)),
            child: Row(
              children: <Widget>[
                if (leading != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: leading,
                  ),
                if (title != null && subtitle != null)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DefaultTextStyle(
                          style: style ??
                              theme.textTheme.titleMedium!.copyWith(
                                fontWeight: theme.textTheme.subtitle1!.fontWeight,
                                color: _textColor(theme),
                              ),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          child: title!,
                        ),
                        const SizedBox(height: 2.0),
                        DefaultTextStyle(
                          style: style ??
                              theme.textTheme.caption!.copyWith(
                                color: textColor,
                              ),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          child: subtitle!,
                        ),
                      ],
                    ),
                  )
                else if (title != null || subtitle != null)
                  Expanded(
                    child: DefaultTextStyle(
                      style: style ??
                          theme.textTheme.titleMedium!.copyWith(
                            fontWeight: theme.textTheme.subtitle1!.fontWeight,
                            color: _textColor(theme),
                          ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      child: title ?? subtitle!,
                    ),
                  ),
                if (trailing != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8.0),
                    child: DefaultTextStyle(
                      style: style ??
                          theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      child: trailing!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCircleProgessIndicator extends StatefulWidget {
  const CustomCircleProgessIndicator({
    Key? key,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
    ],
    this.backgroundColor,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 2.0,
    this.value,
  }) : super(key: key);

  final double? value;
  final Color? backgroundColor;
  final double strokeWidth;
  final String? semanticsLabel;
  final String? semanticsValue;
  final List<Color> colors;

  @override
  State<CustomCircleProgessIndicator> createState() => _CustomCircleProgessIndicatorState();
}

class _CustomCircleProgessIndicatorState extends State<CustomCircleProgessIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 6665),
      vsync: this,
    )
      ..forward()
      ..repeat();
    final colors = widget.colors.toList();
    colors.shuffle();
    _animation = TweenSequence(
      List.generate(
        colors.length,
        (index) {
          final value = colors[index];
          return TweenSequenceItem(
            tween: ConstantTween(value),
            weight: 1.0,
          );
        },
      ),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      backgroundColor: widget.backgroundColor,
      semanticsLabel: widget.semanticsLabel,
      semanticsValue: widget.semanticsValue,
      strokeWidth: widget.strokeWidth,
      valueColor: _animation,
      value: widget.value,
    );
  }
}

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({
    Key? key,
    this.suffixIcon = const Icon(CupertinoIcons.xmark_circle_fill),
    this.suffixMode = OverlayVisibilityMode.editing,
    this.autofocus = false,
    this.prefixIcon,
    this.controller,
    this.placeholder,
    this.decoration,
    this.focusNode,
    this.enabled,
    this.onTap,
  }) : super(key: key);

  final TextEditingController? controller;
  final BoxDecoration? decoration;
  final FocusNode? focusNode;
  final String? placeholder;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Icon suffixIcon;
  final bool autofocus;
  final bool? enabled;
  final OverlayVisibilityMode suffixMode;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;
    return CupertinoSearchTextField(
      style: style,
      prefixInsets: const EdgeInsetsDirectional.fromSTEB(8, 0, 2, 0.5),
      padding: const EdgeInsetsDirectional.fromSTEB(6, 8, 5, 8),
      prefixIcon: Visibility(
        visible: prefixIcon == null,
        replacement: Builder(builder: (_) => prefixIcon!),
        child: const Icon(
          CupertinoIcons.search,
          color: CupertinoColors.systemGrey,
          size: 20.0,
        ),
      ),
      placeholderStyle: const TextStyle(
        color: CupertinoColors.secondaryLabel,
      ),
      placeholder: placeholder,
      decoration: decoration,
      suffixIcon: suffixIcon,
      suffixMode: suffixMode,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      enabled: enabled,
      onTap: onTap,
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    Key? key,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.side = BorderSide.none,
    this.elevation = 1.5,
    this.shape,
  })  : assert(radius == null || (minRadius == null && maxRadius == null)),
        assert(backgroundImage != null || onBackgroundImageError == null),
        assert(foregroundImage != null || onForegroundImageError == null),
        super(key: key);

  final double elevation;
  final BorderSide side;
  final ShapeBorder? shape;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ImageProvider? backgroundImage;
  final ImageProvider? foregroundImage;
  final ImageErrorListener? onBackgroundImageError;
  final ImageErrorListener? onForegroundImageError;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;

  static const double _defaultRadius = 20.0;

  static const double _defaultMinRadius = 0.0;

  static const double _defaultMaxRadius = double.infinity;

  double get _minDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? minRadius ?? _defaultMinRadius);
  }

  double get _maxDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? maxRadius ?? _defaultMaxRadius);
  }

  ShapeBorder get _shape {
    return shape ?? CircleBorder(side: side);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    TextStyle textStyle = theme.primaryTextTheme.subtitle1!.copyWith(color: foregroundColor);
    Color? effectiveBackgroundColor = backgroundColor;
    if (effectiveBackgroundColor == null) {
      switch (ThemeData.estimateBrightnessForColor(textStyle.color!)) {
        case Brightness.dark:
          effectiveBackgroundColor = theme.primaryColorLight;
          break;
        case Brightness.light:
          effectiveBackgroundColor = theme.primaryColorDark;
          break;
      }
    } else if (foregroundColor == null) {
      switch (ThemeData.estimateBrightnessForColor(backgroundColor!)) {
        case Brightness.dark:
          textStyle = textStyle.copyWith(color: theme.primaryColorLight);
          break;
        case Brightness.light:
          textStyle = textStyle.copyWith(color: theme.primaryColorDark);
          break;
      }
    }
    final double minDiameter = _minDiameter;
    final double maxDiameter = _maxDiameter;
    return Material(
      shape: _shape,
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      color: effectiveBackgroundColor,
      child: AnimatedContainer(
        constraints: BoxConstraints(
          minHeight: minDiameter,
          minWidth: minDiameter,
          maxWidth: maxDiameter,
          maxHeight: maxDiameter,
        ),
        duration: kThemeChangeDuration,
        decoration: ShapeDecoration(
          color: effectiveBackgroundColor,
          image: backgroundImage != null
              ? DecorationImage(
                  image: backgroundImage!,
                  onError: onBackgroundImageError,
                  fit: BoxFit.cover,
                )
              : null,
          shape: _shape,
        ),
        foregroundDecoration: foregroundImage != null
            ? ShapeDecoration(
                image: DecorationImage(
                  image: foregroundImage!,
                  onError: onForegroundImageError,
                  fit: BoxFit.cover,
                ),
                shape: _shape,
              )
            : null,
        child: child == null
            ? null
            : Center(
                child: MediaQuery(
                  // Need to ignore the ambient textScaleFactor here so that the
                  // text doesn't escape the avatar when the textScaleFactor is large.
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: IconTheme(
                    data: theme.iconTheme.copyWith(color: textStyle.color),
                    child: DefaultTextStyle(
                      style: textStyle,
                      child: child!,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.padding = EdgeInsets.zero,
    required this.onPressed,
    this.backgroundColor,
    this.minSize = 0.0,
    required this.child,
    this.color,
  }) : super(key: key);

  final Color? color;
  final Widget child;
  final double? minSize;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;
    return CupertinoButton(
      color: backgroundColor,
      onPressed: onPressed,
      minSize: minSize,
      padding: padding,
      child: IconTheme(
        data: IconThemeData(color: color),
        child: child,
      ),
    );
  }
}

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    Key? key,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.pressedOpacity = 0.4,
    required this.onPressed,
    required this.label,
    this.icon,
  }) : super(key: key);

  final Widget? icon;
  final Widget label;
  final EdgeInsetsGeometry? padding;
  final Color disabledColor;
  final VoidCallback? onPressed;
  final double? minSize;
  final double? pressedOpacity;
  final BorderRadiusGeometry borderRadius;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: ContinuousRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      child: CupertinoButton.filled(
        borderRadius: BorderRadius.zero,
        pressedOpacity: pressedOpacity,
        disabledColor: disabledColor,
        alignment: alignment,
        onPressed: onPressed,
        padding: padding,
        minSize: minSize,
        child: DefaultTextStyle(
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: icon != null,
                child: Builder(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: icon,
                    );
                  },
                ),
              ),
              label,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({
    Key? key,
    this.initialTimerDuration = Duration.zero,
    this.mode = CupertinoTimerPickerMode.hm,
    required this.onTimerDurationChanged,
    this.backgroundColor,
    this.elevation = 2.0,
    this.footer,
    this.header,
  }) : super(key: key);

  final ValueChanged<Duration> onTimerDurationChanged;
  final CupertinoTimerPickerMode mode;
  final Duration initialTimerDuration;
  final Color? backgroundColor;
  final double? elevation;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: SizedBox(
        width: 220.0,
        height: 250.0,
        child: Column(
          children: [
            Visibility(
              visible: header != null,
              child: Builder(builder: (context) => header!),
            ),
            Expanded(
              child: CupertinoTimerPicker(
                mode: mode,
                initialTimerDuration: initialTimerDuration,
                onTimerDurationChanged: onTimerDurationChanged,
              ),
            ),
            Visibility(
              visible: footer != null,
              child: Builder(builder: (context) => footer!),
            ),
          ],
        ),
      ),
    );
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    super.key,
    required this.child,
    this.shakeCount = 3,
    this.animate = false,
    required this.shakeOffset,
    this.duration = const Duration(milliseconds: 400),
  });

  final bool animate;
  final Widget child;
  final int shakeCount;
  final double shakeOffset;
  final Duration duration;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animate) _animationController.forward();
    _animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_updateStatus);
    _animationController.dispose();
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reset();
    }
  }

  void shake() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 1. return an AnimatedBuilder
    return AnimatedBuilder(
      // 2. pass our custom animation as an argument
      animation: _animationController,
      // 3. optimization: pass the given child as an argument
      child: widget.child,
      builder: (context, child) {
        final sineValue = sin(widget.shakeCount * 2 * pi * _animationController.value);
        return Transform.translate(
          // 4. apply a translation as a function of the animation value
          offset: Offset(sineValue * widget.shakeOffset, 0),
          // 5. use the child widget
          child: child,
        );
      },
    );
  }
}

class AfterLayout extends StatefulWidget {
  const AfterLayout({
    super.key,
    this.listener,
    required this.child,
  });

  final ValueChanged<BuildContext>? listener;
  final Widget child;

  @override
  State<AfterLayout> createState() => _AfterLayoutState();
}

class _AfterLayoutState extends State<AfterLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((value) {
      if (mounted) widget.listener?.call(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CustomBottomSheetController extends ValueNotifier<bool> {
  CustomBottomSheetController({bool expanded = false}) : super(expanded);

  void close() => value = false;
  void expands() => value = true;
}

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    super.key,
    this.header,
    this.controller,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    required this.builder,
  });

  final Widget? header;
  final double maxChildSize;
  final double initialChildSize;
  final double minChildSize;
  final ScrollableWidgetBuilder builder;
  final CustomBottomSheetController? controller;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  StreamSubscription<double>? _heightControllerSubscription;
  late StreamController<double> _heightController;
  late CustomBottomSheetController _controller;
  late double _initialHeight;
  AxisDirection? _direction;
  late double _minHeight;
  late double _maxHeight;
  late double _height;

  void _jumpUp() {
    _heightController.add(_maxHeight);
  }

  void _jumpDown() {
    _heightController.add(_minHeight);
  }

  void _listenHeightController(double height) {
    _height = height;
  }

  void _listenCustomBottomSheetController() {
    if (_controller.value) {
      _jumpUp();
    } else {
      _jumpDown();
    }
  }

  void _starts() {
    _height = 0.0;
    _heightController = StreamController.broadcast();
    _heightControllerSubscription = _heightController.stream.listen(_listenHeightController);
    _controller = widget.controller ?? CustomBottomSheetController();
    _controller.addListener(_listenCustomBottomSheetController);
  }

  void _stops() {
    _controller.removeListener(_listenCustomBottomSheetController);
    _heightControllerSubscription?.cancel();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final double dy = details.delta.dy;
    final double result = _height - dy;
    if (result >= _minHeight && result <= _maxHeight) {
      _direction = dy <= 0 ? AxisDirection.up : AxisDirection.down;
      _heightController.add(result);
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _controller.value = _direction == AxisDirection.up ? true : false;
  }

  @override
  void initState() {
    super.initState();
    _starts();
  }

  @override
  void didUpdateWidget(covariant CustomBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _stops();
      _starts();
    }
  }

  @override
  void dispose() {
    _stops();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: widget.header,
        ),
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) {
              _maxHeight = widget.maxChildSize * constraints.maxHeight;
              _minHeight = widget.minChildSize * constraints.maxHeight;
              _initialHeight = widget.initialChildSize * constraints.maxHeight;
              return StreamBuilder<double>(
                initialData: _initialHeight,
                stream: _heightController.stream,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    curve: Curves.easeOut,
                    height: snapshot.data,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                      onVerticalDragEnd: _onVerticalDragEnd,
                      child: DraggableScrollableSheet(
                        builder: widget.builder,
                        initialChildSize: 1.0,
                        maxChildSize: 1.0,
                        minChildSize: 1.0,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({
    required this.color,
    required this.animation,
  }) : super(repaint: animation);

  final Color color;
  final Animation<double> animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color opacityColor = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double radius = sqrt(size * size * value / 4);
    final Paint paint = Paint()..color = opacityColor;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => true;
}

class Ripple extends StatefulWidget {
  const Ripple({
    super.key,
    this.color,
    this.animate = true,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  });

  final Color? color;
  final Widget child;
  final bool animate;
  final Duration duration;

  @override
  State<Ripple> createState() => _RippleState();
}

class _RippleState extends State<Ripple> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Color _color;

  void _initialize() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _color = widget.color ?? Theme.of(context).colorScheme.primary;
  }

  @override
  void didUpdateWidget(covariant Ripple oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.dispose();
      _initialize();
    }
    if (oldWidget.animate != widget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: widget.animate ? _CirclePainter(animation: _controller, color: _color) : null,
      child: widget.child,
    );
  }
}
