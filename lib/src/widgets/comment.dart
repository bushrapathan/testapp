import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemid;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  //Constructor
  Comment({this.itemid, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    //Look for comment,wait to resolve and show appropriate text
    return FutureBuilder(
        future: itemMap[itemid],
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }

          final item = snapshot.data;

          final children = <Widget>[
            ListTile(
              title: buildText(item), //Comment Text
              subtitle: item.by == "" //It checks if comment is deleted
                  ? Text(
                      "Deleted") //and displays deleted text if comment has been deleted
                  : Text(item
                      .by), //and displays author of comment if comment is not deleted
              contentPadding: EdgeInsets.only(
                  right: 16.0,
                  left: depth *
                      16.0), //To give left side indentation to second level comments
            ),
            Divider(),
          ];
          //Creates nested comments
          item.kids.forEach((kidId) {
            children.add(
              Comment(
                itemid: kidId,
                itemMap: itemMap,
                depth: depth + 1, //It is used for indentation of comments
              ),
            );
          });
          return Column(
            children: children,
          );
        });
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>',
            ''); //Replacing placeholder characters as text displayed is html text
    return Text(text);
  }
}
