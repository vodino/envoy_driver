import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class OrderProfitScreen extends StatefulWidget {
  const OrderProfitScreen({super.key});

  static const String name = 'order_profit';
  static const String path = 'profit';

  @override
  State<OrderProfitScreen> createState() => _OrderProfitScreenState();
}

class _OrderProfitScreenState extends State<OrderProfitScreen> {
  /// Customer
  late final ValueNotifier<int> _indexController;

  void _listenIndexController(BuildContext context, int index) {
    if (index == 0) {
      if (_earningService.value is! EarningItemListState) WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _queryEarningList(true));
    } else {
      if (_purchaseService.value is! PurchaseItemListState) WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _queryPurchaseList(true));
    }
  }

  /// EarningService
  late final EarningService _earningService;

  Future<void> _queryEarningList([bool pending = false]) {
    if (pending) _earningService.value = const PendingEarningState();
    return _earningService.handle(const QueryEarningList());
  }

  /// PurchaseService
  late final PurchaseService _purchaseService;

  Future<void> _queryPurchaseList([bool pending = false]) {
    if (pending) _purchaseService.value = const PendingPurchaseState();
    return _purchaseService.handle(const QueryPurchaseList());
  }

  @override
  void initState() {
    super.initState();

    /// Customer
    _indexController = ValueNotifier(0);

    /// EarningService
    _earningService = EarningService.instance();

    /// PurchaseService
    _purchaseService = PurchaseService.instance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderProfitAppBar(),
      body: ValueListenableConsumer<int>(
        initiated: true,
        listener: _listenIndexController,
        valueListenable: _indexController,
        builder: (context, index, child) {
          return BottomAppBar(
            elevation: 0.0,
            color: Colors.transparent,
            child: CustomScrollView(
              slivers: [
                SliverVisibility(
                  visible: index == 0,
                  replacementSliver: CupertinoSliverRefreshControl(onRefresh: _queryPurchaseList),
                  sliver: CupertinoSliverRefreshControl(onRefresh: _queryEarningList),
                ),
                SliverPinnedHeader(
                  child: Material(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OrderProfitTab(
                              onPressed: () => _indexController.value = 0,
                              active: index == 0,
                              label: 'Gains',
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: OrderProfitTab(
                              onPressed: () => _indexController.value = 1,
                              active: index == 1,
                              label: 'Tokens',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPinnedHeader.builder((context, overlap) => Visibility(visible: overlap, child: const Divider())),
                SliverVisibility(
                  visible: index == 0,
                  sliver: ValueListenableBuilder<EarningState>(
                    valueListenable: _earningService,
                    builder: (context, state, child) {
                      if (state is PendingEarningState) {
                        return const SliverToBoxAdapter(child: OrderProfitShimmer());
                      } else if (state is EarningItemListState) {
                        final items = state.data;
                        final amount = items.fold(0.0, (result, item) => result + item.amount!);
                        return MultiSliver(
                          children: [
                            SliverToBoxAdapter(
                              child: OrderProfitCard(
                                content: '${amount.toString().padLeft(2, '0')} F',
                                title: 'Montant',
                              ),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
                            const SliverToBoxAdapter(child: Divider()),
                            SliverVisibility(
                              visible: items.isNotEmpty,
                              replacementSliver: const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text("Vous n'avez pas de gains"),
                                ),
                              ),
                              sliver: MultiSliver(
                                children: [
                                  SliverToBoxAdapter(
                                    child: CustomListTile(
                                      onTap: () {},
                                      title: Text(
                                        'Historique des gains',
                                        style: context.theme.textTheme.caption,
                                      ),
                                      trailing: Icon(Icons.sort, size: 18.0, color: context.theme.textTheme.caption?.color),
                                    ),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final item = items[index];
                                        return CustomListTile(
                                          title: const Text('Commande livrée'),
                                          subtitle: Text(MaterialLocalizations.of(context).formatFullDate(item.createdAt!)),
                                          trailing: Text(
                                            '${item.amount} F',
                                            style: context.cupertinoTheme.textTheme.navTitleTextStyle,
                                          ),
                                        );
                                      },
                                      childCount: items.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return SliverFillRemaining(child: CustomErrorPage(onTap: () => _queryEarningList(true)));
                    },
                  ),
                ),
                SliverVisibility(
                  visible: index == 1,
                  sliver: ValueListenableBuilder<PurchaseState>(
                    valueListenable: _purchaseService,
                    builder: (context, state, child) {
                      if (state is PendingPurchaseState) {
                        return const SliverToBoxAdapter(child: OrderProfitShimmer());
                      } else if (state is PurchaseItemListState) {
                        final items = state.data;
                        return MultiSliver(
                          children: [
                            SliverToBoxAdapter(
                              child: OrderProfitCard(
                                title: 'Tokens Disponibles',
                                content: items.isNotEmpty ? items.first.totalTokens!.toString().padLeft(2, '0') : '00',
                              ),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 12.0)),
                            const SliverToBoxAdapter(child: Divider()),
                            SliverVisibility(
                              visible: items.isNotEmpty,
                              replacementSliver: const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text("Vous n'avez pas de tokens"),
                                ),
                              ),
                              sliver: MultiSliver(
                                children: [
                                  SliverToBoxAdapter(
                                    child: CustomListTile(
                                      onTap: () {},
                                      trailing: Icon(Icons.sort, size: 18.0, color: context.theme.textTheme.caption?.color),
                                      title: Text(
                                        "Historique des achats",
                                        style: context.theme.textTheme.caption,
                                      ),
                                    ),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final item = items[index];
                                        return CustomListTile(
                                          title: Text('${item.tokens.toString().padLeft(2, '0')} tokens acheté(s)'),
                                          subtitle: Text(MaterialLocalizations.of(context).formatFullDate(item.createdAt!)),
                                          trailing: Text(
                                            '${item.amount.toString().padLeft(2, '0')} F',
                                            style: context.cupertinoTheme.textTheme.navTitleTextStyle,
                                          ),
                                        );
                                      },
                                      childCount: items.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return SliverFillRemaining(child: CustomErrorPage(onTap: () => _queryPurchaseList(true)));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
