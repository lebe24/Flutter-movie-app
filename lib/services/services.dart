import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie_model.dart';
// import 'package:movie_app/secret.dart';

import '../models/credit_model.dart';
import '../models/review_model.dart';

const baseUrl = 'https://api.themoviedb.org/3/';
var key = '?api_key=2b22ab5e2d69c8926e451e306dcf9225';
late String endPoint;

Future<Model> getUpcomingMovies() async {
  endPoint = 'movie/upcoming';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load trending');
  }
}

Future<Model> getTrendingMovies() async {
  endPoint = 'trending/all/day';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load trending');
  }
}

Future<Model> getPopularMovies() async {
  endPoint = 'movie/popular';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load popular');
  }
}

Future<Model> getPopularTvShows() async {
  endPoint = 'tv/popular';
  final url = '$baseUrl$endPoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load popular');
  }
}

Future<Model> getTopRatedMovies() async {
  endPoint = 'movie/top_rated';
  final String url = '$baseUrl$endPoint$key';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load top rated movies');
  }
}

Future<Model> discoverMovies({int? genreId}) async {
  endPoint = 'discover/movie';
  final String url = genreId == null
      ? '$baseUrl$endPoint$key'
      : '$baseUrl$endPoint$key&with_genres=$genreId';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load genres');
  }
}

Future<Credit> getCredits(int id, bool isTvShow) async {
  endPoint = isTvShow ? 'tv/$id/credits' : 'movie/$id/credits';
  final String url = '$baseUrl$endPoint$key';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return creditFromJson(response.body);
  } else {
    throw Exception('failed to load credits');
  }
}

Future<Model> getSimilar(int id, bool isTvShow) async {
  endPoint = isTvShow ? 'tv/$id/similar' : 'movie/$id/similar';
  final String url = '$baseUrl$endPoint$key';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('failed to load similar');
  }
}

Future<Review> getReviews(int id, bool isTvShow) async {
  endPoint = isTvShow ? 'tv/$id/reviews' : 'movie/$id/reviews';
  final String url = '$baseUrl$endPoint$key';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return reviewFromJson(response.body);
  } else {
    throw Exception('failed to load reviews');
  }
}

Future<Model> movieSearch(String query) async {
  endPoint = 'search/movie';
  final url = '$baseUrl$endPoint$key&query=$query';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('not found');
  }
}

Future<Model> searchData(String query) async {
  endPoint = 'search/multi';
  final url = '$baseUrl$endPoint$key&query=$query';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return modelFromJson(response.body);
  } else {
    throw Exception('not found');
  }
}

Future<String?> getYouTubeTrailerId(int movieId) async {
  endPoint = 'movie/$movieId/videos';
  final url = '$baseUrl$endPoint$key&language=en-US';

  try{
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> videosData = json.decode(response.body);
      final trailers = videosData['results'] as List;

      final officialTrailer = trailers.firstWhere(
          (video) => 
            video['site'] == 'YouTube' && 
            video['type'] == 'Trailer',
          orElse: () => null
      );

      final videoResult = officialTrailer ?? 
          trailers.firstWhere(
            (video) => video['site'] == 'YouTube', 
            orElse: () => null
          );

      print(videoResult['key']);
      return videoResult != null ? videoResult['key'] : null;
    }
  }catch(e){
    throw('Error fetching trailer: $e');
  }
  return null;
}
