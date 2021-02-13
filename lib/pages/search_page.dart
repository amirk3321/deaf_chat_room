

import 'package:deaf_chat/cubit/user/user_cubit.dart';
import 'package:deaf_chat/pages/single_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  final String uid;

  const SearchPage({Key key, this.uid}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  TextEditingController _textController=TextEditingController();

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getAllUsers();
    _textController.addListener(() {setState(() {});});
    super.initState();
  }
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: BlocBuilder<UserCubit,UserState>(
        builder: (context,UserState userState){
          if (userState is UserLoaded){
            final users=userState.users.where((user) => user.uid !=widget.uid).toList();
            final filterUsers=users.where((users) => users.uid != widget.uid && users.name.toLowerCase().contains(_textController.text.toLowerCase())).toList();
            print(widget.uid);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Search..",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(child: ListView.builder(
                    itemCount: filterUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${filterUsers[index].name}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),),
                                  SizedBox(height: 4,),
                                  Text("${filterUsers[index].email}",style: TextStyle(color: Colors.black.withOpacity(.4)),),
                                ],
                              ),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => SingleChatPage(uid: widget.uid,otherUid:filterUsers[index].uid,otherUserName: filterUsers[index].name,channelId: null,)));
                                BlocProvider.of<UserCubit>(context).createChatChannel(uid: widget.uid,otherUid: filterUsers[index].uid);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Text("Message"),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
                ],
              ),
            );
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
