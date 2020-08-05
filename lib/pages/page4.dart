import 'package:assessment/pages/page1.dart';
import 'package:assessment/pages/page2.dart';
import 'package:assessment/pages/page3.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

import '../main.dart';
import '../main.dart';
class Page4 extends StatefulWidget {
  Page4({Key key}) : super(key: key);

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> with SingleTickerProviderStateMixin{
  int pageIndex = 1;
  TabController tabController;

  Widget getTabBar() {
  return TabBar(
    controller: tabController,
    tabs: [
    Tab(text: "", icon: Icon(Icons.chat)),
    Tab(text: "", icon: Icon(Icons.camera)),
    Tab(text: "", icon: Icon(Icons.home)),
  ]);
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
        Center(child: Text("Screen 4")),
        Page3()
      ],
    );
  }

  void pageChanged(int index) {
    pageIndex = index;
    tabController.index = index;
    pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }
  @override
  void initState() {
    super.initState();
     tabController = TabController(vsync: this, length: 3);
     tabController.index = pageIndex;

  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
          child: Scaffold(
         appBar: AppBar(
           leading: Container(),
           flexibleSpace: SafeArea(
            child: getTabBar(),
          ),
         ),
         body: SwipeDetector(child: buildPageView(),
         onSwipeDown: () {
           if(pageIndex == 1)
           {
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
           }
          },
         ),
      ),
    );
  }
}