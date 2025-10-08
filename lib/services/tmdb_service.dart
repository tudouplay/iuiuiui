import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '3f3a99a9456828a1a834f9e89c1b0236';
  static const String _accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzZjNhOTlhOTQ1NjgyOGExYTgzNGY5ZTg5YzFiMDIzNiIsIm5iZiI6MTc1OTkzMjUzOS4wNDQsInN1YiI6IjY4ZTY3MDdiYmJlNWEyNDgxMzc5NTIwOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NFZ1dVPIV3mlsjRsvzcTZtsKBgXuEewgsmHxrFu8Fgk';
  
  static const Map<String, String> _headers = {
    'Authorization': 'Bearer $_accessToken',
    'Content-Type': 'application/json;charset=utf-8',
  };

  Future<List<TMDbMovie>> searchMovies(String query, {int page = 1}) async {
    final url = '$_baseUrl/search/movie?api_key=$_apiKey&query=${Uri.encodeQueryComponent(query)}&page=$page&language=zh-CN';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List<dynamic>;
        
        return results.map((item) => TMDbMovie.fromJson(item)).toList();
      } else {
        throw Exception('TMDb API 错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('搜索电影失败: $e');
    }
  }

  Future<TMDbMovie?> getMovieDetails(int movieId) async {
    final url = '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=zh-CN&append_to_response=credits,videos';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TMDbMovie.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('TMDb API 错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取电影详情失败: $e');
    }
  }

  Future<List<TMDbMovie>> getPopularMovies({int page = 1}) async {
    final url = '$_baseUrl/movie/popular?api_key=$_apiKey&page=$page&language=zh-CN';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List<dynamic>;
        
        return results.map((item) => TMDbMovie.fromJson(item)).toList();
      } else {
        throw Exception('TMDb API 错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取热门电影失败: $e');
    }
  }

  Future<List<TMDbMovie>> getNowPlayingMovies({int page = 1}) async {
    final url = '$_baseUrl/movie/now_playing?api_key=$_apiKey&page=$page&language=zh-CN';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List<dynamic>;
        
        return results.map((item) => TMDbMovie.fromJson(item)).toList();
      } else {
        throw Exception('TMDb API 错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取正在上映电影失败: $e');
    }
  }

  Future<List<TMDbMovie>> getUpcomingMovies({int page = 1}) async {
    final url = '$_baseUrl/movie/upcoming?api_key=$_apiKey&page=$page&language=zh-CN';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List<dynamic>;
        
        return results.map((item) => TMDbMovie.fromJson(item)).toList();
      } else {
        throw Exception('TMDb API 错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取即将上映电影失败: $e');
    }
  }

  Future<List<TMDbMovie>> getMovieRecommendations(int movieId, {int page = 1}) async {
    final url = '$_baseUrl/movie/$movieId/recommendations?api_key=$_apiKey&page=$page&language=zh-CN';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List<dynamic>;
        
        return results.map((item) => TMDbMovie.fromJson(item)).toList();
      } else {
        throw Exception('TMDb API 错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取电影推荐失败: $e');
    }
  }

  Future<List<TMDbTV>> searchTVShows(String query, {int page = 1}) async {
    final url = '$_baseUrl/search/tv?api_key=$_apiKey&query=${Uri.encodeQueryComponent(query)}&page=$page&language=zh-CN';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as List<dynamic>;
        
        return results.map((item) => TMDbTV.fromJson(item)).toList();
      } else {
        throw Exception('TMDb API 错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('搜索电视剧失败: $e');
    }
  }

  Future<TMDbTV?> getTVShowDetails(int tvId) async {
    final url = '$_baseUrl/tv/$tvId?api_key=$_apiKey&language=zh-CN&append_to_response=credits,videos';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TMDbTV.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('TMDb API 错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取电视剧详情失败: $e');
    }
  }
}

class TMDbMovie {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final DateTime? releaseDate;
  final List<Genre>? genres;
  final int? runtime;
  final String? status;
  final String? tagline;
  final List<Person>? cast;
  final List<Person>? crew;
  final List<Video>? videos;

