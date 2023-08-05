import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class DetailPage extends StatefulWidget {
  final String param;
  DetailPage({this.param = ''});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // ListResult data = getStorageData('startover');
  final Future<String> _getMusic = Future<String>.delayed(
    const Duration(seconds: 3),
    () => 'Data Loaded',
  );
  Image? _img;
  List<String>? _text;
  String? currentText;
  List<String>? _urls;
  // late AudioPlayer _player;
  AudioPlayer? _player = AudioPlayer();
  ConcatenatingAudioSource? _playlist;
  bool _isPlaying = false;
  final storageRef = FirebaseStorage.instance.ref();
  Future<void> getData() async {
    Reference imageRef = storageRef.child(widget.param + '/main_visual.jpg');
    String imageUrl = await imageRef.getDownloadURL();
    Reference textRef = storageRef.child(widget.param + "/music.json");
    var data = await textRef.getDownloadURL();
    var uri = Uri.parse(data);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        Utf8Codec utf8Codec = Utf8Codec();
        List<int> responseBytes = response.bodyBytes;
        String jsonData = utf8Codec.decode(responseBytes);

        // JSONデータを解析して画面に反映
        List<dynamic> jsonList = jsonDecode(jsonData);
        setState(() {
          _text = jsonList.map((item) => item['name'] as String).toList();
        });
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e);
    }
    // 画面に反映
    setState(() {
      _img = Image.network(imageUrl);
    });
    // Method body here
    // print(data.prefixes);
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    _setupSession('startover/audio');
    super.initState();
  }

  Future<String> getItemDownloadUrl(String fullPath) async {
    Reference audioRef = storageRef.child(fullPath);
    String imageUrl = await audioRef.getDownloadURL();
    return imageUrl;
  }

  Future<void> loadUrl() async {}
  Future<void> _setupSession(String strSePath) async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    List<String> test = [];
    Reference audioRef = storageRef.child('startover/audio');
    ListResult lists = await audioRef.listAll().then((value) => value);
    for (var element in lists.items) {
      Reference islandRef = storageRef.child(element.fullPath);
      String url = await islandRef.getDownloadURL();
      test.add(url);
    }
    setState(() {
      _playlist = ConcatenatingAudioSource(
        // Start loading next item just before reaching it
        useLazyPreparation: true,
        // Customise the shuffle algorithm
        shuffleOrder: DefaultShuffleOrder(),
        // Specify the playlist items
        children: [
          for (var element in test)
            AudioSource.uri(Uri.parse(element), tag: element),
        ],
      );
    });
    await _player!.setAudioSource(_playlist!);
  }

  Future<void> _playSoundFile() async {
    // 再生終了状態の場合、新たなオーディオファイルを定義し再生できる状態にする
    _player!.currentIndexStream.listen((index) {
      currentText = _text![index!];
    });
    _isPlaying = true;
    setState(() {});
    await _player!.setVolume(1.0); // 音量を指定
    await _player!.play();
  }

  Future<void> _selectTrack(int index) async {
    _player!.currentIndexStream.listen((index) {
      currentText = _text![index!];
    });
    setState(() {});
    await _player!.seek(Duration.zero, index: index);
  }

  Future<void> _stopSoundFile() async {
    _player!.currentIndexStream.listen((index) {
      currentText = _text![index!];
    });
    _isPlaying = false;
    setState(() {});
    await _player!.pause();
  }

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
      body: FutureBuilder<String>(
        future: _getMusic, // Future<T> 型を返す非同期処理
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (_img != null && _text != null) {
            // 値が存在する場合の処理5
            children = <Widget>[
              _img!,
              currentText == null ? Text(_text![0]) : Text(currentText!),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(widget.param),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.skip_previous),
                            onPressed: () async {
                              await _player!.seekToPrevious();
                              _playSoundFile();
                            }),
                        IconButton(
                          icon: _isPlaying
                              ? const Icon(Icons.play_arrow)
                              : const Icon(Icons.pause_circle_filled),
                          onPressed: () async {
                            if (_isPlaying) {
                              await _stopSoundFile();
                            } else {
                              await _playSoundFile();
                            }
                          },
                        ),
                        IconButton(
                            icon: const Icon(Icons.skip_next),
                            onPressed: () async {
                              if (_isPlaying == false) {
                                setState(() {
                                  _isPlaying = true;
                                });
                              }
                              await _player!.seekToNext();
                              _playSoundFile();
                            })
                      ],
                    ),
                    Column(
                      children: _text!
                          .map(
                            (String e) => ListTile(
                              title: Text(
                                e,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21,
                                ),
                              ),
                              onTap: () => {
                                _selectTrack(_text!.indexOf(e)),
                              },
                            ),
                          )
                          .toList(), // Iterable<Widget>をList<Widget>に変換
                    )
                  ]))
            ];
          } else if (snapshot.hasError) {
            // エラーが発生した場合の処理
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            // 値が存在しない場合の処理
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ));
        },
      ),
    );
  }
  // return Scaffold(
  //   appBar: AppBar(actions: [
  //     IconButton(
  //       onPressed: () {
  //         context.router.pop();
  //       },
  //       icon: const Icon(Icons.close),
  //     )
  //   ]),
  //   body: Center(
  //     child: Column(
  //       children: [
  //         if (_img != null) _img!,
  //         ElevatedButton(
  //           onPressed: () {
  //             getData();
  //             print('aaa');
  //           },
  //           child: Text(widget.param.toString()),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
}
