import 'package:get_it/get_it.dart';
import 'package:tm1/presentation/bloc/Profile/bloc/profile_bloc.dart';
import 'package:tm1/presentation/bloc/categories/categories_cubit.dart';
import 'package:tm1/presentation/bloc/district/district_cubit.dart';
import 'package:tm1/presentation/bloc/register/register_cubit.dart';
import 'package:tm1/presentation/bloc/solicitud/bloc/solicitud_bloc.dart';
import 'package:tm1/presentation/bloc/tecnico/bloc/tecnico_bloc.dart';

GetIt getIt = GetIt.instance;

void serviceLocatorInit(){
  getIt.registerSingleton(RegisterCubit());
  getIt.registerSingleton(CategoriesCubit());
  getIt.registerSingleton(DistrictCubit());
  getIt.registerSingleton(ProfileBloc());
  getIt.registerSingleton(TecnicoBloc());
  getIt.registerSingleton(SolicitudBloc());
}