  TMDbMovie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    this.releaseDate,
    this.genres,
    this.runtime,
    this.status,
    this.tagline,
    this.cast,
    this.crew,
    this.videos,
  });

  factory TMDbMovie.fromJson(Map<String, dynamic> json) {
    return TMDbMovie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'] != null 
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}' 
          : null,
      backdropPath: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w780${json['backdrop_path']}'
          : null,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] != null 
          ? DateTime.tryParse(json['release_date']) 
          : null,
      genres: json['genres'] != null
          ? (json['genres'] as List).map((g) => Genre.fromJson(g)).toList()
          : null,
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      cast: json['credits'] != null && json['credits']['cast'] != null
          ? (json['credits']['cast'] as List).map((c) => Person.fromJson(c)).toList()
          : null,
      crew: json['credits'] != null && json['credits']['crew'] != null
          ? (json['credits']['crew'] as List).map((c) => Person.fromJson(c)).toList()
          : null,
      videos: json['videos'] != null && json['videos']['results'] != null
          ? (json['videos']['results'] as List).map((v) => Video.fromJson(v)).toList()
          : null,
    );
  }
}

class TMDbTV {
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final DateTime? firstAirDate;
  final DateTime? lastAirDate;
  final List<Genre>? genres;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final List<Season>? seasons;
  final String? status;
  final String? tagline;
  final List<Person>? cast;
  final List<Person>? crew;
  final List<Video>? videos;

  TMDbTV({
    required this.id,
    required this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    this.firstAirDate,
    this.lastAirDate,
    this.genres,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    this.seasons,
    this.status,
    this.tagline,
    this.cast,
    this.crew,
    this.videos,
  });

  factory TMDbTV.fromJson(Map<String, dynamic> json) {
    return TMDbTV(
      id: json['id'],
      name: json['name'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'] != null 
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}' 
          : null,
      backdropPath: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w780${json['backdrop_path']}'
          : null,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      firstAirDate: json['first_air_date'] != null 
          ? DateTime.tryParse(json['first_air_date']) 
          : null,
      lastAirDate: json['last_air_date'] != null 
          ? DateTime.tryParse(json['last_air_date']) 
          : null,
      genres: json['genres'] != null
          ? (json['genres'] as List).map((g) => Genre.fromJson(g)).toList()
          : null,
      numberOfSeasons: json['number_of_seasons'] ?? 0,
      numberOfEpisodes: json['number_of_episodes'] ?? 0,
      seasons: json['seasons'] != null
          ? (json['seasons'] as List).map((s) => Season.fromJson(s)).toList()
          : null,
      status: json['status'],
      tagline: json['tagline'],
      cast: json['credits'] != null && json['credits']['cast'] != null
          ? (json['credits']['cast'] as List).map((c) => Person.fromJson(c)).toList()
          : null,
      crew: json['credits'] != null && json['credits']['crew'] != null
          ? (json['credits']['crew'] as List).map((c) => Person.fromJson(c)).toList()
          : null,
      videos: json['videos'] != null && json['videos']['results'] != null
          ? (json['videos']['results'] as List).map((v) => Video.fromJson(v)).toList()
          : null,
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class Person {
  final int id;
  final String name;
  final String? character;
  final String? job;
  final String? profilePath;

  Person({
    required this.id,
    required this.name,
    this.character,
    this.job,
    this.profilePath,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'] ?? '',
      character: json['character'],
      job: json['job'],
      profilePath: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w185${json['profile_path']}'
          : null,
    );
  }
}

class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final int size;

  Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.size,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? 0,
    );
  }
}

class Season {
  final int id;
  final String name;
  final String? overview;
  final int seasonNumber;
  final int episodeCount;
  final String? posterPath;
  final DateTime? airDate;

  Season({
    required this.id,
    required this.name,
    this.overview,
    required this.seasonNumber,
    required this.episodeCount,
    this.posterPath,
    this.airDate,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      name: json['name'] ?? '',
      overview: json['overview'],
      seasonNumber: json['season_number'] ?? 0,
      episodeCount: json['episode_count'] ?? 0,
      posterPath: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w185${json['poster_path']}'
          : null,
      airDate: json['air_date'] != null 
          ? DateTime.tryParse(json['air_date']) 
          : null,
    );
  }
}