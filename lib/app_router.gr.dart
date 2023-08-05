// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:sakura_music_app/detail.dart' as _i3;
import 'package:sakura_music_app/home.dart' as _i1;
import 'package:sakura_music_app/root_page.dart' as _i2;
import 'package:sakura_music_app/search.dart' as _i4;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomePage(),
      );
    },
    HomeRouterRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeRouterPage(),
      );
    },
    RootRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.RootPage(),
      );
    },
    DetailRoute.name: (routeData) {
      final args = routeData.argsAs<DetailRouteArgs>(
          orElse: () => const DetailRouteArgs());
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.DetailPage(param: args.param),
      );
    },
    SearchRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.SearchPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i1.HomeRouterPage]
class HomeRouterRoute extends _i5.PageRouteInfo<void> {
  const HomeRouterRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRouterRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i2.RootPage]
class RootRoute extends _i5.PageRouteInfo<void> {
  const RootRoute({List<_i5.PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DetailPage]
class DetailRoute extends _i5.PageRouteInfo<DetailRouteArgs> {
  DetailRoute({
    String param = '',
    List<_i5.PageRouteInfo>? children,
  }) : super(
          DetailRoute.name,
          args: DetailRouteArgs(param: param),
          initialChildren: children,
        );

  static const String name = 'DetailRoute';

  static const _i5.PageInfo<DetailRouteArgs> page =
      _i5.PageInfo<DetailRouteArgs>(name);
}

class DetailRouteArgs {
  const DetailRouteArgs({this.param = ''});

  final String param;

  @override
  String toString() {
    return 'DetailRouteArgs{param: $param}';
  }
}

/// generated route for
/// [_i4.SearchPage]
class SearchRoute extends _i5.PageRouteInfo<void> {
  const SearchRoute({List<_i5.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
