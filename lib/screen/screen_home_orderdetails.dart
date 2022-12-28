import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class HomeOrderDetailsScreen extends StatefulWidget {
  const HomeOrderDetailsScreen({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  State<HomeOrderDetailsScreen> createState() => _HomeOrderDetailsScreenState();
}

class _HomeOrderDetailsScreenState extends State<HomeOrderDetailsScreen> {
  Widget _itemDetailsTile({
    required String title,
    required String phone,
    String? description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomListTile(
          leading: const Icon(CupertinoIcons.phone_fill, color: CupertinoColors.systemFill, size: 16.0),
          subtitle: Text(phone, style: context.cupertinoTheme.textTheme.textStyle),
          title: Text(title, style: context.theme.textTheme.caption),
        ),
        Visibility(
          visible: description != null,
          child: Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 12.0),
                child: Text(
                  description!,
                  textAlign: TextAlign.left,
                  style: context.cupertinoTheme.textTheme.textStyle.copyWith(
                    color: context.cupertinoTheme.textTheme.tabLabelTextStyle.color,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Column(
      children: [
        CustomListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.order.capitalize(),
                style: widget.order.name != null ? context.cupertinoTheme.textTheme.tabLabelTextStyle : null,
              ),
              Text(
                localizations.createdate(MaterialLocalizations.of(context).formatCompactDate(widget.order.createdAt!), TimeOfDay.fromDateTime(widget.order.createdAt!).format(context)),
                style: context.cupertinoTheme.textTheme.tabLabelTextStyle,
              ),
            ],
          ),
          subtitle: widget.order.name != null ? Text(widget.order.name!.capitalize(), style: context.cupertinoTheme.textTheme.navTitleTextStyle) : null,
        ),
        const Divider(),
        OrderContentPlaceTile(
          title: Text(widget.order.pickupPlace!.title!),
          iconColor: CupertinoColors.activeBlue,
        ),
        const Divider(indent: 40.0),
        OrderContentPlaceTile(
          title: Text(widget.order.deliveryPlace!.title!),
          iconColor: CupertinoColors.activeOrange,
        ),
        const Divider(),
        OrderContentPriceTile(
          title: localizations.deliveryprice.capitalize(),
          price: widget.order.price!,
        ),
        Visibility(
          visible: widget.order.amountPaidedByRider != null,
          child: Builder(builder: (context) {
            return OrderContentPriceTile(
              title: localizations.purchasecourier.capitalize(),
              price: widget.order.amountPaidedByRider!,
            );
          }),
        ),
        ExpansionTile(
          childrenPadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          title: Text(localizations.moreinfo.capitalize(), style: const TextStyle(decoration: TextDecoration.underline)),
          children: [
            _itemDetailsTile(
              title: localizations.contactpickup.capitalize(),
              description: widget.order.pickupAdditionalInfo,
              phone: widget.order.pickupPhoneNumber!.phones!.join(', '),
            ),
            const Divider(),
            _itemDetailsTile(
              title: localizations.contactdelivery.capitalize(),
              description: widget.order.deliveryAdditionalInfo,
              phone: widget.order.deliveryPhoneNumber!.phones!.join(', '),
            ),
          ],
        ),
        Visibility(
          visible: widget.order.rider != null,
          child: Builder(
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(thickness: 8.0, height: 8.0),
                  CustomListTile(
                    height: 40.0,
                    title: Text('${localizations.orderstatus.capitalize()} :'),
                    trailing: Builder(builder: (context) {
                      switch (widget.order.status) {
                        case OrderStatus.accepted:
                          return Text(
                            localizations.acceptedcourier.capitalize(),
                            style: const TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600),
                          );
                        case OrderStatus.started:
                          return Text(
                            localizations.beingcollected.capitalize(),
                            style: const TextStyle(color: CupertinoColors.activeOrange, fontWeight: FontWeight.w600),
                          );
                        case OrderStatus.collected:
                          return Text(
                            localizations.beingdelivered.capitalize(),
                            style: const TextStyle(color: CupertinoColors.activeOrange, fontWeight: FontWeight.w600),
                          );
                        default:
                          return Text(
                            localizations.deliveredcompleted.capitalize(),
                            style: const TextStyle(color: CupertinoColors.activeGreen, fontWeight: FontWeight.w600),
                          );
                      }
                    }),
                  ),
                  CustomListTile(
                    // leading: CircleAvatar(
                    //   backgroundColor: CupertinoColors.systemGrey4,
                    //   foregroundImage: widget.order.client!.avatar != null ? NetworkImage('${RepositoryService.httpURL}/storage/${widget.order.client!.avatar}') : null,
                    // ),
                    title: Text(localizations.client.capitalize(), style: context.theme.textTheme.caption),
                    subtitle: Text(
                      widget.order.client!.fullName!,
                      style: context.cupertinoTheme.textTheme.navTitleTextStyle,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
