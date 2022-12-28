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
    _orderService = OrderService.instance();
    if (_orderService.value is! OrderItemListState) WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _getOrderList(true));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
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
                                    label: localizations.activeorder.capitalize(),
                                    onPressed: () => _indexController.value = 0,
                                    active: index == 0,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: OrderRecordingTab(
                                    label: localizations.completedorder.capitalize(),
                                    onPressed: () => _indexController.value = 1,
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
                        sliver: MultiSliver(
                          children: [
                            const SliverPinnedHeader(child: Divider()),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(child: Text(localizations.noactiveorder.capitalize())),
                            ),
                          ],
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
                                title: Text(
                                  localizations.currentorder.capitalize(),
                                  style: const TextStyle(color: CupertinoColors.systemGrey),
                                ),
                              ),
                            ),
                            SliverPinnedHeader.builder((context, overlap) => Visibility(visible: overlap, child: const Divider())),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final item = inProgressItems[index];
                                  return OrderRecordingItemTile(
                                    onTap: () => context.pushNamed(OrderContentScreen.name, extra: item),
                                    from: item.pickupPlace!.title!,
                                    to: item.deliveryPlace!.title!,
                                    price: item.price!,
                                    title: item.name!,
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
                                title: Text(
                                  localizations.scheduledorder.capitalize(),
                                  style: const TextStyle(color: CupertinoColors.systemGrey),
                                ),
                              ),
                            ),
                            SliverPinnedHeader.builder((context, overlap) => Visibility(visible: overlap, child: const Divider())),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final item = scheduledItems[index];
                                  return OrderRecordingItemTile(
                                    onTap: () => context.pushNamed(OrderContentScreen.name, extra: item),
                                    from: item.pickupPlace!.title!,
                                    to: item.deliveryPlace!.title!,
                                    price: item.price!,
                                    title: item.name!,
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
                              replacementSliver: SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(child: Text(localizations.nocompletedorder.capitalize())),
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final item = prevItems[index];
                                    return OrderRecordingItemTile(
                                      onTap: () => context.pushNamed(OrderContentScreen.name, extra: item),
                                      from: item.pickupPlace!.title!,
                                      to: item.deliveryPlace!.title!,
                                      price: item.price!,
                                      title: item.name,
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
