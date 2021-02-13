import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deaf_chat/cubit/one_to_one_chat/one_to_one_chat_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'custom_keyboard.dart';

typedef scrollDownVoidCallBack = Function();

class DeafKeyBoardEditor extends StatefulWidget {
  final String name;
  final String uid;
  final scrollDownVoidCallBack onScrollDown;
  final String otherUID;
  final String senderName;
  final String receiverName;
  final String chatRoomId;
  final String channelId;
  final int messageType;

  DeafKeyBoardEditor(
      {Key key,
      this.onScrollDown,
      this.name,
      this.uid,
      this.otherUID,
      this.senderName,
      this.chatRoomId,
      this.receiverName,
      this.channelId,
      this.messageType})
      : super(key: key);

  @override
  _DeafKeyBoardEditorState createState() => _DeafKeyBoardEditorState();
}

class _DeafKeyBoardEditorState extends State<DeafKeyBoardEditor> {
  String _singleTextPicker = "";
  List<String> _signToText = [];
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 100),
        () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 500)));
    return Column(
      children: <Widget>[
        Container(
          height: 45,
          child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _suggested.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        BlocProvider.of<OneToOneChatCubit>(
                            context)
                            .sendTextMessage(
                            content: _suggested[index],
                            receiverName: widget.receiverName,
                            recipientId: widget.otherUID,
                            senderId: widget.uid,
                            senderName: widget.senderName,
                            recipientPhoneNumber: "",
                            senderPhoneNumber: "",
                            messageType: "IMAGE"
                        );
                      },
                      child: Card(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Image.asset(_suggested[index],fit: BoxFit.fitWidth,),
                        ),
                      ),
                    );
                  }),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.4),
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: deafKeyboard(),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          color: Colors.white,
          child: CustomKeyboard(
            onSend: () {
              Fluttertoast.showToast(msg: "working");
            },
            onSpace: () {
              setState(() {
                _singleTextPicker += " ";
                _signToText.add('-');
              });
            },
            onLongPressed: () {
              setState(() {
                _signToText.clear();
                _singleTextPicker = "";
              });
            },
            onBackPress: () {
              if (mounted)
                setState(() {
                  _signToText.removeAt(_signToText.length - 1);
                });
            },
            onSave: (text) {
              if (mounted)
                setState(() {
                  if (widget.messageType == 1) {
                    _singleTextPicker += text;
                    final image = signToText(text: text);
                    _signToText.add(image);
                    print(_singleTextPicker);
                  } else if (widget.messageType == 2) {
                    _singleTextPicker += text;
                    final image = signToText(text: text);
                    _signToText.add(image);
                    print(_singleTextPicker);
                  } else {
                    _singleTextPicker += text;
                    // _singleTextPicker += text;
                    final image = signToText(text: text);
                    _signToText.add(image);
                    print(_signToText.length);
                  }
                });
            },
          ),
        ),
      ],
    );
  }

  Widget deafKeyboard() => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.5, 0.2),
                color: Colors.black54,
                blurRadius: .2,
              )
            ],
            color: Colors.grey[100]),
        child: Row(
          children: <Widget>[
           SizedBox(width: 25,),

            //TODO:add layout message
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 150),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: 50,
                      child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: _signToText.length,
                          itemBuilder: (context, index) {
                            if (_signToText[index] == "-")
                              return Container(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  ",",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            else
                              return Image.asset(_signToText[index]);
                          }),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _signToText.isEmpty
                  ? null
                  : () async {
                      //TODO: send message
                BlocProvider.of<OneToOneChatCubit>(context)
                    .sendTextMessage(
                  content: _singleTextPicker,
                  receiverName: widget.receiverName,
                  recipientId: widget.otherUID,
                  senderId: widget.uid,
                  senderName: widget.name,
                  recipientPhoneNumber: "",
                  senderPhoneNumber: "",
                  messageType: "TEXT"
                );

                      print(_singleTextPicker);
                      widget.onScrollDown();
                      print("send");
                      if (mounted)
                        setState(() {
                          _singleTextPicker = "";
                          _signToText.clear();
                        });
                    },
              icon: Icon(
                Icons.send,
                color:
                    _signToText.isEmpty ? Colors.green[200] : Colors.green[700],
              ),
            ),
          ],
        ),
      );



  List<String> _suggested = [
    "assets/help.jpeg",
    "assets/no.jpeg",
    "assets/more.jpeg",
    "assets/please.jpeg",
    "assets/thankyou.jpeg",
    "assets/yes.jpeg"
  ];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  String signToText({String text}) {
    switch (text) {
      case 'a':
        return "assets/data/a.jpg";
      case 'b':
        return "assets/data/b.jpg";
      case 'c':
        return "assets/data/c.jpg";
      case 'd':
        return "assets/data/d.jpg";
      case 'e':
        return "assets/data/e.jpg";
      case 'f':
        return "assets/data/f.jpg";
      case 'g':
        return "assets/data/g.jpg";
      case 'h':
        return "assets/data/h.jpg";
      case 'i':
        return "assets/data/i.jpg";
      case 'j':
        return "assets/data/j.jpg";
      case 'k':
        return "assets/data/k.jpg";
      case 'l':
        return "assets/data/l.jpg";
      case 'm':
        return "assets/data/m.jpg";
      case 'n':
        return "assets/data/n.jpg";
      case 'o':
        return "assets/data/o.jpg";
      case 'p':
        return "assets/data/p.jpg";
      case 'q':
        return "assets/data/q.jpg";
      case 'r':
        return "assets/data/r.jpg";
      case 's':
        return "assets/data/s.jpg";
      case 't':
        return "assets/data/t.jpg";
      case 'u':
        return "assets/data/u.jpg";
      case 'v':
        return "assets/data/v.jpg";
      case 'w':
        return "assets/data/w.jpg";
      case 'x':
        return "assets/data/x.jpg";
      case 'y':
        return "assets/data/y.jpg";
      case 'z':
        return "assets/data/z.jpg";
      case 'A':
        return "assets/data/a.jpg";
      case 'B':
        return "assets/data/b.jpg";
      case 'C':
        return "assets/data/c.jpg";
      case 'D':
        return "assets/data/d.jpg";
      case 'E':
        return "assets/data/e.jpg";
      case 'F':
        return "assets/data/f.jpg";
      case 'G':
        return "assets/data/g.jpg";
      case 'H':
        return "assets/data/h.jpg";
      case 'I':
        return "assets/data/i.jpg";
      case 'J':
        return "assets/data/j.jpg";
      case 'K':
        return "assets/data/k.jpg";
      case 'L':
        return "assets/data/l.jpg";
      case 'M':
        return "assets/data/m.jpg";
      case 'N':
        return "assets/data/n.jpg";
      case 'O':
        return "assets/data/o.jpg";
      case 'P':
        return "assets/data/p.jpg";
      case 'Q':
        return "assets/data/q.jpg";
      case 'R':
        return "assets/data/r.jpg";
      case 'S':
        return "assets/data/s.jpg";
      case 'T':
        return "assets/data/t.jpg";
      case 'U':
        return "assets/data/u.jpg";
      case 'V':
        return "assets/data/v.jpg";
      case 'W':
        return "assets/data/w.jpg";
      case 'X':
        return "assets/data/x.jpg";
      case 'Y':
        return "assets/data/y.jpg";
      case 'Z':
        return "assets/data/z.jpg";
      case '1':
        return "assets/data/1.jpg";
      case '2':
        return "assets/data/2.jpg";
      case '3':
        return "assets/data/3.jpg";
      case '4':
        return "assets/data/4.jpg";
      case '5':
        return "assets/data/5.jpg";
      case '6':
        return "assets/data/6.jpg";
      case '7':
        return "assets/data/7.jpg";
      case '8':
        return "assets/data/8.jpg";
      case '9':
        return "assets/data/9.jpg";
      case '0':
        return "assets/data/0.jpg";
      default:
        return " ";
    }
  }
}
