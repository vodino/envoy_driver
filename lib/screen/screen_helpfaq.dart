import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  static const String path = 'helpfaq';
  static const String name = 'helpfaq';

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  /// RubricService
  late final RubricService _rubricService;

  void _listenRubricState(BuildContext context, RubricState state) {}

  Future<void> _queryRubricList([bool pending = false]) {
    if (pending) _rubricService.value = const PendingRubricState();
    return _rubricService.handle(const QueryRubricList());
  }

  @override
  void initState() {
    super.initState();

    /// RubricService
    _rubricService = RubricService.instance();
    if (_rubricService.value is! RubricItemListState) WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _queryRubricList(true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HelpFaqAppBar(),
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: _queryRubricList),
          ValueListenableConsumer<RubricState>(
            listener: _listenRubricState,
            valueListenable: _rubricService,
            builder: (context, state, child) {
              if (state is PendingRubricState) {
                return const SliverFillRemaining(child: HelpFaqShimmer());
              } else if (state is RubricItemListState) {
                final items = state.data;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      return HelpFaqListTile(
                        message: item.answer!,
                        title: item.question!,
                        index: index + 1,
                      );
                    },
                    childCount: items.length,
                  ),
                );
              }
              return SliverFillRemaining(hasScrollBody: false, child: CustomErrorPage(onTap: () => _queryRubricList(true)));
            },
          ),
        ],
      ),
    );
  }
}
