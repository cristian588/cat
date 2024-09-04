import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../logic/blocs/cat_detail_bloc/cat_detail_bloc.dart';
import '../../data/services/api_service.dart';

class CatDetailScreen extends StatelessWidget {
  final String catId;

  CatDetailScreen({required this.catId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CatDetailBloc(ApiService())..add(FetchCatDetail(catId)),
      child: Platform.isIOS
          ? _buildCupertinoDetail(context)
          : _buildMaterialDetail(context),
    );
  }

  Widget _buildMaterialDetail(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CatDetailBloc, CatDetailState>(
          builder: (context, state) {
            if (state is CatDetailLoaded) {
              return Text(state.catBreed.name,
                  style: const TextStyle(
                      color: Colors.black, decoration: TextDecoration.none));
            }
            return const Text('Cat Details',
                style: TextStyle(
                    color: Colors.black, decoration: TextDecoration.none));
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/landing');
            }
          },
        ),
      ),
      body: BlocBuilder<CatDetailBloc, CatDetailState>(
        builder: (context, state) {
          if (state is CatDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CatDetailLoaded) {
            final catBreed = state.catBreed;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    catBreed.imageUrl != null
                        ? Image.network(
                            catBreed.imageUrl!,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.pets,
                            size: 100,
                          ),
                    const SizedBox(height: 20.0),
                    Text(catBreed.description,
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            decoration: TextDecoration.none)),
                    const SizedBox(height: 20.0),
                    Text('Origin: ${catBreed.origin}',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            decoration: TextDecoration.none)),
                    const SizedBox(height: 10.0),
                    Text('Intelligence: ${catBreed.intelligence}',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            decoration: TextDecoration.none)),
                    const SizedBox(height: 10.0),
                    Text('Adaptability: ${catBreed.adaptability}',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            decoration: TextDecoration.none)),
                    const SizedBox(height: 10.0),
                    Text('Life Span: ${catBreed.lifeSpan} years',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            decoration: TextDecoration.none)),
                  ],
                ),
              ),
            );
          } else if (state is CatDetailError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(
                        color: Colors.black, decoration: TextDecoration.none)));
          }
          return const Center(
              child: Text('Select a cat to view details.',
                  style: TextStyle(
                      color: Colors.black, decoration: TextDecoration.none)));
        },
      ),
    );
  }

  Widget _buildCupertinoDetail(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: BlocBuilder<CatDetailBloc, CatDetailState>(
          builder: (context, state) {
            if (state is CatDetailLoaded) {
              return Text(state.catBreed.name,
                  style: const TextStyle(
                      color: CupertinoColors.black,
                      decoration: TextDecoration.none));
            }
            return const Text('Cat Details',
                style: TextStyle(
                    color: CupertinoColors.black,
                    decoration: TextDecoration.none));
          },
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              GoRouter.of(context).go('/landing');
            }
          },
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.black),
        ),
        backgroundColor: CupertinoColors.white,
      ),
      child: BlocBuilder<CatDetailBloc, CatDetailState>(
        builder: (context, state) {
          if (state is CatDetailLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is CatDetailLoaded) {
            final catBreed = state.catBreed;
            return SingleChildScrollView(
              child: Column(
                children: [
                  catBreed.imageUrl != null
                      ? Image.network(
                          catBreed.imageUrl!,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          CupertinoIcons.photo_fill,
                          size: 100,
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(catBreed.description,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: CupertinoColors.black,
                                decoration: TextDecoration.none)),
                        const SizedBox(height: 20.0),
                        Text('Origin: ${catBreed.origin}',
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: CupertinoColors.black,
                                decoration: TextDecoration.none)),
                        const SizedBox(height: 10.0),
                        Text('Intelligence: ${catBreed.intelligence}',
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: CupertinoColors.black,
                                decoration: TextDecoration.none)),
                        const SizedBox(height: 10.0),
                        Text('Adaptability: ${catBreed.adaptability}',
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: CupertinoColors.black,
                                decoration: TextDecoration.none)),
                        const SizedBox(height: 10.0),
                        Text('Life Span: ${catBreed.lifeSpan} years',
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: CupertinoColors.black,
                                decoration: TextDecoration.none)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CatDetailError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(
                        color: CupertinoColors.black,
                        decoration: TextDecoration.none)));
          }
          return const Center(
              child: Text('Select a cat to view details.',
                  style: TextStyle(
                      color: CupertinoColors.black,
                      decoration: TextDecoration.none)));
        },
      ),
    );
  }
}
