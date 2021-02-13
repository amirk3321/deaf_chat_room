import 'package:flutter/material.dart';

typedef OnSaveCallBack = Function(String text);
typedef onBackPressed = Function();
typedef onSendCallback = Function();
typedef onSpaceCallBack = Function();
typedef onLongPressedCallBack = Function();

class CustomKeyboard extends StatefulWidget {
  final OnSaveCallBack onSave;
  final onBackPressed onBackPress;
  final onSendCallback onSend;
  final onSpaceCallBack onSpace;
  final onLongPressedCallBack onLongPressed;

  CustomKeyboard(
      {Key key,
      this.onSave,
      this.onBackPress,
      this.onSend,
      this.onSpace,
      this.onLongPressed})
      : super(key: key);

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  bool isKeyboardHidden = false;
  bool isCapitalLatter = false;
  String _text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, constraint) {
        if (constraint.maxWidth > 600) {
          //Tablet_phone
          return keyboardMobile;
        } else if (constraint.maxWidth > 500) {
          //Mobile_phone_large
          return keyboardMobile;
        } else {
          //Mobile_phone
          return keyboardMobile;
        }
      },
    );
  }

  Column get keyboardMobile => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FittedBox(
            child: Row(
              children: <Widget>[
                buildContainer("1", "assets/data/1.jpg"),
                buildContainer("2", "assets/data/2.jpg"),
                buildContainer("3", "assets/data/3.jpg"),
                buildContainer("4", "assets/data/4.jpg"),
                buildContainer("5", "assets/data/5.jpg"),
                buildContainer("6", "assets/data/6.jpg"),
                buildContainer("7", "assets/data/7.jpg"),
                buildContainer("8", "assets/data/8.jpg"),
                buildContainer("9", "assets/data/9.jpg"),
                buildContainer("0", "assets/data/0.jpg"),
              ],
            ),
          ),
          FittedBox(
            child: Row(
              children: <Widget>[
                buildContainer(
                    isCapitalLatter == false ? "q" : "Q", "assets/data/q.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "w" : "W", "assets/data/w.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "e" : "E", "assets/data/e.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "r" : "R", "assets/data/r.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "t" : "T", "assets/data/t.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "y" : "Y", "assets/data/y.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "u" : "U", "assets/data/u.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "i" : "I", "assets/data/i.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "o" : "O", "assets/data/o.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "p" : "P", "assets/data/p.jpg"),
              ],
            ),
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildContainer(
                    isCapitalLatter == false ? "a" : "A", "assets/data/a.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "s" : "S", "assets/data/s.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "d" : "D", "assets/data/d.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "f" : "F", "assets/data/f.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "g" : "G", "assets/data/g.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "h" : "H", "assets/data/h.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "j" : "J", "assets/data/j.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "k" : "K", "assets/data/k.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "l" : "L", "assets/data/l.jpg"),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    height: 80,
                    width: 70,
                    child: Material(
                      elevation: 20.0,
                      color:
                          isCapitalLatter == false ? Colors.white : Colors.blue,
                      child: InkWell(
                        splashColor: isCapitalLatter == false
                            ? Colors.grey
                            : Colors.blue,
                        onTap: () {
                          setState(() {
                            isCapitalLatter =
                                isCapitalLatter == false ? true : false;
                          });
                        },
                        child: Icon(Icons.text_rotate_up),
                      ),
                    )),
                buildContainer(
                    isCapitalLatter == false ? "z" : "Z", "assets/data/z.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "x" : "X", "assets/data/x.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "c" : "C", "assets/data/c.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "v" : "V", "assets/data/v.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "b" : "B", "assets/data/b.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "n" : "N", "assets/data/n.jpg"),
                buildContainer(
                    isCapitalLatter == false ? "m" : "M", "assets/data/m.jpg"),
                Container(
                    height: 80,
                    width: 70,
                    color: Colors.white,
                    child: Material(
                      elevation: 20.0,
                      child: InkWell(
                        splashColor: Colors.grey[200],
                        onLongPress: () {
                          widget.onLongPressed();
                        },
                        onTap: () {
                          widget.onBackPress();
                        },
                        child: Icon(Icons.backspace),
                      ),
                    )),
              ],
            ),
          ),
          FittedBox(
            child: Row(
              children: <Widget>[
                Container(
                    height: 80,
                    width: 70,
                    color: Colors.white,
                    child: Material(
                      elevation: 20.0,
                      child: InkWell(
                        splashColor: Colors.grey[200],
                        onLongPress: () {
                          widget.onLongPressed();
                        },
                        onTap: () {
                          widget.onBackPress();
                        },
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            "?123",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )),
                buildContainerNumberButton(','),
                Container(
                    height: 80,
                    width: 300,
                    child: RaisedButton(
                      onPressed: () {
                        widget.onSpace();
                      },
                      child: Text(""),
                    )),
                buildContainerNumberButton("."),
                Container(
                    height: 80,
                    width: 50,
                    color: Colors.white,
                    child: Material(
                      elevation: 20.0,
                      child: InkWell(
                        splashColor: Colors.grey,
                        onTap: () {
                          widget.onSend();
                        },
                        child: Icon(Icons.subdirectory_arrow_left),
                      ),
                    )),
              ],
            ),
          ),
        ],
      );

  Widget buildContainerNumberButton(String name) {
    return Material(
      elevation: 20.0,
      child: InkWell(
        hoverColor: Colors.blueGrey,
        splashColor: Colors.grey,
        onTap: () {
          widget.onSave(name);
        },
        child: Container(
            margin: EdgeInsets.all(2),
            height: 80,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: FittedBox(
              child: Text(
                name,
                textAlign: TextAlign.center,
              ),
            )),
      ),
    );
  }

  Widget buildContainer(String name, String iconImage) {
    return Material(
      elevation: 20.0,
      child: InkWell(
        hoverColor: Colors.blueGrey,
        splashColor: Colors.grey,
        onTap: () {
          widget.onSave(name);
        },
        child: Container(
            margin: EdgeInsets.all(2),
            height: 80,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 40,
                      child: Image.asset(
                        iconImage,
                      )),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
