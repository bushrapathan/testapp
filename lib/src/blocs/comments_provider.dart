import 'package:flutter/material.dart';
import 'comments_bloc.dart';
export 'comments_bloc.dart';

class CommentsProvider extends InheritedWidget{
  final CommentsBloc bloc;
  //Named Parameter Constructor
  CommentsProvider({Key key,Widget child})
    :bloc = CommentsBloc(),//Initializing bloc instance inside constructor
    super(key:key,child:child);

  @override
  bool updateShouldNotify(_)=>true;

  static CommentsBloc of(BuildContext context){
    //return (context.inheritFromWidgetOfExactType(CommentsProvider) as CommentsProvider).bloc;//depricated
    return (context.dependOnInheritedWidgetOfExactType() as CommentsProvider).bloc;
  }
  
}