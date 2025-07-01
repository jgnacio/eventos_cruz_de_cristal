import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/main_scaffold.dart';
import '../features/fasting/presentation/screens/screens.dart';
import '../features/auth/presentation/screens/user_selector_screen.dart';
import '../features/events/presentation/screens/screens.dart';
import '../features/church/presentation/screens/screens.dart';

// Importar screens cuando estén creadas
// import '../features/auth/presentation/screens/splash_screen.dart';
// import '../features/auth/presentation/screens/login_screen.dart';
// import '../features/auth/presentation/screens/register_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String registerChurch = '/register-church';
  static const String home = '/home';
  static const String events = '/events';
  static const String eventDetail = '/event/:id';
  static const String createEvent = '/create-event';
  static const String editEvent = '/edit-event/:id';
  static const String churches = '/churches';
  static const String churchDetail = '/church/:id';
  static const String fasting = '/fasting';
  static const String fastingDetail = '/fasting/:id';
  static const String createFasting = '/create-fasting';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String admin = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminChurches = '/admin/churches';
  static const String adminEvents = '/admin/events';
  static const String adminRequests = '/admin/requests';
  static const String adminAnalytics = '/admin/analytics';
  static const String userSelector = '/user-selector';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Splash & Auth Routes (sin navbar)
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: registerChurch,
        builder: (context, state) => const RegisterChurchScreen(),
      ),
      
      // Main App with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainScaffold(
          currentPath: state.fullPath ?? '',
          child: child,
        ),
        routes: [
          // Main App Routes
          GoRoute(
            path: home,
            builder: (context, state) => const HomeScreen(),
          ),
          
          // Events Routes
          GoRoute(
            path: events,
            builder: (context, state) => const EventsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => EventDetailScreen(
                  eventId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: createEvent,
            builder: (context, state) => const CreateEventScreen(),
          ),
          GoRoute(
            path: editEvent,
            builder: (context, state) => EditEventScreen(
              eventId: state.pathParameters['id']!,
            ),
          ),
          
          // Churches Routes
          GoRoute(
            path: churches,
            builder: (context, state) => const ChurchesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => ChurchDetailScreen(
                  churchId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          
          // Fasting Routes
          GoRoute(
            path: fasting,
            builder: (context, state) => const FastingScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => FastingDetailScreen(
                  fastingId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: createFasting,
            builder: (context, state) => const CreateFastingScreen(),
          ),
          
          // Profile & Settings Routes
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
      
      // Admin Routes (sin navbar)
      GoRoute(
        path: admin,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: adminUsers,
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: adminChurches,
        builder: (context, state) => const AdminChurchesScreen(),
      ),
      GoRoute(
        path: adminEvents,
        builder: (context, state) => const AdminEventsScreen(),
      ),
      GoRoute(
        path: adminRequests,
        builder: (context, state) => const AdminRequestsScreen(),
      ),
      GoRoute(
        path: adminAnalytics,
        builder: (context, state) => const AdminAnalyticsScreen(),
      ),
      
      // Testing Routes
      GoRoute(
        path: userSelector,
        builder: (context, state) => const UserSelectorScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}

// Placeholder screens - estas serán reemplazadas por las pantallas reales
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    _navigateToHome();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _slideController.forward();
    });
  }

  _navigateToHome() async {
    // Simular tiempo de carga (3 segundos para ver las animaciones)
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      // Navegar al selector de usuarios para testing
      // En producción, aquí verificarías si el usuario ya está autenticado
      context.go('/user-selector');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.church_rounded,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Eventos',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Cruz de Cristal',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Cargando...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      '"Porque donde están dos o tres congregados en mi nombre, allí estoy yo en medio de ellos."',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Mateo 18:20',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.church,
              size: 64,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simular login exitoso - navegar al home
                  context.go('/home');
                },
                child: const Text('Iniciar Sesión'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿No tienes cuenta? '),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Regístrate'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/register-church'),
              child: const Text('Registrar mi Iglesia'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: const Center(child: Text('Pantalla de Registro')),
    );
  }
}

class RegisterChurchScreen extends StatelessWidget {
  const RegisterChurchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Iglesia')),
      body: const Center(child: Text('Pantalla de Registro de Iglesia')),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.tertiary.withOpacity(0.03),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(context),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => context.go('/notifications'),
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildFeatureCard(
                      context: context,
                      title: 'Eventos',
                      subtitle: 'Próximos cultos y actividades',
                      icon: Icons.event_note_rounded,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                      onTap: () => context.go('/events'),
                    ),
                    _buildFeatureCard(
                      context: context,
                      title: 'Iglesias',
                      subtitle: 'Encuentra tu congregación',
                      icon: Icons.church_rounded,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                        ],
                      ),
                      onTap: () => context.go('/churches'),
                    ),
                    _buildFeatureCard(
                      context: context,
                      title: 'Ayunos',
                      subtitle: 'Únete en oración y ayuno',
                      icon: Icons.favorite_rounded,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.tertiary,
                          Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                        ],
                      ),
                      onTap: () => context.go('/fasting'),
                    ),
                    _buildFeatureCard(
                      context: context,
                      title: 'Configuración',
                      subtitle: 'Personaliza tu experiencia',
                      icon: Icons.settings_rounded,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.shade600,
                          Colors.grey.shade500,
                        ],
                      ),
                      onTap: () => context.go('/settings'),
                    ),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: _buildInspirationalSection(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.church_rounded,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Cruz de Cristal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspirationalSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Versículo del Día',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"Porque yo sé los pensamientos que tengo acerca de vosotros, dice Jehová, pensamientos de paz, y no de mal, para daros el fin que esperáis."',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Jeremías 29:11',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Evento'),
        // automaticallyImplyLeading por defecto es true - mostrará flecha hacia atrás
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evento $eventId',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descripción completa del evento...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Acción de like
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Te gusta este evento!')),
                      );
                    },
                    icon: const Icon(Icons.favorite),
                    label: const Text('Me Gusta'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Acción de compartir
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Evento compartido')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Compartir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Evento')),
      body: const Center(child: Text('Crear Evento')),
    );
  }
}

