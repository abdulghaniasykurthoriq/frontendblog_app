import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/screens/home.dart';
import 'package:blog_app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user_services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User? user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user?.token ?? '');
    await pref.setInt('userId', user?.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            TextFormField(
              validator: (value) => value!.isEmpty ? 'invalid address' : null,
              controller: txtEmail,
              decoration: InputDecoration(
                  labelText: 'Email',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black))),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? 'Required at leasst 6 char' : null,
              controller: txtPassword,
              obscureText: true,
              decoration: kinputDecoration('Password'),
            ),
            SizedBox(height: 10),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ktextButton('login', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _loginUser();
                      });
                    }
                  }),
            SizedBox(height: 10),
            kLoginRegisterHint('Don\'t have an account?', 'Register', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Register()),
                  ((route) => false));
            })
          ],
        ),
      ),
    );
  }
}
