import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/screens/Category/category_screen.dart';
import 'package:tm1/presentation/screens/Register/register_screen.dart';
import 'package:tm1/presentation/screens/Request/request_screen.dart';
import 'package:tm1/presentation/screens/paymment/paymment_screen.dart';
import 'package:tm1/presentation/screens/profile/profile_screen.dart';
import 'package:tm1/presentation/screens/auth/login_screen.dart';
import 'package:tm1/presentation/screens/home/home_screen.dart';
import 'package:tm1/presentation/views/Category/category_profile_edit.dart';
import 'package:tm1/presentation/views/Home/home_tenico/home_view_tecnico.dart';
import 'package:tm1/presentation/views/Home/home_user/detalles_tecnico_view.dart';
import 'package:tm1/presentation/views/Home/home_user/solicitud_view.dart';
import 'package:tm1/presentation/views/Home/home_user/tecnicos_view.dart';
import 'package:tm1/presentation/views/Login/reset_password.dart';
import 'package:tm1/presentation/views/Login/reset_view.dart';
import 'package:tm1/presentation/views/Paymment/subscription_view.dart';
import 'package:tm1/presentation/views/Profile/Profiletecnico/profile_view_tecnico.dart';
import 'package:tm1/presentation/views/Register/register_tecnico.dart';
import 'package:tm1/presentation/views/Register/register_tecnico_second.dart';
import 'package:tm1/presentation/views/Register/register_user.dart';
import 'package:tm1/presentation/views/Request/RequestTecnico/request_view_tecnico.dart';

final appRouter = GoRouter(
  initialLocation: '/login_screen',
  routes: [
    GoRoute(
      path: '/login_screen',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/Home',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/Profile',
      name: ProfileScreen.name,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/Request',
      name: RequestScreen.name,
      builder: (context, state) => const RequestScreen(),
    ),
    GoRoute(
      path: '/RVtecnico',
      name: RequestViewTecnico.name,
      builder: (context, state) => const RequestViewTecnico(),
    ),
    GoRoute(
      path: '/Register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/Pcard',
      name: SubscriptionView.name,
      builder: (context, state) => const SubscriptionView(), 
    ),
    GoRoute(
      path: '/HVtecnico',
      name: HomeViewTecnico.name,
      builder: (context, state) => const HomeViewTecnico(), 
    ),
    GoRoute(
      path: '/Ptecnico',
      name: ProfileViewTecnico.name,
      builder: (context, state) => const ProfileViewTecnico(), 
    ),
    GoRoute(
      path: '/Paymment',
      name: PaymmentScreen.name,
      builder: (context, state) => const PaymmentScreen(),
    ),
    GoRoute(
      path: '/Category',
      name: CategoryScreen.name,
      builder: (context, state) => const CategoryScreen(),
    ),
    GoRoute(
      path: '/Cprofile',
      name: CategoryProfileEdit.name,
      builder: (context, state) => const CategoryProfileEdit(),
    ),
    GoRoute(
      path: '/RUser',
      name: RegisterUser.name,
      builder: (context, state) => const RegisterUser(),
    ),
    GoRoute(
      path: '/RTecnico',
      name: RegisterTecnico.name,
      builder: (context, state) => const RegisterTecnico(),
    ),
    GoRoute(
      path: '/RSTecnico/:id',
      name: RegisterTecnicoSecond.name,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return RegisterTecnicoSecond(id: id);
      },
    ),
    GoRoute(
      path: '/Reset',
      name: ResetView.name,
      builder: (context, state) => const ResetView(),
    ),
    GoRoute(
      path: '/RPassword',
      name: ResetPassword.name,
      builder: (context, state) => const ResetPassword(),
    ),
    
    GoRoute(
      path: '/tecnicos/:categoria',
      name: TecnicosView.name,
      builder: (context, state) {
        final categoria = state.pathParameters['categoria']!;
        return TecnicosView(categoria: categoria);
      },
    ),
    GoRoute(
      path: '/DetallesTecnico',
      name: DetalleTecnicoView.name,
      builder: (context, state) {
        final tecnico = state.extra as Map<String, dynamic>;
        return DetalleTecnicoView(
          nombre: tecnico['nombre'],
          imagenUrl: tecnico['imagen'],
          descripcion: tecnico['descripcion'],
          categoria: tecnico['categoria'], 
          distrito: tecnico['distrito'],
        );
      },
    ),
    GoRoute(
      path: '/Solicitud',
      name: SolicitudServicioView.name,
      builder: (context, state) {
        final data = state.extra as Map<String, String>;
        return SolicitudServicioView(
          categoria: data['categoria']!,
          distrito: data['distrito']!,
        );
      },
    ),
  ],
);
