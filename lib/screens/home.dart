import 'package:blog_app/screens/login.dart';
import 'package:blog_app/screens/post_form.dart';
import 'package:blog_app/screens/post_screen.dart';
import 'package:blog_app/screens/profile.dart';
import 'package:blog_app/services/user_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  Widget header() {
    return AppBar(
      title: Text('Blog App'),
      actions: [
        IconButton(
            onPressed: () {
              logout().then((value) => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false)
                  });
            },
            icon: Icon(Icons.exit_to_app))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: header(),
        preferredSize: Size.fromHeight(70),
      ),
      body: currentIndex == 0 ? PostScreen() : ProfileScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PostForm(
                title: 'add new post',
              )));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile')
          ],
        ),
      ),
    );
  }
}
