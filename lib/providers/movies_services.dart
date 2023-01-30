/// Documentation: // Documentation: https://developers.themoviedb.org/3/getting-started/introduction
/// Account: https://www.themoviedb.org/u/EricRan90

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_research/helpers/debouncer.dart';

import '../models/_export_models.dart';

class MoviesServices extends ChangeNotifier {
  // Variables constantes/finales
  final String _apiKey = '193ed781e381a6130940917fad80323b';
  final String _baseURL = 'api.themoviedb.org';
  final String _language = 'es-ES';
  // final String _language = Platform.localeName;

  // Listas
  List<Movie> onMoviePlaying = [];
  List<Movie> onMoviePopular = [];

  // Variables privadas
  int _pagePopular = 0;
  int _maxPagePopular = 10;
  Map<int, List<Cast>> moviesCast = {};

  // Stream
  final debouncer = Debouncer(duration: const Duration(microseconds: 500));
  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionsStreamController.stream;

  MoviesServices() {
    getNowPlaying();
    getPopular();
  }

  Future<String> _getJsonData(String path, [int page = 1]) async {
    // This example uses the Google Books API to search for books about http.
    final url = Uri.https(_baseURL, path, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  Future<String> _getJsonDataParams(
      String path, Map<String, dynamic> queryParams) async {
    // This example uses the Google Books API to search for books about http.
    final url = Uri.https(_baseURL, path, queryParams);

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getNowPlaying() async {
    const path = '/3/movie/now_playing';
    final jsonData = await _getJsonData(path);
    final NowPlayingResponse nowPlayingResponse =
        NowPlayingResponse.fromJson(jsonData);
    onMoviePlaying = [...nowPlayingResponse.results];
    notifyListeners(); // Notifica a todos los listeners
  }

  getPopular() async {
    if (_pagePopular + 1 >= _maxPagePopular) return;

    _pagePopular++;
    const path = '/3/movie/popular';
    final jsonData = await _getJsonData(path, _pagePopular);
    final PopularResponse popularResponse = PopularResponse.fromJson(jsonData);
    _maxPagePopular = popularResponse.totalPages;
    onMoviePopular = [...onMoviePopular, ...popularResponse.results];
    notifyListeners(); // Notifica a todos los listeners
  }

  getMovieDetails(int movieId) async {
    final path = '/3/movie/$movieId';
    final jsonData = await _getJsonData(path);
    final MovieDetailResponse movieDetail =
        MovieDetailResponse.fromJson(jsonData);
    return movieDetail;
    // return movieDetails.toJson();
    // notifyListeners(); // Notifica a todos los listeners
  }

  Future<List<Cast>> getCredits(int movieId) async {
    // Valido si se encuentra en memoria
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final path = '/3/movie/$movieId/credits';
    final jsonData = await _getJsonData(path);
    final CreditsResponse creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast; // Se guarda en memoria
    return creditsResponse.cast;
  }

  Future<List<Movie>> getSearchMovie(String query) async {
    const path = '/3/search/movie';
    final Map<String, dynamic> params = {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
      'include_adult': 'true'
    };

    final jsonData = await _getJsonDataParams(path, params);
    final searchMovieResponse = SearchMovieResponse.fromJson(jsonData);
    return searchMovieResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      if (value == '') return;
      final results = await getSearchMovie(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 302))
        .then((_) => timer.cancel());
  }
}
