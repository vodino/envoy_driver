import '_service.dart';

abstract class ClientState {
  const ClientState();
}

class InitClientState extends ClientState {
  const InitClientState();
}

class PendingClientState extends ClientState {
  const PendingClientState();
}

class FailureClientState extends ClientState {
  const FailureClientState({
    required this.message,
    this.event,
  });

  final String message;
  final ClientEvent? event;
}

class ClientItemState extends ClientState {
  const ClientItemState({
    required this.data,
  });
  final ClientSchema data;
}

class NoClientItemState extends ClientState {
  const NoClientItemState({
    this.phoneNumber,
    this.token,
  });

  final String? phoneNumber;
  final String? token;
}

class ClientItemListState extends ClientState {
  const ClientItemListState({
    required this.data,
  });
  final List<ClientSchema> data;
}
