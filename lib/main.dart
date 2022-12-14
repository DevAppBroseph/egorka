import 'package:egorka/core/bloc/deposit/deposit_bloc.dart';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/helpers/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  LocationGeo().checkPermission;
  initializeDateFormatting('ru');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message recieved");
    print(event.notification!.body);
  });

  String? token = await FirebaseMessaging.instance.getToken();

  print('object ${token}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchAddressBloc>(
            create: (context) => SearchAddressBloc()),
        BlocProvider<HistoryOrdersBloc>(
          create: (context) => HistoryOrdersBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<DepositBloc>(
          create: (context) => DepositBloc(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(428, 926),
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoute.home,
              onGenerateRoute: AppRoute.onGenerateRoute,
              builder: FlutterSmartDialog.init(),
            );
          }),
    );
  }
}
