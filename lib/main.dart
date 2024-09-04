import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat/config/app_router.dart';
import 'package:cat/config/theme.dart';
import 'package:cat/logic/blocs/cat_bloc/cat_bloc.dart';
import 'package:cat/data/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatBloc>(
          create: (context) => CatBloc(ApiService())..add(FetchCatBreeds()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Cat Breeds',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        routerConfig: router,
      ),
    );
  }
}
