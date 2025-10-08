import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_widget.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        final provider = Provider.of<MovieProvider>(context, listen: false);
        provider.searchMovies(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '搜索电影、电视剧...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              final provider = Provider.of<MovieProvider>(context, listen: false);
              provider.clearSearch();
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.searchQuery.isEmpty) {
            return Center(
              child: Text(
                '输入关键词搜索影视资源',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          if (provider.isLoading) {
            return LoadingWidget(message: '搜索中...');
          }

          if (provider.error != null) {
            return ErrorWidget(
              message: provider.error!,
              onRetry: () => provider.searchMovies(provider.searchQuery),
            );
          }

          if (provider.searchResults.isEmpty) {
            return Center(
              child: Text(
                '没有找到相关结果',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final movie = provider.searchResults[index];
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
          );
        },
      ),
    );
  }
}