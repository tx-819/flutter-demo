import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/detail/cubit/detail_cubit.dart';
import 'package:my_app/l10n/l10n.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailCubit(),
      child: const DetailView(),
    );
  }
}

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  String imgUrl = 'assets/images/background-image.png';
  bool showAppOptions = false;
  String? pickedEmoji;
  File? _image;
  Offset _emojiPosition = const Offset(50, 50);
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        showAppOptions = true;
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    final emojis = <String>[
      'assets/images/emoji1.png',
      'assets/images/emoji2.png',
      'assets/images/emoji3.png',
      'assets/images/emoji4.png',
      'assets/images/emoji5.png',
      'assets/images/emoji6.png',
    ];
    final emojiList = <Widget>[];

    for (var i = 0; i < emojis.length; i++) {
      emojiList.add(InkWell(
        onTap: () {
          setState(() {
            pickedEmoji = emojis[i];
            Navigator.pop(context);
          });
        },
        child: Image.asset(
          emojis[i],
          width: 50,
        ),
      ));
    }

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 200,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 36,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: emojiList,
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveImage() async {
    try {
      final boundary = _globalKey.currentContext!.findRenderObject()!
      as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // 使用 image_gallery_saver 保存图片到相册
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 100,
        name: 'snapshot',
      );

      if ((result['isSuccess']) as bool) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image: ${result['errorMessage']}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save image: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailAppBarTitle)),
      backgroundColor: Colors.black38,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: Stack(
                children: [
                  if (_image == null)
                    Image.asset(
                      imgUrl,
                      width: 360,
                      height: 400,
                      fit: BoxFit.cover,
                    )
                  else
                    Image.file(_image!),
                  if (pickedEmoji != null)
                    Positioned(
                      left: _emojiPosition.dx,
                      top: _emojiPosition.dy,
                      child: Draggable(
                        feedback: Image.asset(pickedEmoji!, width: 50),
                        childWhenDragging: Container(),
                        onDragEnd: (dragDetails) {
                          final renderBox = _globalKey.currentContext!
                              .findRenderObject()! as RenderBox;
                          final localPosition = renderBox.globalToLocal(
                            dragDetails.offset,
                          );
                          setState(() {
                            _emojiPosition = localPosition;
                          });
                        },
                        child: Image.asset(pickedEmoji!, width: 50),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: showAppOptions
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restart_alt,
                              color: Colors.white70, size: 42),
                          onPressed: () {
                            setState(() {
                              showAppOptions = false;
                              _image = null;
                              pickedEmoji = null;
                              _emojiPosition = const Offset(50, 50);
                            });
                          },
                        ),
                        ElevatedButton(
                          child: const Icon(Icons.add,
                              color: Colors.black54, size: 42),
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.download,
                              color: Colors.white70, size: 42),
                          onPressed: _saveImage,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Choose a photo'),
                        ),
                        ElevatedButton(
                          child: const Text('Use this photo'),
                          onPressed: () {
                            setState(() {
                              showAppOptions = true;
                            });
                          },
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
