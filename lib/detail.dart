import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DetailPage extends StatelessWidget {
  const DetailPage({required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            context.router.pop();
          },
          icon: const Icon(Icons.close),
        )
      ]),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text(id.toString()),
        ),
      ),
    );
  }
}
