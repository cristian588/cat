import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../logic/blocs/cat_detail_bloc/cat_detail_bloc.dart';
import '../../data/repositories/cat_repository.dart';

class CatDetailScreen extends StatelessWidget {
  final String catId;

  CatDetailScreen({required this.catId});

  final TextStyle textStyle = const TextStyle(
    fontSize: 16.0,
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  final TextStyle cupertinoTextStyle = const TextStyle(
    fontSize: 16.0,
    color: CupertinoColors.black,
    decoration: TextDecoration.none,
  );

  @override
  Widget build(BuildContext context) {
    final catRepository = RepositoryProvider.of<CatRepository>(context);

    return BlocProvider(
      create: (context) =>
          CatDetailBloc(catRepository)..add(FetchCatDetail(catId)),
      child: WillPopScope(
        onWillPop: () async {
          if (GoRouter.of(context).canPop()) {
            GoRouter.of(context).pop();
          } else {
            GoRouter.of(context).go('/landing');
          }
          return false;
        },
        child: Platform.isIOS
            ? _buildCupertinoDetail(context)
            : _buildMaterialDetail(context),
      ),
    );
  }

  Widget _buildMaterialDetail(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
          GoRouter.of(context).go('/landing');
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CatDetailBloc, CatDetailState>(
            builder: (context, state) {
              if (state is CatDetailLoaded) {
                return Text(state.catBreed.name, style: textStyle);
              }
              return Text('Cat Details', style: textStyle);
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
              return Center(
                child: Platform.isIOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
              );
            } else if (state is CatDetailLoaded) {
              final catBreed = state.catBreed;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: catBreed.imageUrl != null
                            ? Image.network(
                                catBreed.imageUrl!,
                                height: 250,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.pets,
                                size: 100,
                              ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(catBreed.description, style: textStyle),
                      const SizedBox(height: 20.0),
                      Text('Origin: ${catBreed.origin}', style: textStyle),
                      const SizedBox(height: 10.0),
                      Text('Intelligence: ${catBreed.intelligence}',
                          style: textStyle),
                      const SizedBox(height: 10.0),
                      Text('Adaptability: ${catBreed.adaptability}',
                          style: textStyle),
                      const SizedBox(height: 10.0),
                      Text('Life Span: ${catBreed.lifeSpan} years',
                          style: textStyle),
                    ],
                  ),
                ),
              );
            } else if (state is CatDetailError) {
              return Center(child: Text(state.message, style: textStyle));
            }
            return Center(
                child: Text('Select a cat to view details.', style: textStyle));
          },
        ),
      ),
    );
  }

  Widget _buildCupertinoDetail(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: BlocBuilder<CatDetailBloc, CatDetailState>(
          builder: (context, state) {
            if (state is CatDetailLoaded) {
              return Text(state.catBreed.name, style: cupertinoTextStyle);
            }
            return Text('Cat Details', style: cupertinoTextStyle);
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
                  Center(
                    child: catBreed.imageUrl != null
                        ? Image.network(
                            catBreed.imageUrl!,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            CupertinoIcons.photo_fill,
                            size: 100,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(catBreed.description, style: cupertinoTextStyle),
                        const SizedBox(height: 20.0),
                        Text('Origin: ${catBreed.origin}',
                            style: cupertinoTextStyle),
                        const SizedBox(height: 10.0),
                        Text('Intelligence: ${catBreed.intelligence}',
                            style: cupertinoTextStyle),
                        const SizedBox(height: 10.0),
                        Text('Adaptability: ${catBreed.adaptability}',
                            style: cupertinoTextStyle),
                        const SizedBox(height: 10.0),
                        Text('Life Span: ${catBreed.lifeSpan} years',
                            style: cupertinoTextStyle),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CatDetailError) {
            return Center(
                child: Text(state.message, style: cupertinoTextStyle));
          }
          return Center(
              child: Text('Select a cat to view details.',
                  style: cupertinoTextStyle));
        },
      ),
    );
  }
}
