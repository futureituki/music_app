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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () =>
                  context.navigateTo(DetailRoute(param: 'startover')),
              child: const Text('Start over!'),
            ),
            ElevatedButton(
              onPressed: () => context.navigateTo(DetailRoute(param: '桜月')),
              child: const Text('桜月'),
            ),
            ElevatedButton(
              onPressed: () => context.navigateTo(DetailRoute(param: '五月雨よ')),
              child: const Text('五月雨よ'),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({super.key});
}
