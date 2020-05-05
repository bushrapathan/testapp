import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: buildContainer(),
        subtitle: buildContainer(),
      ),
      Divider(height: 8.0),
    ]);
  }

  buildContainer() {
    return Container(
      height: 24.0,
      width: 150.0,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      color: Colors.grey[200],
    );
  }
}
