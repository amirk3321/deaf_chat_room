import 'package:deaf_chat/cubit/auth/auth_cubit.dart';
import 'package:deaf_chat/cubit/login/login_cubit.dart';
import 'package:deaf_chat/pages/home_page.dart';
import 'package:deaf_chat/pages/signin.dart';
import 'package:deaf_chat/widgets/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool _obscureText = true;
  GlobalKey<ScaffoldState> _globalKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body:BlocConsumer<LoginCubit,LoginState>(
        builder: (context,LoginState loginState){
          if (loginState is LoginSuccess){
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  print("authenticsted ${authState.uid}");
                  return HomePage(uid: authState.uid,);
                } else {
                  print("Unauthenticsted");
                  return _bodyWidget();
                }
              },
            );
          }
          return _bodyWidget();
        },
        listener: (context,LoginState loginState){
          if (loginState is LoginFailure){
            snackBarError(
              msg: "Check your email, password",
              scaffoldState: _globalKey
            );
          }
          if (loginState is LoginSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
        },
      ),
    );
  }
  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                const Color(0xff007EF4),
                const Color(0xffFFFFFF),
                const Color(0xffFFFFFF),
                const Color(0xffFFFFFF),
                const Color(0xffFFFFFF),
              ]
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 60,),
              Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Text("Hey, get on board", style: TextStyle(fontFamily: 'Code128', fontSize: 20.0))
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                      width: double.infinity,
                      child: Text("Sign Up", style: TextStyle(fontFamily: 'Arial', fontSize: 35.0,fontWeight: FontWeight.bold))
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children:[
                        TextFormField(
                          validator: (val){
                            if(val.isEmpty){return "Please enter name";}
                            if(val.length <=2){return "Please enter valid name";}
                            else{return null;}
                          },
                          controller: userNameTextEditingController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                          ),
                        ),
                        TextFormField(
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val) ? null : "Enter correct email";
                          },
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        TextFormField(
                          validator:  (val){
                            return val.length < 6 ? "Enter Password 6+ characters" : null;
                          },
                          controller: passwordTextEditingController,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon:  GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText   = ! _obscureText;
                                });
                              },
                              child: Icon(_obscureText ? Icons.visibility: Icons.visibility_off,color: Colors.black45,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: (){
                  _submitSignUp();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),

              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have account? ",style: TextStyle(fontSize: 12,color: Colors.black)),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>SignIn()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2,),
                      child: Text("Login Now",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 150,),
            ],
          ),
        ),
      ),
    );
  }
  void _submitSignUp() {
    if (userNameTextEditingController.text.isNotEmpty && emailTextEditingController.text.isNotEmpty && passwordTextEditingController.text.isNotEmpty){
      BlocProvider.of<LoginCubit>(context).signUpSubmit(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
        name: userNameTextEditingController.text,
      );
    }
    _clear();

  }
  void _clear(){
    emailTextEditingController.clear();
    passwordTextEditingController.clear();
    userNameTextEditingController.clear();
  }
}
