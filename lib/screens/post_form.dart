import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../services/user_services.dart';

class PostForm extends StatefulWidget {
  // const PostForm({Key? key}) : super(key: key);

  final Post? post;
  final String? title;
  PostForm({this.post, this.title});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerBody.text, image);

    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _editPost(int postId) async {
    ApiResponse response = await editPosts(postId, _txtControllerBody.text);
    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      _txtControllerBody.text = widget.post!.body ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(children: [
              widget.post != null
                  ? SizedBox()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          image: _imageFile == null
                              ? null
                              : DecorationImage(
                                  image: FileImage(_imageFile ?? File('')),
                                  fit: BoxFit.cover)),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                    ),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                        controller: _txtControllerBody,
                        keyboardType: TextInputType.multiline,
                        maxLines: 9,
                        decoration: InputDecoration(
                            hintText: 'Post body ....',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.black38))),
                        validator: ((value) =>
                            value!.isEmpty ? 'Post body is required' : null)),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: ktextButton(widget.post != null ? 'Edit' : 'Post', () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _loading = !_loading;
                    });
                    if (widget.post == null) {
                      _createPost();
                    } else {
                      _editPost(widget.post!.id ?? 0);
                    }
                  }
                }),
              )
            ]),
    );
  }
}
