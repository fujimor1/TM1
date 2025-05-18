import 'package:go_router/go_router.dart';
import 'package:tm1/presentation/screens/Register/Register_Screen.dart';
import 'package:tm1/presentation/screens/Request/Request_screen.dart';
import 'package:tm1/presentation/screens/profile/Profile_screen.dart';
import 'package:tm1/presentation/screens/auth/Login_screen.dart';
import 'package:tm1/presentation/screens/home/Home_screen.dart';
import 'package:tm1/presentation/views/Home/DetallesTecnicoView.dart';
import 'package:tm1/presentation/views/Home/Solicitud_view.dart';
import 'package:tm1/presentation/views/Home/Tecnicos_view.dart';
import 'package:tm1/presentation/views/Login/Reset_password.dart';
import 'package:tm1/presentation/views/Login/Reset_view.dart';
import 'package:tm1/presentation/views/Register/Register_tecnico.dart';
import 'package:tm1/presentation/views/Register/Register_user.dart';

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
      path: '/Register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
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
