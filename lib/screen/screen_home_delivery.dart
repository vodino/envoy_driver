import 'package:flutter/material.dart';

import '_screen.dart';

class HomeDeliveryScreen extends StatefulWidget {
  const HomeDeliveryScreen({
    super.key,
    required this.popController,
  });
  final ValueNotifier<Order?> popController;

  @override
  State<HomeDeliveryScreen> createState() => _HomeDeliveryScreenState();
}

class _HomeDeliveryScreenState extends State<HomeDeliveryScreen> {
  /// OrderService
  late final OrderService _orderService;

  void _getOrderList() {
    _orderService.handle(const GetOrderList(
      notEqualStatus: OrderStatus.delivered,
      isNullStatus: false,
      subscription: true,
    ));
  }

  void _listenOrderState(BuildContext context, OrderState state) {}

  @override
  void initState() {
    super.initState();

    /// OrderService
    _orderService = OrderService();
    if (_orderService.value is! OrderItemListState) WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getOrderList());
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.5,
      minChildSize: 0.5,
      initialChildSize: 0.5,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: const HomeDeliveryAppBar(),
          body: BottomAppBar(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ValueListenableConsumer<OrderState>(
                    listener: _listenOrderState,
                    valueListenable: _orderService,
                    builder: (context, state, child) {
                      if (state is PendingOrderState) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      } else if (state is OrderItemListState) {
                        final items = state.data;
                        return ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (context, index) {
                            return const Divider(indent: 16.0, endIndent: 20.0);
                          },
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return CustomListTile(
                              height: 60.0,
                              leading: CustomCircleAvatar(
                                radius: 18.0,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                child: const Icon(Icons.motorcycle),
                              ),
                              subtitle: Text('De ${item.pickupPlace?.title} à ${item.deliveryPlace?.title}'),
                              trailing: Text('${item.price} F'),
                              title: Text(item.name ?? ''),
                              onTap: () {
                                widget.popController.value = item;
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: CustomOutlineButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fermer'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
