import 'package:chen_movie/src/blocs/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/item_model.dart';
import '../../blocs/movie/movies.dart';

import './movie_detail.dart';

class MovieList extends StatefulWidget {
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Popular Movies'), actions: <Widget>[
        BlocProvider(
          bloc: authenticationBloc,
          child: IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              authenticationBloc.dispatch(LoggedOut());
            },
          ),
        )
      ]),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data.results.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: InkResponse(
            enableFeedback: true,
            child: Image.network(
                'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}',
                fit: BoxFit.cover),
            onTap: () => openDetailPage(snapshot.data, index),
          ),
        );
      },
    );
  }

  openDetailPage(ItemModel data, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieDetailBlocProvider(
          child: MovieDetail(
            title: data.results[index].title,
            posterUrl: data.results[index].backdrop_path,
            description: data.results[index].overview,
            releaseDate: data.results[index].release_date,
            voteAverage: data.results[index].vote_average.toString(),
            movieId: data.results[index].id,
          ),
        );
      }),
    );
  }
}
