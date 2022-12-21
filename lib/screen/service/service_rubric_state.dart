import '_service.dart';

abstract class RubricState {
  const RubricState();
}

class InitRubricState extends RubricState {
  const InitRubricState();
}

class PendingRubricState extends RubricState {
  const PendingRubricState();
}

class FailureRubricState extends RubricState {
  const FailureRubricState({
    required this.message,
    this.event,
  });
  final RubricEvent? event;
  final String message;
}

class CancelFailureRubricState extends FailureRubricState {
  const CancelFailureRubricState({
    required super.message,
    super.event,
  });
}

class RubricItemState extends RubricState {
  const RubricItemState({
    required this.data,
  });
  final RubricSchema data;
}

class RubricItemListState extends RubricState {
  const RubricItemListState({
    required this.data,
  });
  final List<RubricSchema> data;
}