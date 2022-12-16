import '_service.dart';

abstract class RouteState {
  const RouteState();
}

class InitRouteState extends RouteState {
  const InitRouteState();
}

class PendingRouteState extends RouteState {
  const PendingRouteState();
}

class FailureRouteState extends RouteState {
  const FailureRouteState({
    required this.message,
    this.event,
  });
  final RouteEvent? event;
  final String message;
}

class RouteItemListState extends RouteState {
  const RouteItemListState({
    required this.data,
  });
  final List<RouteSchema> data;
}
