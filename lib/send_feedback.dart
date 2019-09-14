import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(HomeWidget());

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Event Feedback'),
        ),
        body: FeedbackWidget(),
      ),
    );
  }
}

class FeedbackWidget extends StatefulWidget {
  @override
  _FeedbackWidgetState createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {

  var _feedbackKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _feedbackKey,
          child: Column(
            children: <Widget>[
              formTextField('Enter your name', 'Name',
                  'Please enter your name', _nameController),
              formTextField('Enter your email', 'Email',
                  'Please enter your email', _emailController),
              formTextField('Enter your age', 'Age',
                  'Please enter your age', _ageController),
              formTextField('Enter feedback', 'Feedback',
                  'Please enter the feedback', _feedbackController),

              RaisedButton(
                onPressed: () {
                  print(_nameController.text);

                  Map<String, dynamic> feedbackMap = Map();
                  feedbackMap['name'] = _nameController.text;
                  feedbackMap['email'] = _emailController.text;
                  feedbackMap['age'] = _ageController.text;
                  feedbackMap['feedback'] = _feedbackController.text;

                  sendToFirebase(feedbackMap);

                  setState(() {
                    _nameController.clear();
                    _emailController.clear();
                    _ageController.clear();
                    _feedbackController.clear();
                  });
                },
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget formTextField(String label, String hint, String errorMsg,
      TextEditingController textEditingController) {

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder()
        ),
        validator: (value) {
          if (value.isEmpty) {
            return errorMsg;
          }
          return null;
        },
        controller: textEditingController,
      ),
    );
  }

  Future sendToFirebase(Map<String, dynamic> data) async {
    await Firestore.instance.collection('feedback').add(data).then((DocumentReference snapshot){
      print(snapshot.toString());
    });
  }
}