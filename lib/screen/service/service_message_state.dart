import '_service.dart';

abstract class MessagingState {
  const MessagingState();
}

class InitMessagingState extends MessagingState {
  const InitMessagingState();
}

class PendingMessagingState extends MessagingState {
  const PendingMessagingState();
}

class FailureMessagingState extends MessagingState {
  const FailureMessagingState({
    required this.message,
    this.event,
  });
  final MessagingEvent? event;
  final String message;
}

class SuccessMessagingState extends MessagingState {
  const SuccessMessagingState();
}
