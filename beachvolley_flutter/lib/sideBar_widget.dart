import 'package:beachvolley_flutter/home_widget.dart';
import 'package:beachvolley_flutter/login_widget.dart';
import 'package:beachvolley_flutter/sideBarItem.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:beachvolley_flutter/utils/globals.dart' as globals;

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  static var jwtManager = JwtManager();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color(0xFFd81159),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
          child: Column(
            children: [
              headerWidget(),
              const SizedBox(height: 0,),
              const Divider(thickness: 1, height: 10, color: Colors.white,),
              const SizedBox(height: 30,),
              SideBarItem(
                  name: globals.basketEndpoint,
                  icon: Icons.sports_basketball_rounded,
                  onPressed: ()=> onSportSelected(context, globals.basketEndpoint)
              ),
              SideBarItem(
                  name: globals.beachvolleyEndpoint,
                  icon: Icons.sports_volleyball_rounded,
                  onPressed: ()=> onSportSelected(context, globals.beachvolleyEndpoint)
              ),
              SideBarItem(
                  name: globals.poolEndpoint,
                  icon: const IconData(0xe9b5, fontFamily: "RPGAwesome"),
                  onPressed: ()=> onSportSelected(context, globals.poolEndpoint)
              ),
              const SizedBox(height: 30,),
              const Divider(thickness: 1, height: 10, color: Colors.white,),
              SideBarItem(
                  name: 'Log Out',
                  icon: Icons.logout,
                  onPressed: ()=> logOut(context)
              ),
              const SizedBox(height: 300,),
              RichText(
                text: const TextSpan(
                  text: "Friends & Foes",
                  style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: "Gaoel"),
                  children: [
                    TextSpan(
                      text: "         ",
                    ),
                    TextSpan(
                        text: "FDP7",
                        style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: "Gaoel")
                    )
                  ]
                ),
                textAlign: TextAlign.justify,
              )
            ],
          ),
        )
      ),
    );
  }

  /// summary: set global variable SelectedSport to selected item; go back to home with refreshed data
  onSportSelected(BuildContext context, String name){
    globals.selectedSport = name;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Home()));
  }

  logOut(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  /// Summary: retrieve user name
  Widget headerWidget(){
    jwtManager.init();
    String? loggedUser = jwtManager.name;
    loggedUser ??= ''; //if null, then ''; instead of nullsafety error

    return Row(
      children: [
        const SizedBox(height: 50,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:[
                Text(loggedUser, style: const TextStyle(fontSize: 20, color: Colors.white),)
              ]
            )
          ],
        )
      ],
    );
  }
}
