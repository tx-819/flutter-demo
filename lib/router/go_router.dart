import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/counter/counter.dart';
import 'package:my_app/detail/detail.dart';

final GoRouter goRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const CounterPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'detail',
          builder: (BuildContext context, GoRouterState state) {
            return const DetailPage();
          },
        ),
      ],
    ),
  ],
);