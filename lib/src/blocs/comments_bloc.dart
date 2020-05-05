import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>(); //StreamController
  final _commentsOutput =
      BehaviorSubject<Map<int, Future<ItemModel>>>(); //StreamController
  
  //Getters to stream
  Observable<Map<int, Future<ItemModel>>> get itemWithComments => _commentsOutput.stream;

  //Getters to sink
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  //Constructor
  CommentsBloc(){
    //Pipe() takes source i.e in this case every output event of the stream obtained from  _commentsFetcher.transform()
    //and automatically forwards it to target destination i.e. _commentsOutput
    _commentsFetcher.stream.transform(_commentsTransformer()).pipe(_commentsOutput);
  }

  _commentsTransformer(){
     //Takes the id and fetches comments recursively
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _) {
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item){
          item.kids.forEach((kidId)=>fetchItemWithComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }


  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
