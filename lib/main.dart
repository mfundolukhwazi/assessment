import 'package:assessment/pages/page1.dart';
import 'package:assessment/pages/page3.dart';
import 'package:assessment/pages/page4.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'dart:math' as math;
import 'pages/page2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Assessment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  int selectedIndex = 1;
  Color navColor = Colors.transparent;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.chat),
          title: new Text('')
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.camera),
        title: new Text(''),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('')
      )
    ];
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

   Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (int index){
        pageChanged(index);
      },
      children: <Widget>[
        Page1(),
        Page2(),
        Page3()
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      if(index == 1)
      {
        navColor = Colors.transparent;
      }else
      {
        navColor = Colors.purple;
      }
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SwipeDetector(child: buildPageView(),
        onSwipeUp: () {
            if(selectedIndex ==1)
            {
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => Page4()));
            }
        }),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.chat,color: Colors.white), onPressed: null),
              IconButton(icon: Icon(Icons.home,color: Colors.white), onPressed: null),
            ],
          ),

          notchMargin: 4.0,
          shape: MyShape(),
          color:navColor
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(onPressed:(){},backgroundColor: navColor,elevation: 0,child: Icon(Icons.camera,size: 40,),),
    );
                }
}

class MyShape extends CircularNotchedRectangle{
  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (guest == null || !host.overlaps(guest))
      return Path()..addRect(host);
      final double notchRadius = guest.width / 2.0;

      const double s1 = 8.0;
      const double s2 = 1.0;

      final double r = notchRadius;
      final double a = -1.0 * r - s2;
      final double b = host.top - guest.center.dy;

      final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
      final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
      final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
      final double p2yA = math.sqrt(r * r - p2xA * p2xA);
      final double p2yB = math.sqrt(r * r - p2xB * p2xB);

      final List<Offset> p = List<Offset>(6);

      // p0, p1, and p2 are the control points for segment A.    
      p[0] = Offset(a - s1, b);
      p[1] = Offset(a, b);
      final double cmp = b < 0 ? -1.0 : 1.0;
      p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA,- p2yA) : Offset(p2xB, p2yB);

      // p3, p4, and p5 are the control points for segment B, which is a mirror
      // of segment A around the y axis.
      p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
      p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
      p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

      // translate all points back to the absolute coordinate system.
      for (int i = 0; i < p.length; i += 1)
        p[i] += guest.center;
      return Path()
        ..moveTo(host.left, host.top)
        ..lineTo(p[1].dx, p[1].dy)
        ..arcToPoint(
          p[4],
          radius: Radius.circular(notchRadius),
          clockwise: true,
        )
        ..lineTo(host.right, host.top)
        ..lineTo(host.right, host.bottom)
        ..lineTo(host.left, host.bottom)
        ..close();
    }
}