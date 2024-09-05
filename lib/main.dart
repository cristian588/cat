import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat/config/app_router.dart';
import 'package:cat/config/theme.dart';
import 'package:cat/logic/blocs/cat_bloc/cat_bloc.dart';
import 'package:cat/logic/blocs/cat_detail_bloc/cat_detail_bloc.dart';
import 'package:cat/data/services/api_service.dart';
import 'package:cat/data/repositories/cat_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CatRepository(apiService: ApiService()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CatBloc>(
            create: (context) => CatBloc(
              RepositoryProvider.of<CatRepository>(context),
            )..add(FetchCatBreeds()),
          ),
          BlocProvider<CatDetailBloc>(
            create: (context) => CatDetailBloc(
              RepositoryProvider.of<CatRepository>(context),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Cat Breeds',
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          routerConfig: router,
        ),
      ),
    );
  }
}
