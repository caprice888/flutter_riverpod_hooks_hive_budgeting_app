import 'dart:io';

import 'package:budgeting_app_v2/routes/route_transitions.dart';
import 'package:budgeting_app_v2/screens/area_graph_screen.dart';
import 'package:budgeting_app_v2/screens/login_web_screen.dart';
import 'package:budgeting_app_v2/screens/stacked_bar_graph_v1.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


import '../screens/custom_stacked_bar_graph_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/stacked_bar_graph_v2.dart';
import 'bottom_nav_scaffold.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => (!kIsWeb) ? LoginScreen() : LoginWebScreen(), //skip local auth if running web(no biometrics)
    ),
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: (context, state, child) {
        return BottomNavScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => fadeThroughTransition(context, state, HomeScreen()),
        ),
        GoRoute(
          path: '/areagraph',
          pageBuilder: (context, state) => fadeThroughTransition(context, state, CustomStackedBarGraphScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => fadeThroughTransition(context, state, SettingsScreen()),
        ),       
      ],
    ),
  ],
);