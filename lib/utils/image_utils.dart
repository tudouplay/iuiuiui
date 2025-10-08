import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildNetworkImage(String? url, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  if (url == null || url.isEmpty) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.movie, color: Colors.grey[500]),
    );
  }
  
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
    placeholder: (context, url) => Container(
      color: Colors.grey[300],
      child: Center(child: CircularProgressIndicator()),
    ),
    errorWidget: (context, url, error) => Container(
      color: Colors.grey[300],
      child: Icon(Icons.error, color: Colors.grey[500]),
    ),
  );
}