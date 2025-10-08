import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_widget.dart';
import 'movie_detail_screen.dart';

class HomeTabScreen extends StatefulWidget {
  final String tabType;
  
  const HomeTabScreen({Key? key, required this.tabType}) : super(key: key);

  @override
  _HomeTabScreenState createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_scrollListener);
  }

  void _loadMovies() {
    final provider = Provider.of<MovieProvider>(context, listen: false);
    
    switch (widget.tabType) {
      case 'popular':
        provider.loadPopularMovies(page: _currentPage);
        break;
      case 'home':
      default:
        provider.loadHomeMovies(page: _currentPage);
        break;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    _currentPage++;
    _loadMovies();
  }

  List<Movie> _getMovieList(MovieProvider provider) {
    switch (widget.tabType) {
      case 'popular':
        return provider.popularMovies;
      case 'home':
      default:
        return provider.movies;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        final movieList = _getMovieList(provider);
        
        if (provider.isLoading && movieList.isEmpty) {
          return LoadingWidget(message: '加载中...');
        }

        if (provider.error != null && movieList.isEmpty) {
          return ErrorWidget(
            message: provider.error!,
            onRetry: _loadMovies,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _currentPage = 1;
            _loadMovies();
          },
          child: GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: movieList.length + (provider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == movieList.length) {
                return LoadingWidget();
              }
              
              final movie = movieList[index];
              return MovieCard(
                movie: movie,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}