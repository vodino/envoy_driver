import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

import '_screen.dart';

class OrderContentScreen extends StatefulWidget {
  const OrderContentScreen({super.key, required this.order});

  final Order order;

  static const String path = 'orde_content';
  static const String name = 'orde_content';

  @override
  State<OrderContentScreen> createState() => _OrderContentScreenState();
}

class _OrderContentScreenState extends State<OrderContentScreen> {
  /// Customer
  late double _height;

  /// MapLibre
  MaplibreMapController? _mapController;

  void _onMapCreated(MaplibreMapController controller) async {
    _mapController = controller;
  }

  Future<void> _drawLines(List<RouteSchema> routes) async {
    await _clearMap();

    /// Draw
    const options = LineOptions(lineColor: "#000000", lineJoin: 'round', lineWidth: 4.0);
    for (final route in routes) {
      _drawIcon(path: Assets.images.mappinBlue.path, position: route.coordinates!.last);
      _drawIcon(path: Assets.images.mappinOrange.path, position: route.coordinates!.first);
      _mapController!.addLine(options.copyWith(LineOptions(geometry: route.coordinates)));
      final padding = _height * 0.55;
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(route.bounds!, left: padding, right: padding, bottom: padding, top: padding));
    }
  }

  Future<void> _drawIcon({required String path, required LatLng position}) async {
    final buffer = await rootBundle.load(path);
    final bytes = buffer.buffer.asUint8List();
    await _mapController!.addImage(path, bytes);
    _mapController!.addSymbol(SymbolOptions(geometry: position, iconImage: path));
  }

  Future<void> _clearMap() async {
    if (_mapController == null) return;
    await Future.wait([
      _mapController!.clearLines(),
      _mapController!.clearSymbols(),
    ]);
  }

  /// RouteService
  late final RouteService _routeService;

  void _getRoute() {
    _routeService.handle(GetRoute(
      destination: LatLng(
        widget.order.deliveryPlace!.latitude!,
        widget.order.deliveryPlace!.longitude!,
      ),
      source: LatLng(
        widget.order.pickupPlace!.latitude!,
        widget.order.pickupPlace!.longitude!,
      ),
    ));
  }

  void _listenRouteState(BuildContext context, RouteState state) {
    if (state is InitRouteState) {
      _clearMap();
    } else if (state is RouteItemListState) {
      _drawLines(state.data);
    }
  }

  @override
  void initState() {
    super.initState();

    /// RouteService
    _routeService = RouteService();
    _getRoute();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _height = mediaQuery.size.height;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableListener<RouteState>(
      listener: _listenRouteState,
      valueListenable: _routeService,
      child: Scaffold(
        appBar: const OrderContentAppBar(),
        body: BottomAppBar(
          elevation: 0.0,
          color: Colors.transparent,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CustomListTile(
                  height: 55.0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order.name?.capitalize() ?? 'Commande',
                        style: context.theme.textTheme.titleLarge,
                      ),
                      Text(
                        '${widget.order.price} F',
                        style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 2.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: HomeMap(
                        myLocationEnabled: false,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(widget.order.pickupPlace!.latitude!, widget.order.pickupPlace!.longitude!),
                          zoom: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: OrderContentListTile(
                  title: Text(widget.order.pickupPlace!.title!),
                  iconColor: CupertinoColors.activeBlue,
                ),
              ),
              const SliverToBoxAdapter(child: Divider()),
              SliverToBoxAdapter(
                child: OrderContentListTile(
                  title: Text(widget.order.deliveryPlace!.title!),
                  iconColor: CupertinoColors.activeOrange,
                ),
              ),
              const SliverToBoxAdapter(child: Divider(thickness: 8.0, height: 8.0)),
              SliverToBoxAdapter(
                child: CustomListTile(
                  title: Text('Contact de la collecte', style: context.theme.textTheme.caption),
                  subtitle: Text(
                    widget.order.pickupPhoneNumber!.phones!.join(', '),
                    style: context.cupertinoTheme.textTheme.textStyle,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: Divider()),
              SliverToBoxAdapter(
                child: CustomListTile(
                  title: Text('Contact de la livraison', style: context.theme.textTheme.caption),
                  subtitle: Text(
                    widget.order.deliveryPhoneNumber!.phones!.join(', '),
                    style: context.cupertinoTheme.textTheme.textStyle,
                  ),
                ),
              ),
              SliverVisibility(
                visible: widget.order.rider != null,
                sliver: Builder(
                  builder: (context) {
                    return MultiSliver(
                      children: [
                        const SliverToBoxAdapter(child: Divider(thickness: 8.0, height: 8.0)),
                        SliverToBoxAdapter(
                          child: CustomListTile(
                            leading: const CircleAvatar(backgroundColor: CupertinoColors.systemGrey4),
                            title: Text('Client de la commande', style: context.theme.textTheme.caption),
                            subtitle: Text(
                              widget.order.client!.fullName!,
                              style: context.cupertinoTheme.textTheme.navTitleTextStyle,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
