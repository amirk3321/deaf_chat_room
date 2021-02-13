
import 'package:deaf_chat/cubit/auth/auth_cubit.dart';
import 'package:deaf_chat/cubit/my_chat/my_chat_cubit.dart';
import 'package:deaf_chat/entities/user_entity.dart';
import 'package:deaf_chat/pages/pdf_read_page.dart';
import 'package:deaf_chat/pages/pdf_read_page2.dart';
import 'package:deaf_chat/pages/search_page.dart';
import 'package:deaf_chat/pages/single_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({Key key, this.uid}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    BlocProvider.of<MyChatCubit>(context).getMyChat(uid: widget.uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: PopupMenuButton(

              tooltip: 'Menu',
              child: Icon(
                Icons.more_vert,
                size: 28.0,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => PdfReadPage()
                      ));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.help,
                          color: Colors.black54,
                          size: 22.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            "Help",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => PdfReadPage2()
                      ));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.black54,
                          size: 22.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            "About Us",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black54,
                        size: 22.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          BlocProvider.of<AuthCubit>(context).loggedOut();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.search ,
          color : Colors.white,
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage(uid: widget.uid,)));
        },
      ),
      body: BlocBuilder<MyChatCubit,MyChatState>(
        builder: (context,MyChatState myChatState){
          if (myChatState is MyChatLoaded){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: ListView.builder(
              itemCount: myChatState.myChat.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SingleChatPage(channelId: myChatState.myChat[index].channelId,uid: widget.uid,otherUid:myChatState.myChat[index].recipientUID,otherUserName: myChatState.myChat[index].recipientName,)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(.2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${myChatState.myChat[index].recipientName}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),),
                      ],
                    ),
                  ),
                );
              },),
          );
          }
          return Container(
            child: Center(
              child: Text("add user"),
            ),
          );
        },
      ),
    );
  }
}
