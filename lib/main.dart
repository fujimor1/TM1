import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tm1/config/router/app_router.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
import 'package:tm1/presentation/bloc/district/district_cubit.dart';
import 'package:tm1/presentation/bloc/register/register_cubit.dart';
import 'package:tm1/presentation/bloc/services_locator.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

void main() async{
  
  runApp(
    const ProviderScope(
      child: BlocsProviders(),
    ),
  );
  serviceLocatorInit();
}

class BlocsProviders extends StatelessWidget {
  const BlocsProviders({super.key});

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<RegisterCubit>()),
        BlocProvider(create: (context) => getIt<CategoriesCubit>()),
        BlocProvider(create: (context) => getIt<DistrictCubit>()),
        BlocProvider(create: (context) => getIt<ProfileBloc>()),
        BlocProvider(create: (context) => getIt<TecnicoBloc>()),
        BlocProvider(create: (context) => getIt<SolicitudBloc>()),
      ], 
      child: const MyApp()
    
    );

  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title:'Proyecto_moviles',
    );
  }
}