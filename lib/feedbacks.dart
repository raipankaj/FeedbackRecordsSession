import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Feedbacks"),
        ),
        body: FeedbackListWidget(),
      ),
    );
  }
}

class FeedbackListWidget extends StatefulWidget {
  @override
  _FeedbackListWidgetState createState() => _FeedbackListWidgetState();
}

class _FeedbackListWidgetState extends State<FeedbackListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('feedback').snapshots(),
        builder: (BuildContext buildContext,
            AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }

          switch(snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: Text("Waiting"));

            default:
              return ListView(
                children: snapshot.data.documents.map(
                        (document) {
                  return Text(document.data['feedback']);
                }).toList(),
              );
          }
        },
      ),
    );
  }
}

