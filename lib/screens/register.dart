import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/screens/home.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
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

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), ((route) => false));
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
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Name',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black))),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? 'Required at leasst 6 char' : null,
              controller: emailController,
              decoration: kinputDecoration('email'),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) => value!.isEmpty ? 'invalid address' : null,
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: 'password',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black))),
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) => value != passwordController.text
                  ? 'confirm password ga matching'
                  : null,
              controller: passwordConfirmController,
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black))),
            ),
            SizedBox(height: 10),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ktextButton('Register', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _registerUser();
                      });
                    }
                  }),
            SizedBox(height: 10),
            kLoginRegisterHint('Don\'t have an account?', 'Login', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  ((route) => false));
            })
          ],
        ),
      ),
    );
    ;
  }
}
