import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sakura_music_app/app_router.dart';
import 'package:sakura_music_app/root_page.dart';
import 'package:sakura_music_app/search.dart';
import 'bottom_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter(); //追加
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: _appRouter.config(), // 追加
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.green,
        ),
      ),
      // routes: {
      //   '/': (context) => const MyWidget(),
      //   '/search': (context) => const SearchWiget(),
      // },
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Material 3'),
        ),
        body: const BottomNavbarApp());
  }
}
