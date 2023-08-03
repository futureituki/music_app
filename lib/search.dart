import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('検索画面'),
        ),
        body: Center(
            child: Column(children: [
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.search),
              labelText: '曲名を検索',
            ),
          )
        ])));
  }
}
