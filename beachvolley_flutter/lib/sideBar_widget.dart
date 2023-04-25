import 'package:beachvolley_flutter/home_widget.dart';
import 'package:beachvolley_flutter/login_widget.dart';
import 'package:beachvolley_flutter/sideBarItem.dart';
import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/utils/globals.dart' as globals;

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color(0xFFd81159),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
          child: Column(
            children: [
              //headerWidget(),
              const SizedBox(height: 30,),
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
              const SizedBox(height: 30,),
              const Divider(thickness: 1, height: 10, color: Colors.white,),
              SideBarItem(
                  name: 'log out',
                  icon: Icons.logout,
                  onPressed: ()=> logOut(context)
              ),
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

  Widget headerWidget(){

    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        const SizedBox(width: 40,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User name', style: TextStyle(fontSize: 14, color: Colors.white),)
          ],
        )
      ],
    );
  }
}
