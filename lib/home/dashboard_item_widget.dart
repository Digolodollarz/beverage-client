import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[Icon(Icons.local_hospital), Text('Clinic')],
      ),
    );
  }
}
