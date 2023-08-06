import 'dart:async';
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
    const Duration(seconds: 4),
    () => 'Data Loaded',
  );
  Image? _img;
  List<String>? _text;
  String? currentText;
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
      _img = Image.network(
        imageUrl,
        width: 330,
      );
    });
    // Method body here
    // print(data.prefixes);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(() async {
      await getData();
      await _setupSession('startover/audio');
    });
  }

  Future<String> getItemDownloadUrl(String fullPath) async {
    Reference audioRef = storageRef.child(fullPath);
    String imageUrl = await audioRef.getDownloadURL();
    return imageUrl;
  }

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
        // shuffleOrder: DefaultShuffleOrder(),
        // Specify the playlist items
        children: [
          for (var element in test)
            AudioSource.uri(Uri.parse(element), tag: element),
        ],
      );
    });
    await _player!.setAudioSource(_playlist!);
  }

  @override
  void dispose() {
    _player!.dispose();
    super.dispose();
  }

  Future<void> _selectTrack(int index) async {
    _player!.currentIndexStream.listen((index) {
      currentText = _text![index!];
    });
    setState(() {});
    await _player!.seek(Duration.zero, index: index);
    await _player!.play();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds";
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
              SizedBox(
                height: 50,
              ),
              Text(widget.param,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  )),
              SizedBox(
                height: 50,
              ),
              _img!,
              Center(
                  child: Column(children: [
                SizedBox(
                  height: 50,
                ),
                StreamBuilder<int?>(
                  stream: _player!.currentIndexStream,
                  builder: (context, snapshot) {
                    final index = snapshot.data;
                    final currentTrackName = index != null
                        ? _text![index]
                        : "読み込み中です"; // Default text if index is null
                    return Text(
                      currentTrackName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder<Duration>(
                  stream: _player!.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = _player!.duration ?? Duration.zero;
                    if (position.inMilliseconds == 0 ||
                        duration.inMilliseconds == 0) {
                      // positionやdurationがnullの場合はローディング中として表示
                      return const SizedBox.shrink();
                    }
                    final progress =
                        position.inMilliseconds / duration.inMilliseconds;
                    return Column(
                      children: [
                        Slider(
                          value: progress,
                          onChanged: (value) {
                            final newPosition = value * duration.inMilliseconds;
                            _player!.seek(
                                Duration(milliseconds: newPosition.round()));
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${formatDuration(position)}', // 進んでいる秒数の表示
                            ),
                            Text(
                              '${formatDuration(duration)}', // 合計秒数の表示
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.skip_previous),
                        iconSize: 64.0,
                        onPressed: () async {
                          await _player!.seekToPrevious();
                        }),
                    StreamBuilder<PlayerState>(
                      stream: _player!.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 64.0,
                            height: 64.0,
                            child: const CircularProgressIndicator(),
                          );
                        } else if (playing != true) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            iconSize: 64.0,
                            onPressed: _player!.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return IconButton(
                            icon: const Icon(Icons.pause),
                            iconSize: 64.0,
                            onPressed: _player!.pause,
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.replay),
                            iconSize: 64.0,
                            onPressed: () => _player!.seek(Duration.zero),
                          );
                        }
                      },
                    ),
                    IconButton(
                        icon: const Icon(Icons.skip_next),
                        iconSize: 64.0,
                        onPressed: () async {
                          if (_isPlaying == false) {
                            setState(() {
                              _isPlaying = true;
                            });
                          }
                          await _player!.seekToNext();
                        })
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                StreamBuilder<int?>(
                  stream: _player!.currentIndexStream,
                  builder: (context, snapshot) {
                    final index = snapshot.data;
                    return Column(
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
                              tileColor: index == _text!.indexOf(e)
                                  ? Colors.blue
                                  : const Color.fromARGB(255, 141, 141, 141),
                              onTap: () => {
                                if (index != null)
                                  {
                                    _selectTrack(_text!.indexOf(e)),
                                  }
                              },
                            ),
                          )
                          .toList(), // Iterable<Widget>をList<Widget>に変換
                    );
                  },
                ),
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
}
