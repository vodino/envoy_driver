import '_service.dart';

abstract class PurchaseState {
  const PurchaseState();
}

class InitPurchaseState extends PurchaseState {
  const InitPurchaseState();
}

class PendingPurchaseState extends PurchaseState {
  const PendingPurchaseState();
}

class FailurePurchaseState extends PurchaseState {
  const FailurePurchaseState({
    required this.message,
    this.event,
  });
  final PurchaseEvent? event;
  final String message;
}

class PurchaseItemState extends PurchaseState {
  const PurchaseItemState({required this.data});

  final Purchase data;
}

class PurchaseItemListState extends PurchaseState {
  const PurchaseItemListState({required this.data});

  final List<Purchase> data;
}
