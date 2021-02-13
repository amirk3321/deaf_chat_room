import 'dart:async';

import 'package:deaf_chat/cubit/one_to_one_chat/one_to_one_chat_cubit.dart';
import 'package:deaf_chat/cubit/user/user_cubit.dart';
import 'package:deaf_chat/entities/user_entity.dart';
import 'package:deaf_chat/keyboard/deaf_keyboard.dart';
import 'package:deaf_chat/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleChatPage extends StatefulWidget {
  final String uid;
  final String otherUid;
  final String otherUserName;
  final String channelId;

  const SingleChatPage({Key key,this.channelId, this.uid, this.otherUid, this.otherUserName})
      : super(key: key);

  @override
  _SingleChatPageState createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  String messageContent = "";
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _changeKeyboardType = false;
  int _menuIndex = 0;


  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {});
    });
    BlocProvider.of<OneToOneChatCubit>(context).getMessages(
        senderId: widget.uid, recipientId: widget.otherUid,myChannelId: widget.channelId);
    BlocProvider.of<UserCubit>(context).getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: appBarMain(context),
      appBar: AppBar(
        title: Text("${widget.otherUserName}"),
        actions: [
          Switch(
            onChanged: (value) {
              setState(() {
                _changeKeyboardType = value;
              });
            },
            value: _changeKeyboardType,
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (BuildContext context, state) {

          if (state is UserLoaded) {
            final user = state.users.firstWhere((element) =>
            element.uid == widget.uid, orElse: () => UserModel());
            return BlocBuilder<OneToOneChatCubit, OneToOneChatState>(
              builder: (context, chatState) {
                if (chatState is OneToOneChatLoaded) {
                  Timer(
                      Duration(milliseconds: 100),
                          () => _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          curve: Curves.decelerate,
                          duration: Duration(milliseconds: 500)));
                  return Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: Container(
                              height: 90,
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: chatState.messages.length,
                                itemBuilder: (ctx, index) {
                                 String message= chatState.messages[index].content==" "?Text(" "):chatState.messages[index].content;
                                  if (chatState.messages[index].type=="IMAGE"){
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 160,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: widget.uid==chatState.messages[index].senderId?Colors.green.withOpacity(.2):Colors.blueGrey.withOpacity(.4),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            margin: EdgeInsets.all(10),
                                            alignment: widget.uid==chatState.messages[index].senderId?Alignment.topLeft:Alignment.topRight,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            child: Image.asset(chatState.messages[index].content),
                                          ),
                                        ),
                                        widget.uid==chatState.messages[index].senderId?InkWell(onTap: (){
                                          BlocProvider.of<UserCubit>(context).deleteMessage(channelId: chatState.messages[index].channelId,messageId: chatState.messages[index].messageId);
                                        },child: Icon(Icons.delete,color: Colors.grey,)):Text(""),

                                      ],
                                    );
                                  }
                                  return Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: widget.uid==chatState.messages[index].senderId?Colors.green.withOpacity(.2):Colors.blueGrey.withOpacity(.4),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            margin: EdgeInsets.all(10),
                                            alignment: widget.uid==chatState.messages[index].senderId?Alignment.topLeft:Alignment.topRight,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            child: ListView.builder(
                                              itemCount: message.length,
                                              shrinkWrap: true,
                                              //controller: _scrollController,
                                              scrollDirection: Axis.horizontal,
                                              physics: ScrollPhysics(),
                                              itemBuilder: (ctx, index) {
                                                return message[index]==" "?Text(" "):Image.asset(signToText(text: message[index]));
                                                // return Text("${chatState.messages[index].content}");
                                              },
                                            ),
                                          ),
                                        ),
                                        widget.uid==chatState.messages[index].senderId?InkWell(onTap: (){
                                          BlocProvider.of<UserCubit>(context).deleteMessage(channelId: chatState.messages[index].channelId,messageId: chatState.messages[index].messageId);
                                        },child: Icon(Icons.delete,color: Colors.grey,)):Text(""),
                                      ],
                                    ),
                                  );
                                  // return Text("${chatState.messages[index].content}");
                                },
                              ),
                            ),
                          ),
                        ),

                        _changeKeyboardType
                            ? DeafKeyBoardEditor(
                          uid: widget.uid,
                          receiverName: widget.otherUserName,
                          senderName: user.name,
                          name: user.name,
                          otherUID: widget.otherUid,
                          chatRoomId: "",
                          onScrollDown: () {
                            Timer(
                                Duration(milliseconds: 100),
                                    () =>
                                    _scrollController.animateTo(
                                        _scrollController.position
                                            .maxScrollExtent,
                                        curve: Curves.decelerate,
                                        duration: Duration(milliseconds: 500)));
                          },
                          channelId: "",
                          messageType: _menuIndex,
                        )
                            : Container(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                            padding:
                            EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                      controller: _messageController,
                                      onChanged: (value) {
                                        messageContent = value;
                                      },
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          hintText: "Message",
                                          hintStyle: TextStyle(
                                              color: Colors.black),
                                          border: InputBorder.none),
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<OneToOneChatCubit>(
                                          context)
                                          .sendTextMessage(
                                        content: _messageController.text,
                                        receiverName: widget.otherUserName,
                                        recipientId: widget.otherUid,
                                        senderId: widget.uid,
                                        senderName: user.name,
                                        recipientPhoneNumber: "",
                                        senderPhoneNumber: "",
                                        messageType: "TEXT"
                                      );
                                      setState(() {
                                        _messageController.clear();
                                      });
                                      Timer(
                                          Duration(milliseconds: 100),
                                          () => _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              curve: Curves.decelerate,
                                              duration: Duration(milliseconds: 500)));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                                40)),
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.send, color: Colors.white,)))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },),
    );
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
        return ",";
    }
  }
}
