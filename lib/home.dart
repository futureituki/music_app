import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sakura_music_app/app_router.gr.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.navigateTo(const DetailRoute()),
          child: const Text('詳細'),
        ),
      ),
    );
  }
}

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({super.key});
}
