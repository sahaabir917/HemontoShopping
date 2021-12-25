import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hemontoshoppin/blocs/allorderbloc/all_order_bloc.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/categorybloc/category_bloc.dart';
import 'package:hemontoshoppin/blocs/dealdetails/deal_details_bloc.dart';
import 'package:hemontoshoppin/blocs/discountedproduct/discounted_product_bloc.dart';
import 'package:hemontoshoppin/blocs/loginbloc/login_bloc.dart';
import 'package:hemontoshoppin/blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'package:hemontoshoppin/blocs/packageproduct/package_product_bloc.dart';
import 'package:hemontoshoppin/blocs/pendingorders/pending_order_bloc.dart';
import 'package:hemontoshoppin/blocs/subcategory_bloc/subcategory_bloc.dart';
import 'package:hemontoshoppin/blocs/subcategorywiseproductbloc/subcategorywiseproduct_bloc.dart';
import 'package:hemontoshoppin/blocs/suggestedproducts/suggested_bloc.dart';
import 'package:hemontoshoppin/views/cart/cart_page.dart';
import 'package:hemontoshoppin/views/category/category_page.dart';
import 'package:hemontoshoppin/views/dealpage/deal_page.dart';
import 'package:hemontoshoppin/views/login_page.dart';
import 'package:hemontoshoppin/views/notification/AllNotification.dart';
import 'package:hemontoshoppin/views/order/order_page.dart';
import 'package:hemontoshoppin/views/product_page.dart';
import 'package:hemontoshoppin/views/productviews/product_with_subcat_page.dart';

import 'blocs/dealsbloc/deal_bloc.dart';
import 'blocs/favbloc/favbloc.dart';
import 'blocs/mostpopularbloc/mostpopular_bloc.dart';
import 'blocs/productbloc/product_bloc.dart';
import 'blocs/productdetailsbloc/product_details_bloc.dart';
import 'views/productviews/ProductDetailsPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
//   RemoteNotification notification = message.notification;
//   AndroidNotification android = message.notification?.android;
//   print(notification.title);
//   print(notification.body);
//
//
//   flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channel.description,
//           color: Colors.blue,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//         ),
//       ));
//
//
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<MostPopularBloc>(
          create: (context) => MostPopularBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider<SubCategoryBloc>(
          create: (context) => SubCategoryBloc(),
        ),
        BlocProvider<SubCategoryWiseProductBloc>(
          create: (context) => SubCategoryWiseProductBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        BlocProvider<ProductDetailsBloc>(
          create: (context) => ProductDetailsBloc(),
        ),
        BlocProvider<FavBloc>(
          create: (context) => FavBloc(),
        ),
        BlocProvider<PackageProductBloc>(
          create: (context) => PackageProductBloc(),
        ),
        BlocProvider<DiscountedProductBloc>(
          create: (context) => DiscountedProductBloc(),
        ),
        BlocProvider<DealBloc>(
          create: (context) => DealBloc(),
        ),
        BlocProvider<DealDetailsBloc>(
          create: (context) => DealDetailsBloc(),
        ),
        BlocProvider<PendingOrderBloc>(
          create: (context) => PendingOrderBloc(),
        ),
        BlocProvider<AllOrderBloc>(
          create: (context) => AllOrderBloc(),
        ),
        BlocProvider<SuggestedBloc>(
          create: (context) => SuggestedBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductPage(),
        routes: {
          "/login_page": (context) => LoginPage(),
          "/product_page": (context) => ProductPage(),
          "/product_details": (context) => ProductDetailsPage(),
          "/category_page": (context) => CategoryPage(),
          "/subcat_wise_product": (context) => ProductWithSubCategory(),
          "/cart_page": (context) => CartPage(),
          "/all_notification": (context) => AllNotification(),
          "/all_deals": (context) => DealPage(),
          "/my_orders": (context) => OrderPage(),
        },
      ),
    );
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing123",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage message) {
    //   if (message != null) {
    //     Navigator.pushNamed(context, "all_notification");
    //   }});
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     // flutterLocalNotificationsPlugin.show(
    //     //     notification.hashCode,
    //     //     notification.title,
    //     //     notification.body,
    //     //     NotificationDetails(
    //     //       android: AndroidNotificationDetails(
    //     //         channel.id,
    //     //         channel.name,
    //     //         channel.description,
    //     //         color: Colors.blue,
    //     //         playSound: true,
    //     //         icon: '@mipmap/ic_launcher',
    //     //       ),
    //     //     ));
    //     Navigator.pushNamed(context, "/all_notification");
    //   }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     // showDialog(
    //     //     context: context,
    //     //     builder: (_) {
    //     //       return AlertDialog(
    //     //         title: Text(notification.title),
    //     //         content: SingleChildScrollView(
    //     //           child: Column(
    //     //             crossAxisAlignment: CrossAxisAlignment.start,
    //     //             children: [Text(notification.body)],
    //     //           ),
    //     //         ),
    //     //       );
    //     //     });
    //     Navigator.pushNamed(context, "/all_notification");
    //   }
    // });
  }
}
