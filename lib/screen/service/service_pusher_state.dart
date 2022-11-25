import '_service.dart';

abstract class PusherState {
  const PusherState();
}

class InitPusherState extends PusherState {
  const InitPusherState();
}

class PendingPusherState extends PusherState {
  const PendingPusherState();
}

class FailurePusherState extends PusherState {
  const FailurePusherState({
    required this.message,
    this.event,
  });
  final CustomPusherEvent? event;
  final String message;
}
