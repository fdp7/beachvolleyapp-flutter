import 'package:beachvolley_flutter/sideBarItem.dart';
import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/utils/globals.dart' as globals;

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
          child: Column(
            children: [
              headerWidget(),
              SideBarItem(
                  name: 'basket',
                  icon: Icons.sports_basketball_rounded,
                  onPressed: ()=> onSportSelected(context, 'basket')
              ),
              SideBarItem(
                  name: 'beachvolley',
                  icon: Icons.sports_volleyball_rounded,
                  onPressed: ()=> onSportSelected(context, 'beachvolley')
              ),
              const SizedBox(height: 30,),
              const Divider(thickness: 1, height: 10, color: Colors.grey,),
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

  /// summary: set global variable SelectedSport to selected item
  onSportSelected(BuildContext context, String name){
    globals.selectedSport = name;
    Navigator.pop(context);
  }

  /// TODO: implement method
  logOut(BuildContext context){
    Navigator.pop(context);
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
          children: const [
            Text('User name', style: TextStyle(fontSize: 14, color: Colors.white),)
          ],
        )
      ],
    );
  }
}
