import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sakura_music_app/app_router.gr.dart';

@RoutePage()
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        // ここに各タブ画面のルートを追加する
        HomeRouterRoute(),
        SearchRoute(),
      ],
      builder: (context, child) {
        // タブが切り替わると発火します
        final tabsRouter = context.tabsRouter;
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'ホーム',
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                label: '検索',
              ),
            ],
            onDestinationSelected: tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }
}
