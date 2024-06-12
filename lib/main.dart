import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'hive_init.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


import 'models/transaction_model.dart';
import 'models/user_data_model.dart';
import 'routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Get the application documents directory
  Directory? appDocDir;
  String? appDocPath;

  //check platform
  if(kIsWeb){
    //web
    print("DEBUG: Running on web");
    await Hive.initFlutter();
    print("DEBUG: Hive initialized");
  }
  else{
    //mobile
    appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
    // Initialize Hive with the custom path
    await Hive.initFlutter(appDocPath);
  }

  // // Initialize Hive with the custom path
  // await Hive.initFlutter(appDocPath);

  //adapter registration
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(UserDataModelAdapter());

  //inital open box operation (all other calls become refrences)
  await Hive.openBox<UserDataModel>('userDataBox');
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Budgeting App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
