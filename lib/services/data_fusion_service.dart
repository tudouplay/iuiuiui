import '../models/movie_model.dart';
import 'tmdb_service.dart';
import 'resource_service.dart';

class DataFusionService {
  final TMDbService _tmdbService = TMDbService();
  final ResourceService _resourceService = ResourceService();
  
  Future<List<Movie>> fusedSearch(String query, {int page = 1}) async {
    try {
      final tmdbResults = await _tmdbService.searchMovies(query, page: page);
      final resourceResults = await _resourceService.searchMovies(query, page: page);
      
      final fusedMovies = await _fuseMovieData(tmdbResults, resourceResults);
      
      return fusedMovies;
    } catch (e) {
      print('融合搜索失败，使用资源站数据: $e');
      return await _resourceService.searchMovies(query, page: page);
    }
  }
  
  Future<Movie> getFusedMovieDetail(Movie resourceMovie) async {
    try {
      final tmdbResults = await _tmdbService.searchMovies(resourceMovie.title);
      
      if (tmdbResults.isNotEmpty) {
        final tmdbMovie = tmdbResults.first;
        final tmdbDetail = await _tmdbService.getMovieDetails(tmdbMovie.id);
        
        if (tmdbDetail != null) {
          return _createFusedMovie(resourceMovie, tmdbDetail);
        }
      }
    } catch (e) {
      print('TMDb数据融合失败: $e');
    }
    
    return _resourceService.getMovieDetail(resourceMovie);
  }
  
  Future<List<Movie>> getFusedPopularMovies({int page = 1}) async {
    try {
      final tmdbMovies = await _tmdbService.getPopularMovies(page: page);
      return await _enhanceWithResourceData(tmdbMovies);
    } catch (e) {
      print('获取融合热门电影失败: $e');
      return _resourceService.getHomeMovies(page: page);
    }
  }
  
  Future<List<Movie>> _enhanceWithResourceData(List<TMDbMovie> tmdbMovies) async {
    final List<Movie> enhancedMovies = [];
    
    for (final tmdbMovie in tmdbMovies) {
      try {
        final resourceMovies = await _resourceService.searchMovies(tmdbMovie.title);
        
        if (resourceMovies.isNotEmpty) {
          final resourceMovie = resourceMovies.first;
          final fusedMovie = _createFusedMovie(resourceMovie, tmdbMovie);
          enhancedMovies.add(fusedMovie);
        } else {
          enhancedMovies.add(_createMovieFromTMDb(tmdbMovie));
        }
      } catch (e) {
        print('增强电影数据失败 ${tmdbMovie.title}: $e');
        enhancedMovies.add(_createMovieFromTMDb(tmdbMovie));
      }
    }
    
    return enhancedMovies;
  }
  
  Future<List<Movie>> _fuseMovieData(List<TMDbMovie> tmdbMovies, List<Movie> resourceMovies) async {
    final Map<String, Movie> fusedMap = {};
    
    for (final resourceMovie in resourceMovies) {
      fusedMap[resourceMovie.vodId] = resourceMovie;
    }
    
    for (final tmdbMovie in tmdbMovies) {
      bool matched = false;
      
      for (final resourceMovie in resourceMovies) {
        if (_isMovieMatch(tmdbMovie, resourceMovie)) {
          fusedMap[resourceMovie.vodId] = _createFusedMovie(resourceMovie, tmdbMovie);
          matched = true;
          break;
        }
      }
      
      if (!matched) {
        final movieId = 'tmdb_${tmdbMovie.id}';
        fusedMap[movieId] = _createMovieFromTMDb(tmdbMovie);
      }
    }
    
    return fusedMap.values.toList();
  }
  
  bool _isMovieMatch(TMDbMovie tmdbMovie, Movie resourceMovie) {
    final titleMatch = resourceMovie.title.contains(tmdbMovie.title) || 
                      tmdbMovie.title.contains(resourceMovie.title);
    
    if (!titleMatch) return false;
    
    if (tmdbMovie.releaseDate != null && resourceMovie.year != null) {
      final tmdbYear = tmdbMovie.releaseDate!.year.toString();
      return resourceMovie.year == tmdbYear;
    }
    
    return true;
  }
  
  Movie _createMovieFromTMDb(TMDbMovie tmdbMovie) {
    return Movie(
      vodId: 'tmdb_${tmdbMovie.id}',
      title: tmdbMovie.title,
      overview: tmdbMovie.overview,
      posterPath: tmdbMovie.posterPath,
      backdropPath: tmdbMovie.backdropPath,
      rating: tmdbMovie.voteAverage,
      year: tmdbMovie.releaseDate?.year.toString(),
      category: tmdbMovie.genres?.map((g) => g.name).join(', '),
    );
  }
  
  Movie _createFusedMovie(Movie resourceMovie, TMDbMovie tmdbMovie) {
    return Movie(
      id: resourceMovie.id,
      vodId: resourceMovie.vodId,
      title: resourceMovie.title,
      subTitle: resourceMovie.subTitle,
      overview: tmdbMovie.overview ?? resourceMovie.overview,
      posterPath: tmdbMovie.posterPath ?? resourceMovie.posterPath,
      backdropPath: tmdbMovie.backdropPath ?? resourceMovie.backdropPath,
      rating: tmdbMovie.voteAverage,
      year: resourceMovie.year ?? tmdbMovie.releaseDate?.year.toString(),
      area: resourceMovie.area,
      director: resourceMovie.director,
      actor: resourceMovie.actor,
      category: resourceMovie.category ?? tmdbMovie.genres?.map((g) => g.name).join(', '),
      language: resourceMovie.language,
      updateTime: resourceMovie.updateTime,
      sources: resourceMovie.sources,
      episodes: resourceMovie.episodes,
    );
  }
}