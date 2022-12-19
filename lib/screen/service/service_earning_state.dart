import '_service.dart';

abstract class EarningState {
  const EarningState();
}

class InitEarningState extends EarningState {
  const InitEarningState();
}

class PendingEarningState extends EarningState {
  const PendingEarningState();
}

class FailureEarningState extends EarningState {
  const FailureEarningState({
    required this.message,
    this.event,
  });
  final EarningEvent? event;
  final String message;
}

class EarningItemState extends EarningState {
  const EarningItemState({required this.data});

  final Earning data;
}

class EarningItemListState extends EarningState {
  const EarningItemListState({required this.data});

  final List<Earning> data;
}
