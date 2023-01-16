import 'package:beachvolley_flutter/addGame_widget.dart';
import 'package:beachvolley_flutter/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/ranking_widget.dart';
import 'package:flutter/services.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  int _currentIndex = 0;

  List<Widget> _children = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void onTapped(int index){
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void initState() {
    super.initState();
    _children = [
      //LoginPage(),
      Container(color: Colors.deepPurple.shade500),
      Ranking(),
    ];
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.ease,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      const Duration(seconds: 1),
          () => _animationController.forward(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark
        )
    );

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      backgroundColor: Colors.blueGrey.shade50,
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          allowImplicitScrolling: false,
          onPageChanged: onTapped,
          controller: _pageController,
          children: _children
      ),
      floatingActionButton: ScaleTransition(
          scale: animation,
          child: FloatingActionButton(
              onPressed: addGame,
              child: Icon(Icons.add),
            backgroundColor: Colors.tealAccent.shade400,
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.people
        ],
        splashColor: Colors.green.shade400,
        activeColor: Colors.tealAccent.shade400,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        notchAndCornersAnimation: animation,
        leftCornerRadius: 16,
        rightCornerRadius: 16,
        splashSpeedInMilliseconds: 400,
        onTap: onTapped
      ),
    );
  }

  void addGame() {
    _animationController.reset();
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 750,
          child: Scaffold(body:AddGame()),
        )
    );
    _animationController.forward();
  }
}

