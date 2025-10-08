import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/data_fusion_service.dart';

class MovieProvider with ChangeNotifier {
  final DataFusionService _dataFusionService = DataFusionService();
  
  List<Movie> _movies = [];
  List<Movie> _searchResults = [];
  List<Movie> _popularMovies = [];
  Movie? _currentMovie;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  
  List<Movie> get movies => _movies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get popularMovies => _popularMovies;
  Movie? get currentMovie => _currentMovie;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> loadHomeMovies({int page = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _movies = await _dataFusionService.getFusedPopularMovies(page: page);
    } catch (e) {
      _error = '加载失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query, {int page = 1}) async {
    _isLoading = true;
    _error = null;
    _searchQuery = query;
    notifyListeners();
    
    try {
      _searchResults = await _dataFusionService.fusedSearch(query, page: page);
    } catch (e) {
      _error = '搜索失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMovieDetail(Movie movie) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentMovie = await _dataFusionService.getFusedMovieDetail(movie);
    } catch (e) {
      _error = '加载详情失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPopularMovies({int page = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _popularMovies = await _dataFusionService.getFusedPopularMovies(page: page);
    } catch (e) {
      _error = '加载热门电影失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults.clear();
    _searchQuery = '';
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}