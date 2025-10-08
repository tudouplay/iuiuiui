import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../utils/image_utils.dart';
import '../widgets/loading_widget.dart';
import 'video_player_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  void _loadDetail() {
    final provider = Provider.of<MovieProvider>(context, listen: false);
    provider.loadMovieDetail(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          final movie = provider.currentMovie ?? widget.movie;
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: buildNetworkImage(
                    movie.backdropPath ?? movie.posterPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (movie.subTitle != null) ...[
                        SizedBox(height: 8),
                        Text(
                          movie.subTitle!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      SizedBox(height: 16),
                      Row(
                        children: [
                          if (movie.rating != null) ...[
                            Icon(Icons.star, color: Colors.amber),
                            SizedBox(width: 4),
                            Text('${movie.rating}'),
                            SizedBox(width: 16),
                          ],
                          if (movie.year != null) ...[
                            Icon(Icons.calendar_today, size: 16),
                            SizedBox(width: 4),
                            Text(movie.year!),
                            SizedBox(width: 16),
                          ],
                          if (movie.area != null) ...[
                            Icon(Icons.location_on, size: 16),
                            SizedBox(width: 4),
                            Text(movie.area!),
                          ],
                        ],
                      ),
                      SizedBox(height: 16),
                      if (movie.overview != null) ...[
                        Text(
                          '剧情简介',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movie.overview!,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      if (movie.director != null) ...[
                        Text('导演: ${movie.director}'),
                        SizedBox(height: 8),
                      ],
                      if (movie.actor != null) ...[
                        Text('主演: ${movie.actor}'),
                        SizedBox(height: 16),
                      ],
                      ElevatedButton(
                        onPressed: () {
                          if (movie.sources != null && movie.sources!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  movie: movie,
                                  sources: movie.sources!,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('暂无播放源')),
                            );
                          }
                        },
                        child: Text('立即播放'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}