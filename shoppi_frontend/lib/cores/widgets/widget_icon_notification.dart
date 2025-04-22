// import 'package:flutter/material.dart';

// class WidgetIconCart extends StatefulWidget {
//   const WidgetIconCart({super.key, this.padding});
//   final EdgeInsetsGeometry? padding;

//   @override
//   State<WidgetIconCart> createState() => _WidgetIconCartState();
// }

// class _WidgetIconCartState extends State<WidgetIconCart> {
//   // ValueNotifierData<int> unread = GlobalNotificationData.count;
//   NotificationBloc notificationBloc = NotificationBloc();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback(
//       (timeStamp) {
//         try {
//           notificationBloc.add(EventNotificationUnread());
//           setState(() {});
//         } catch (e) {
//           rethrow;
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => notificationBloc,
//       child: BlocListener(
//         bloc: notificationBloc,
//         listener: (context, state) {
//           if (state is StateNotificationUnread) {
//             FirebaseNotification.instant.unread.value = state.countUnread ?? 0;
//             FirebaseNotification.instant.unread.callNotifyListeners();
//           }
//         },
//         child: ValueListenableBuilder(
//           valueListenable: FirebaseNotification.instant.unread,
//           builder: (context, value, child) => WidgetAnimationClick(
//             child: Padding(
//               padding: widget.padding ?? EdgeInsets.zero,
//               child: badges.Badge(
//                 badgeContent: FirebaseNotification.instant.unread.value > 0
//                     ? Text(
//                         FirebaseNotification.instant.unread.value < 100
//                             ? FirebaseNotification.instant.unread.value
//                                 .toString()
//                             : '99+',
//                         style:
//                             StyleFont.medium(12).copyWith(color: Colors.white),
//                       )
//                     : null,
//                 position: FirebaseNotification.instant.unread.value > 0
//                     ? (FirebaseNotification.instant.unread.value < 10
//                         ? badges.BadgePosition.topEnd(top: -15, end: -5)
//                         : badges.BadgePosition.topEnd(top: -15, end: -15))
//                     : null,
//                 showBadge: FirebaseNotification.instant.unread.value > 0,
//                 ignorePointer: false,
//                 badgeStyle: badges.BadgeStyle(
//                   borderSide: const BorderSide(color: Colors.white, width: 1),
//                   shape: FirebaseNotification.instant.unread.value < 10
//                       ? badges.BadgeShape.circle
//                       : badges.BadgeShape.square,
//                   borderRadius: BorderRadius.circular(12),
//                   padding: FirebaseNotification.instant.unread.value < 10
//                       ? const EdgeInsets.all(6)
//                       : const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                 ),
//                 child: Assets.lib.features.home.assets.homes.notify.svg(),
//               ),
//             ),
//             onTap: () {
//               context.goPage(NotificationScreen(
//                 unread: FirebaseNotification.instant.unread,
//               ));
//               setState(() {});
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
