import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_website/links.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/prefer_universal/js.dart' as js;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anarghya Das',
      home: MyHomePage('Anarghya Das'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _backgroundColor;

  _MyHomePageState() {
    _backgroundColor = getColorFromCookie();
  }

  Color getColorFromCookie() {
    Color bgColor = Colors.white;
    List<String> cookieValues = html.window.document.cookie.split(";");
    if (cookieValues[0].isNotEmpty) {
      String cookieColorValue = cookieValues[0].split("=")[1];
      bgColor = cookieColorValue == "white" ? Colors.white : Colors.black;
    }
    return bgColor;
  }

  void changeColor() {
    setState(() {
      _backgroundColor = invertColor();
    });
    _storeCookie();
  }

  void _storeCookie() {
    String cookieValue =
        _backgroundColor == Colors.white ? "bgColor=white;" : "bgColor=black;";
    var today = new DateTime.now();
    var cookieExpiry = today.add(new Duration(days: 60));
    String dateFormat =
        DateFormat("E, d MMMM yyyy HH:mm:ss").format(cookieExpiry);
    print(dateFormat);
    cookieValue += "expires=$dateFormat";
    html.window.document.cookie = cookieValue;
  }

  Color invertColor() {
    return _backgroundColor == Colors.white ? Colors.black : Colors.white;
  }

  void openLink(String iconURL) {
    html.window.open(iconURL, '_blank');
  }

  Widget mainLayout(fontSize, imageRadius) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: imageRadius + 4,
            backgroundColor: invertColor(),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/anarghya.jpg"),
              backgroundColor: Colors.transparent,
              radius: imageRadius,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: fontSize,
                    color: invertColor(),
                    fontFamily: 'Gugi'),
              ),
              IconButton(
                iconSize: 15,
                icon: FaIcon(FontAwesomeIcons.volumeUp),
                onPressed: () => js.context.callMethod('playAudio',
                    List.filled(1, '/assets/assets/sounds/anarghya.mp3')),
                color: invertColor(),
              )
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              IconButton(
                icon: FaIcon(FontAwesomeIcons.github),
                onPressed: () {
                  openLink(GITHUB);
                },
                color: invertColor(),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.linkedinIn),
                onPressed: () {
                  openLink(LINKEDIN);
                },
                color: invertColor(),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.dev),
                onPressed: () {
                  openLink(DEVPOST);
                },
                color: invertColor(),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.envelope),
                onPressed: () {
                  openLink(EMAIL);
                },
                color: invertColor(),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.file),
                onPressed: () {
                  openLink(RESUME);
                },
                color: invertColor(),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: _backgroundColor == Colors.black
                ? FaIcon(FontAwesomeIcons.solidSun)
                : FaIcon(FontAwesomeIcons.solidMoon),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: changeColor,
            color: invertColor(),
          )
        ],
      ),
      backgroundColor: _backgroundColor,
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return mainLayout(100, 80);
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return mainLayout(50, 50);
        } else {
          return mainLayout(35, 40);
        }
      }),
    );
  }
}
