import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '_screen.dart';

class HomeOnlineScreen extends StatefulWidget {
  const HomeOnlineScreen({
    super.key,
    required this.popController,
  });

  final ValueNotifier<Order?> popController;

  @override
  State<HomeOnlineScreen> createState() => _HomeOnlineScreenState();
}

class _HomeOnlineScreenState extends State<HomeOnlineScreen> with WidgetsBindingObserver {
  /// Customer
  static final ValueNotifier<bool> _activeController = ValueNotifier(false);

  void _openNewOrderModal(Order data) async {
    final value = await showModalBottomSheet<Order>(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return HomeOrderNewScreen(order: data);
      },
    );
    if (value != null && mounted) {
      widget.popController.value = value;
      Navigator.pop(context);
    }
  }

  /// OrderService
  late final OrderService _orderService;
  Future<void> Function()? _canceller;

  void _listenOrderState(BuildContext context, OrderState state) {
    if (state is SubscriptionOrderState) {
      _canceller = state.canceller;
    } else if (state is OrderItemState) {
      _openNewOrderModal(state.data);
    } else if (state is FailureOrderState) {
      _canceller?.call();
    }
  }

  Future<void> _subscribe() async {
    _orderService.handle(const SubscribeToOrder());
  }

  Future<bool> _unsubscribe() async {
    await _cancel();
    return true;
  }

  Future<bool> _cancel() async {
    await _canceller?.call();
    await _locationSubscription?.cancel();
    return true;
  }

  /// LocationService
  late final LocationService _locationService;
  StreamSubscription? _locationSubscription;
  LocationData? _userLocation;

  void _listenLocationState(BuildContext context, LocationState state) {
    if (state is LocationItemState) {
      _locationSubscription = state.subscription;
      _userLocation = state.data;
      if (_activeController.value) _updateLocation();
    }
  }

  /// ClientService
  late final ClientService _clientService;
  late final ClientService _positionClientService;

  void _listenClientState(BuildContext context, ClientState state) {
    if (state is OnlineClientState) {
      _subscribe();
      _activeController.value = true;
    } else if (state is OfflineClientState) {
      _unsubscribe();
      _activeController.value = false;
    }
  }

  void _setClientStatus(ClientStatus status) {
    _clientService.handle(UpdateClientStatus(
      longitude: _userLocation!.longitude!,
      latitude: _userLocation!.latitude!,
      status: status,
    ));
  }

  void _goOnline() => _setClientStatus(ClientStatus.online);
  void _goOffline() => _setClientStatus(ClientStatus.offline);

  void _updateLocation() {
    _positionClientService.handle(UpdateClientLocation(
      longitude: _userLocation!.longitude!,
      latitude: _userLocation!.latitude!,
    ));
  }

  @override
  void initState() {
    super.initState();

    /// OrderService
    _orderService = OrderService.instance();
    if (_activeController.value) _subscribe();

    /// LocationService
    _locationService = LocationService.instance();

    /// ClientService
    _clientService = ClientService();
    _positionClientService = ClientService();
  }

  @override
  void dispose() {
    /// OrderService
    _cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _cancel,
      child: ValueListenableListener<ClientState>(
        listener: _listenClientState,
        valueListenable: _clientService,
        child: ValueListenableListener<LocationState>(
          initiated: true,
          listener: _listenLocationState,
          valueListenable: _locationService,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: BottomAppBar(
              elevation: 0.0,
              color: Colors.transparent,
              child: ValueListenableListener<OrderState>(
                listener: _listenOrderState,
                valueListenable: _orderService,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _activeController,
                  builder: (context, active, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HomeSearchAppBar(active: active),
                        Expanded(child: HomeSearchLoading(active: active)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Visibility(
                            visible: active,
                            replacement: ValueListenableBuilder<ClientState>(
                              valueListenable: _clientService,
                              builder: (context, state, child) {
                                VoidCallback? onPressed = _goOnline;
                                if (state is PendingClientState) onPressed = null;
                                return CupertinoButton.filled(
                                  onPressed: onPressed,
                                  child: Visibility(
                                    visible: onPressed != null,
                                    replacement: const CupertinoActivityIndicator(),
                                    child: const Text('Se mettre en ligne'),
                                  ),
                                );
                              },
                            ),
                            child: ValueListenableBuilder<ClientState>(
                              valueListenable: _clientService,
                              builder: (context, state, child) {
                                VoidCallback? onPressed = _goOffline;
                                if (state is PendingClientState) onPressed = null;
                                return CustomOutlineButton(
                                  onPressed: onPressed,
                                  child: Visibility(
                                    visible: onPressed != null,
                                    replacement: const CupertinoActivityIndicator(),
                                    child: const Text('Arrêter'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
