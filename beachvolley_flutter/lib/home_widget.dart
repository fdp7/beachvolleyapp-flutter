import 'package:beachvolley_flutter/addMatch_widget.dart';
import 'package:beachvolley_flutter/login_widget.dart';
import 'package:beachvolley_flutter/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/league_widget.dart';
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
      const League(),
      PlayerPage()
    ];
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      backgroundColor: const Color(0xFFEBEBEA),
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
            backgroundColor: const Color(0xFFd81159),
            child: const Icon(Icons.add),
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.people
        ],
        splashColor: const Color(0xFFd81159),
        activeColor: const Color(0xFFd81159),
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.sharpEdge,
        notchAndCornersAnimation: animation,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        splashSpeedInMilliseconds: 400,
        notchMargin: 8,
        onTap: onTapped
      ),
    );
  }

  void addGame() {
    _animationController.reset();
    showCupertinoModalPopup(
        context: context,
        builder: (_) => SizedBox(
          height: 750,
          child: Scaffold(body:AddMatch()),
        )
    );
    _animationController.forward();
  }
}

