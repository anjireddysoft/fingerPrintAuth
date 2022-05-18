import 'package:flutter/cupertino.dart';
import 'package:pagination_flutter/models/data_model.dart';

import '../api_service.dart';

enum LoadMoreStatus { LOADING, STABLE }

class DataProvider with ChangeNotifier {
  APIService _apiService;
  List<ItemModel> _dataFetcher;
  int totalPages = 0;
  int pageSize = 15;

  List<ItemModel> get allUsers => _dataFetcher;

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;

  void _initStreams() {
    _apiService = APIService();
    _dataFetcher = [];
  }

  void resetStreams() {
    _initStreams();
  }

  fetchAllUsers(pageNumber) async {
    print("================ pageNumber $pageNumber");
    print("================ totalPages $totalPages");

    List<ItemModel> items = await _apiService.getData(pageNumber);

    if (items.isEmpty) {
      print("there is no data to load");
      setLoadingState(LoadMoreStatus.STABLE);
    }
    if (_dataFetcher == null) {
      _dataFetcher = items;
    } else {
      _dataFetcher.addAll(items);

      // One load more is done will make it status as stable.
      setLoadingState(LoadMoreStatus.LOADING);
    }

    notifyListeners();

    /* if (pageNumber > totalPages) {
      // One load more is done will make it status as stable.
      setLoadingState(LoadMoreStatus.STABLE);
      notifyListeners();
    }*/
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }
}
