import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>(); //StreamController
  final _itemsOutput = BehaviorSubject<
      Map<int, Future<ItemModel>>>(); //StreamController that everyone listen to
  final _itemsFetcher = PublishSubject<
      int>(); //StreamController in which input data is going to be pumped

  //Getters to stream
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //Getters to sink
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  //Constuctor
  StoriesBloc() {
    //Pipe() takes source i.e in this case every output event of the stream obtained from  _itemsFetcher.transform()
    //and automatically forwards it to target destination i.e. _itemsOutput
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

  _itemsTransformer() {
    //Takes the id,fetches appropriate item
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
