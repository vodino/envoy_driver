import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '_screen.dart';

class OrderRecordingScreen extends StatefulWidget {
  const OrderRecordingScreen({super.key});

  static const String name = 'order_recording';
  static const String path = 'recording';

  @override
  State<OrderRecordingScreen> createState() => _OrderRecordingScreenState();
}

class _OrderRecordingScreenState extends State<OrderRecordingScreen> {
  /// Customer
  late final ValueNotifier<int> _indexController;

  /// OrderService
  late final OrderService _orderService;

  Future<void> _getOrderList([bool pending = false]) {
    if (pending) _orderService.value = const PendingOrderState();
    return _orderService.handle(const QueryOrderList());
  }

  void _listenOrderState(BuildContext context, OrderState state) {}

  @override
  void initState() {
    super.initState();

    /// Customer
    _indexController = ValueNotifier(0);

    /// OrderService
    _orderService = OrderService();
    if (_orderService.value is! OrderItemListState) WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getOrderList(true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderRecordingAppBar(),
      body: ValueListenableConsumer<OrderState>(
        listener: _listenOrderState,
        valueListenable: _orderService,
        builder: (context, state, child) {
          if (state is PendingOrderState) {
            return const OrderRecordingShimmer();
          } else if (state is OrderItemListState) {
            return ValueListenableBuilder<int>(
              valueListenable: _indexController,
              builder: (context, index, child) {
                final inProgressItems = state.data.where((item) => item.scheduledDate == null && (item.status == null || item.status!.index < OrderStatus.delivered.index)).toList();
                final scheduledItems = state.data.where((item) => item.scheduledDate != null && (item.status == null || item.status!.index < OrderStatus.delivered.index)).toList();
                final prevItems = state.data.where((item) => item.status != null && item.status!.index == OrderStatus.delivered.index).toList();
                return BottomAppBar(
                  elevation: 0.0,
                  color: Colors.transparent,
                  child: CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(onRefresh: _getOrderList),
                      SliverPinnedHeader(
                        child: Material(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OrderRecordingTab(
                                    counter: inProgressItems.length + scheduledItems.length,
                                    onPressed: () => _indexController.value = 0,
                                    label: 'Commandes actives',
                                    active: index == 0,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: OrderRecordingTab(
                                    onPressed: () => _indexController.value = 1,
                                    label: 'Commandes terminées',
                                    counter: prevItems.length,
                                    active: index == 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverVisibility(
                        visible: index == 0 && inProgressItems.isEmpty && scheduledItems.isEmpty,
                        sliver: const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text("Vous n'avez pas de commandes actives"),
                          ),
                        ),
                      ),
                      SliverVisibility(
                        visible: index == 0 && inProgressItems.isNotEmpty,
                        sliver: MultiSliver(
                          pushPinnedChildren: true,
                          children: [
                            SliverPinnedHeader(
                              child: CustomListTile(
                                height: 45.0,
                                tileColor: context.theme.colorScheme.surface,
                                title: const Text(
                                  'Commandes en cours',
                                  style: TextStyle(color: CupertinoColors.systemGrey),
                                ),
                              ),
                            ),
                            SliverPinnedHeader.builder((context, overlap) {
                              return Visibility(
                                visible: overlap,
                                child: const Divider(),
                              );
                            }),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final item = inProgressItems[index];
                                  return CustomListTile(
                                    leading: CustomCircleAvatar(
                                      radius: 18.0,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                      child: const Icon(Icons.motorcycle),
                                    ),
                                    subtitle: Text('De ${item.pickupPlace?.title} à ${item.deliveryPlace?.title}'),
                                    onTap: () => context.pushNamed(OrderContentScreen.name, extra: item),
                                    trailing: Text(
                                      '${item.price} F',
                                      style: context.cupertinoTheme.textTheme.navTitleTextStyle,
                                    ),
                                    title: Text(item.name ?? ''),
                                  );
                                },
                                childCount: inProgressItems.length,
                              ),
                            )
                          ],
                        ),
                      ),
                      SliverVisibility(
                        visible: index == 0 && scheduledItems.isNotEmpty,
                        sliver: MultiSliver(
                          children: [
                            SliverPinnedHeader(
                              child: CustomListTile(
                                height: 55.0,
                                tileColor: context.theme.colorScheme.surface,
                                title: const Text(
                                  'Commandes planifiées',
                                  style: TextStyle(color: CupertinoColors.systemGrey),
                                ),
                              ),
                            ),
                            const SliverPinnedHeader(child: Divider()),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final item = scheduledItems[index];
                                  return CustomListTile(
                                    leading: CustomCircleAvatar(
                                      radius: 18.0,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                      child: const Icon(Icons.motorcycle),
                                    ),
                                    subtitle: Text('De ${item.pickupPlace?.title} à ${item.deliveryPlace?.title}'),
                                    onTap: () => context.pushNamed(OrderContentScreen.name, extra: item),
                                    trailing: Text('${item.price} F'),
                                    title: Text(item.name ?? ''),
                                  );
                                },
                                childCount: scheduledItems.length,
                              ),
                            )
                          ],
                        ),
                      ),
                      SliverVisibility(
                        visible: index == 1,
                        sliver: MultiSliver(
                          children: [
                            const SliverPinnedHeader(child: Divider()),
                            SliverVisibility(
                              visible: prevItems.isNotEmpty,
                              replacementSliver: const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text("Vous n'avez pas de commandes terminées"),
                                ),
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final item = prevItems[index];
                                    return CustomListTile(
                                      leading: CustomCircleAvatar(
                                        radius: 18.0,
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                        child: const Icon(Icons.motorcycle),
                                      ),
                                      subtitle: Text('De ${item.pickupPlace?.title} à ${item.deliveryPlace?.title}'),
                                      onTap: () => context.pushNamed(OrderContentScreen.name, extra: item),
                                      trailing: Text(
                                        '${item.price} F',
                                        style: context.cupertinoTheme.textTheme.navTitleTextStyle,
                                      ),
                                      title: Text(item.name ?? ''),
                                    );
                                  },
                                  childCount: prevItems.length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return CustomErrorPage(onTap: () => _getOrderList(true));
        },
      ),
    );
  }
}
