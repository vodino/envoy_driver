import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

import '_widget.dart';

class HomeAppBar extends DefaultAppBar {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => super.preferredSize * 1.2;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [BoxShadow(spreadRadius: -12.0, blurRadius: 20.0)],
            borderRadius: BorderRadius.circular(8.0),
            color: theme.colorScheme.surface,
          ),
          child: CustomButton(
            minSize: 40.0,
            padding: EdgeInsets.zero,
            backgroundColor: context.theme.colorScheme.surface,
            onPressed: () => Scaffold.of(context).openDrawer(),
            child: Icon(Icons.sort_rounded, color: context.theme.colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}

class HomeMap extends StatelessWidget {
  const HomeMap({
    super.key,
    this.onMapClick,
    this.onCameraIdle,
    this.onMapCreated,
    this.onMapLongClick,
    this.initialCameraPosition,
    this.onUserLocationUpdated,
    this.onStyleLoadedCallback,
    this.myLocationEnabled = true,
  });
  final bool myLocationEnabled;
  final VoidCallback? onCameraIdle;
  final OnMapClickCallback? onMapClick;
  final MapCreatedCallback? onMapCreated;
  final OnMapClickCallback? onMapLongClick;
  final VoidCallback? onStyleLoadedCallback;
  final CameraPosition? initialCameraPosition;
  final OnUserLocationUpdated? onUserLocationUpdated;

  @override
  Widget build(BuildContext context) {
    return MaplibreMap(
      compassEnabled: false,
      onMapClick: onMapClick,
      onMapCreated: onMapCreated,
      trackCameraPosition: true,
      onCameraIdle: onCameraIdle,
      onMapLongClick: onMapLongClick,
      myLocationEnabled: myLocationEnabled,
      onUserLocationUpdated: onUserLocationUpdated,
      onStyleLoadedCallback: onStyleLoadedCallback ?? () {},
      gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
      initialCameraPosition: initialCameraPosition ?? const CameraPosition(target: LatLng(0.0, 0.0)),
      styleString: 'https://api.maptiler.com/maps/86f5df0b-f809-4e6f-b8f0-9d3e0976fe90/style.json?key=ohdDnBihXL3Yk2cDRMfO',
    );
  }
}

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: context.theme.colorScheme.onSurface,
      onPressed: onPressed,
      heroTag: UniqueKey(),
      elevation: 0.8,
      child: child,
    );
  }
}
