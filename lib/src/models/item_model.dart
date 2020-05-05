import 'dart:convert';

class ItemModel{
  final int id;
  final bool deleted;
  final String type;
  final String by;//Author of comment
  final int time;
  final String text;//Commment Text
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;//Indicates votes for story
  final String title;//Indicates title of story
  final int descendants;//Represents number of comments

  //Take parsedJson from API and put it into model
  ItemModel.fromJson(Map<String,dynamic> parsedJson)
    :id =parsedJson['id'],
    deleted =parsedJson['deleted'] ?? false,//null check//If deleted is null then set default value as false
    type =parsedJson['type'],
    by =parsedJson['by'] ?? '',//null check//If by is null then set default value as empty string
    time =parsedJson['time'],
    text =parsedJson['text']?? '',//null check//If text is null then set default value as empty string
    dead =parsedJson['dead']?? false,//null check//If dead is null then set default value as false
    parent =parsedJson['parent'],
    kids =parsedJson['kids']?? [],//null check//If kids is null then set default value as empty list
    url =parsedJson['url'],
    score =parsedJson['score'],
    title =parsedJson['title'],
    descendants =parsedJson['descendants'] ?? 0;//null check//If descendants is null then set default value as 0

    
    ItemModel.fromDb(Map<String,dynamic> parsedJson)
    :id =parsedJson['id'],
    //While dealing with sqlitedb we can't mention type as bool instead we have used integer 
    //where 0=false and 1=true
    //so if parsedJson['deleted']=1 then 1==1 will true,
    //if parsedJson['deleted']=0 then 0==1 will return false
    deleted =parsedJson['deleted'] ==1,
    type =parsedJson['type'],
    by =parsedJson['by'],
    time =parsedJson['time'],
    text =parsedJson['text'],
    dead =parsedJson['dead'] ==1,
    parent =parsedJson['parent'],
    //kids is actually list but while dealing with db we have used blob as list is not available
    kids =jsonDecode(parsedJson['kids']),
    url =parsedJson['url'],
    score =parsedJson['score'],
    title =parsedJson['title'],
    descendants =parsedJson['descendants'];

    //Turning class instances to map
    Map<String,dynamic> tomap(){
      return <String,dynamic> {
        "id":id,
        "deleted":deleted ?1:0,
        "type":type,
        "by":by,
        "time":time,
        "text":text,
        "dead":dead ? 1: 0,
        "parent":parent,
        "kids":kids,
        "url":url,
        "score":score,
        "title":title,
        "descendants":descendants,
      };
    }
}