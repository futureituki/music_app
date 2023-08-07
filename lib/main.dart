import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:sakura_music_app/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // この行を追加
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
