import 'package:auto_route/auto_route.dart';
import 'package:sakura_music_app/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: RootRoute.page,
          children: [
            AutoRoute(path: '', page: HomeRouterRoute.page, children: [
              AutoRoute(
                initial: true,
                page: HomeRoute.page,
              ),
              AutoRoute(
                path: 'detail',
                page: DetailRoute.page,
              ),
            ]),
            AutoRoute(
              path: 'search',
              page: SearchRoute.page,
            ),
            // AutoRoute(
            //   path: 'mypage',
            //   page: MypageRoute.page,
            // ),
          ],
        ),
      ];
}
