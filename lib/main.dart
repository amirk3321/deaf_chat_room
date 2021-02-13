import 'package:deaf_chat/cubit/auth/auth_cubit.dart';
import 'package:deaf_chat/cubit/login/login_cubit.dart';
import 'package:deaf_chat/pages/home_page.dart';
import 'package:deaf_chat/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/my_chat/my_chat_cubit.dart';
import 'cubit/one_to_one_chat/one_to_one_chat_cubit.dart';
import 'cubit/user/user_cubit.dart';
import 'model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit()..appStarted(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(),
        ),
        BlocProvider<OneToOneChatCubit>(
          create: (_) => OneToOneChatCubit(),
        ),
        BlocProvider<MyChatCubit>(
          create: (_) => MyChatCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.blue),
        title: 'Deaf Chat',
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context){
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated)
                  return HomePage(uid: authState.uid,);
                if (authState is UnAuthenticated) {
                  return SignIn();
                }
                return Container();
              },
            );
          }
        },
      ),
    );
  }
}