class EditEventScreen extends StatelessWidget {
  final String eventId;
  const EditEventScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Evento')),
      body: Center(child: Text('Editar Evento: $eventId')),
    );
  }
}

class ChurchDetailScreen extends StatelessWidget {
  final String churchId;
  const ChurchDetailScreen({super.key, required this.churchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Iglesia')),
      body: Center(child: Text('Detalle de Iglesia: $churchId')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(context),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.settings_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => context.go('/settings'),
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMenuSection(context),
                    const SizedBox(height: 24),
                    _buildTestSection(context),
                    const SizedBox(height: 24),
                    _buildLogoutButton(context),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(56),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person_rounded,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Juan Pérez',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            'miembro@test.com',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Miembro',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(
            context: context,
            icon: Icons.church_rounded,
            title: 'Mis Iglesias',
            subtitle: 'Congregaciones que sigues',
            color: Theme.of(context).colorScheme.primary,
            onTap: () => context.go('/churches'),
          ),
          _buildDivider(),
          _buildMenuTile(
            context: context,
            icon: Icons.event_note_rounded,
            title: 'Mis Eventos',
            subtitle: 'Eventos guardados y confirmados',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => context.go('/events'),
          ),
          _buildDivider(),
          _buildMenuTile(
            context: context,
            icon: Icons.favorite_rounded,
            title: 'Mis Ayunos',
            subtitle: 'Ayunos en los que participas',
            color: Theme.of(context).colorScheme.tertiary,
            onTap: () => context.go('/fasting'),
          ),
        ],
      ),
    );
  }

  Widget _buildTestSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.shade200,
          width: 1,
        ),
      ),
      child: _buildMenuTile(
        context: context,
        icon: Icons.bug_report_rounded,
        title: 'Cambiar Usuario (Testing)',
        subtitle: 'Solo para pruebas de desarrollo',
        color: Colors.amber.shade700,
        onTap: () => context.go('/user-selector'),
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey.shade400,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton.icon(
        onPressed: () => context.go('/login'),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Cerrar Sesión'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade500,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: const Center(child: Text('Pantalla de Configuración')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: const Center(child: Text('Pantalla de Notificaciones')),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administración')),
      body: const Center(child: Text('Panel de Administración')),
    );
  }
}

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Usuarios')),
      body: const Center(child: Text('Administrar Usuarios')),
    );
  }
}

class AdminChurchesScreen extends StatelessWidget {
  const AdminChurchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Iglesias')),
      body: const Center(child: Text('Administrar Iglesias')),
    );
  }
}

class AdminEventsScreen extends StatelessWidget {
  const AdminEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Eventos')),
      body: const Center(child: Text('Administrar Eventos')),
    );
  }
}

class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes de Iglesias')),
      body: const Center(child: Text('Solicitudes de Iglesias')),
    );
  }
}

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analíticas')),
      body: const Center(child: Text('Analíticas')),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64),
            SizedBox(height: 16),
            Text('Página no encontrada'),
          ],
        ),
      ),
    );
  }
} 