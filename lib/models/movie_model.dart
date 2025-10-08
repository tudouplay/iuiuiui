class Movie {
  final int? id;
  final String vodId;
  final String title;
  final String? subTitle;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? rating;
  final String? year;
  final String? area;
  final String? director;
  final String? actor;
  final String? category;
  final String? language;
  final String? updateTime;
  final List<VideoSource>? sources;
  final List<Episode>? episodes;

  Movie({
    this.id,
    required this.vodId,
    required this.title,
    this.subTitle,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.rating,
    this.year,
    this.area,
    this.director,
    this.actor,
    this.category,
    this.language,
    this.updateTime,
    this.sources,
    this.episodes,
  });

  factory Movie.fromResourceJson(Map<String, dynamic> json) {
    return Movie(
      vodId: json['vod_id']?.toString() ?? '',
      title: json['vod_name']?.toString() ?? '',
      subTitle: json['vod_sub']?.toString(),
      overview: json['vod_content']?.toString(),
      posterPath: json['vod_pic']?.toString(),
      backdropPath: json['vod_pic']?.toString(),
      rating: double.tryParse(json['vod_score']?.toString() ?? '0'),
      year: json['vod_year']?.toString(),
      area: json['vod_area']?.toString(),
      director: json['vod_director']?.toString(),
      actor: json['vod_actor']?.toString(),
      category: json['vod_class']?.toString(),
      language: json['vod_lang']?.toString(),
      updateTime: json['vod_time']?.toString(),
    );
  }

  Movie copyWith({
    List<VideoSource>? sources,
    List<Episode>? episodes,
  }) {
    return Movie(
      id: id,
      vodId: vodId,
      title: title,
      subTitle: subTitle,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      rating: rating,
      year: year,
      area: area,
      director: director,
      actor: actor,
      category: category,
      language: language,
      updateTime: updateTime,
      sources: sources ?? this.sources,
      episodes: episodes ?? this.episodes,
    );
  }
}

class VideoSource {
  final String name;
  final String url;
  final String from;

  VideoSource({
    required this.name,
    required this.url,
    required this.from,
  });
}

class Episode {
  final String name;
  final String url;
  final List<VideoSource> sources;

  Episode({
    required this.name,
    required this.url,
    required this.sources,
  });
}

class ResourceResponse {
  final int code;
  final String msg;
  final int page;
  final int pageCount;
  final int limit;
  final int total;
  final List<Movie> list;

  ResourceResponse({
    required this.code,
    required this.msg,
    required this.page,
    required this.pageCount,
    required this.limit,
    required this.total,
    required this.list,
  });

  factory ResourceResponse.fromJson(Map<String, dynamic> json) {
    return ResourceResponse(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      page: json['page'] ?? 1,
      pageCount: json['pagecount'] ?? 1,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      list: (json['list'] as List<dynamic>? ?? [])
          .map((item) => Movie.fromResourceJson(item))
          .toList(),
    );
  }
}