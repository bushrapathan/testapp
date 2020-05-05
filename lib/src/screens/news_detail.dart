import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/widgets/comment.dart';
import '../models/item_model.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  //Constructor
  NewsDetail({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
        stream: bloc.itemWithComments,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          }

          final itemFuture = snapshot.data[itemId];

          return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return Text('Loading');
              }
              return buildList(itemSnapshot.data, snapshot.data);
            },
          );
        });
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    final commentList = item.kids.map((kidId) {
      return Comment(
        itemid: kidId,
        itemMap: itemMap,
        depth: 1,//1 represents top level comment//2,3...will be second level comments which gets create in comment.dart file
      );
    }).toList();

    children.addAll(commentList);
    return ListView(
      children: children,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
