import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '_screen.dart';

class OrderFeedbackScreen extends StatefulWidget {
  const OrderFeedbackScreen({super.key, required this.order});

  final Order order;

  static const String name = 'order_feedback';
  static const String path = 'feedback';

  @override
  State<OrderFeedbackScreen> createState() => _OrderFeedbackScreenState();
}

class _OrderFeedbackScreenState extends State<OrderFeedbackScreen> {
  /// Customer
  late final TextEditingController _messageTextController;

  void _onClose() {
    Navigator.pop(context);
  }

  /// OrderService
  late final OrderService _orderService;

  void _listenOrderState(BuildContext context, OrderState state) {}

  void _submitMessage() {}

  @override
  void initState() {
    super.initState();

    /// Customer
    _messageTextController = TextEditingController();

    /// OrderService
    _orderService = OrderService();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Scaffold(
      appBar: OrderFeedbackAppBar(close: _onClose),
      body: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: CustomScrollView(
          controller: ModalScrollController.of(context),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 4.0,
                  child: CircleAvatar(backgroundColor: CupertinoColors.systemGrey),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomListTile(
                height: 60.0,
                title: Center(
                  child: Text(
                    widget.order.client!.fullName!,
                    style: context.cupertinoTheme.textTheme.navTitleTextStyle,
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    localizations.writedowncustomerorder.capitalize(),
                    style: context.cupertinoTheme.textTheme.textStyle,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: RatingBar.builder(
                  itemCount: 5,
                  minRating: 0,
                  initialRating: 0,
                  allowHalfRating: true,
                  direction: Axis.horizontal,
                  onRatingUpdate: (rating) {},
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: CustomListTile(height: 35.0, title: Text('Message'))),
            SliverToBoxAdapter(
              child: CustomTextField(
                controller: _messageTextController,
                hintText: '${localizations.type.capitalize()}...',
                maxLines: 6,
                minLines: 6,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ValueListenableConsumer<OrderState>(
                      listener: _listenOrderState,
                      valueListenable: _orderService,
                      builder: (context, state, child) {
                        VoidCallback? onPressed = _submitMessage;
                        if (state is PendingOrderState) onPressed = null;
                        return CupertinoButton.filled(
                          padding: EdgeInsets.zero,
                          onPressed: onPressed,
                          child: Visibility(
                            visible: onPressed != null,
                            replacement: const CupertinoActivityIndicator(),
                            child: Text(localizations.submit.capitalize()),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
