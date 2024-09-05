import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/cat_bloc/cat_bloc.dart';
import '../widgets/cat_card.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(child: _buildCatList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Cat Breeds'),
          ) as PreferredSizeWidget
        : AppBar(
            title: Text('Cat Breeds'),
            centerTitle: true,
          );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Platform.isIOS
        ? Container(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _onSearch(context, value);
              },
              placeholder: 'Search breeds...',
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _onSearch(context, value);
              },
              decoration: InputDecoration(
                labelText: 'Search breeds...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          );
  }

  void _onSearch(BuildContext context, String query) {
    if (query.isEmpty) {
      context.read<CatBloc>().add(FetchCatBreeds());
    } else {
      context.read<CatBloc>().add(SearchCatBreeds(query));
    }
  }

  Widget _buildCatList() {
    return BlocBuilder<CatBloc, CatState>(
      builder: (context, state) {
        if (state is CatLoading) {
          return Center(
            child: Platform.isIOS
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(),
          );
        } else if (state is CatLoaded) {
          if (state.breeds.isEmpty) {
            return Center(child: Text('No breeds found.'));
          }
          return ListView.builder(
            itemCount: state.breeds.length,
            itemBuilder: (context, index) {
              final breed = state.breeds[index];
              return CatCard(breed: breed);
            },
          );
        } else if (state is CatError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}
