import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../widgets/app_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';

  final List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _currentIndex == 0
          ? _HomeBody(onSearch: (q) => setState(() => _searchQuery = q))
          : _currentIndex == 1
              ? _SolicitudesBody()
              : _PerfilBody(),
      floatingActionButton: _currentIndex == 0
          ? FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: FloatingActionButton.extended(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.nuevaSolicitud),
                backgroundColor: AppColors.orange,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text(
                  'Nueva solicitud',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const _HomeBody({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Header
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hola, María 👋',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '¿Qué necesitas hoy?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: const Text(
                                  'M',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.orange,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.primaryDark, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Search bar
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          onChanged: onSearch,
                          decoration: const InputDecoration(
                            hintText: 'Buscar servicio...',
                            prefixIcon: Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Banner promo
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GradientCard(
                    colors: const [AppColors.orange, Color(0xFFEA580C)],
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '¡Primera visita\ngratis!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Diagnóstico sin costo\nen tu primer servicio',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Ver más',
                                  style: TextStyle(
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.home_repair_service_rounded,
                          color: Colors.white,
                          size: 72,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Categories
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const SectionHeader(title: 'Categorías de servicios'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Categories grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final cat = ServiceCategory.values[i];
                return FadeInUp(
                  delay: Duration(milliseconds: 100 * (i % 4)),
                  child: _CategoryCard(category: cat),
                );
              },
              childCount: ServiceCategory.values.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
          ),
        ),

        // Recent requests
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Solicitudes recientes',
                  action: 'Ver todas',
                  onAction: () {},
                ),
              ),
              const SizedBox(height: 16),
              ...solicitudesDemo.map((s) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _SolicitudCard(solicitud: s),
                  )),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ServiceCategory category;

  const _CategoryCard({required this.category});

  static const _gradients = [
    [Color(0xFF1E6FD9), Color(0xFF4D90E8)],
    [Color(0xFFF97316), Color(0xFFFB923C)],
    [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
    [Color(0xFF10B981), Color(0xFF34D399)],
    [Color(0xFFEF4444), Color(0xFFF87171)],
    [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
    [Color(0xFF6366F1), Color(0xFF818CF8)],
    [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
    [Color(0xFFEC4899), Color(0xFFF472B6)],
  ];

  @override
  Widget build(BuildContext context) {
    final gradient = _gradients[category.index % _gradients.length];
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.nuevaSolicitud),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient.map((c) => c).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 32)),
            const Spacer(),
            Text(
              category.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SolicitudCard extends StatelessWidget {
  final Solicitud solicitud;

  const _SolicitudCard({required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (solicitud.status == SolicitudStatus.completada && solicitud.calificacion == null) {
          Navigator.pushNamed(context, AppRoutes.calificacion, arguments: solicitud);
        } else {
          Navigator.pushNamed(context, AppRoutes.seguimiento, arguments: solicitud);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  solicitud.categoria.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    solicitud.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    solicitud.id,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _statusBadge(solicitud.status),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(SolicitudStatus status) {
    final Map<SolicitudStatus, (Color, Color)> colors = {
      SolicitudStatus.recibida: (const Color(0xFF6366F1), const Color(0xFFEEF2FF)),
      SolicitudStatus.asignada: (AppColors.primary, const Color(0xFFEFF6FF)),
      SolicitudStatus.enCamino: (AppColors.orange, const Color(0xFFFFF7ED)),
      SolicitudStatus.enTrabajo: (AppColors.warning, const Color(0xFFFFFBEB)),
      SolicitudStatus.completada: (AppColors.success, const Color(0xFFF0FDF4)),
      SolicitudStatus.cancelada: (AppColors.error, const Color(0xFFFEF2F2)),
    };
    final (color, bg) = colors[status]!;
    return StatusBadge(label: status.label, color: color, bgColor: bg);
  }
}

class _SolicitudesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mis solicitudes'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: solicitudesDemo.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _SolicitudCard(solicitud: solicitudesDemo[i]),
      ),
    );
  }
}

class _PerfilBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi perfil'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'M',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'María García',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'maria@email.com',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                _StatCard(label: 'Servicios', value: '12', icon: Icons.build_rounded),
                const SizedBox(width: 12),
                _StatCard(label: 'Completados', value: '10', icon: Icons.check_circle_rounded),
                const SizedBox(width: 12),
                _StatCard(label: 'Calificación', value: '4.9', icon: Icons.star_rounded),
              ],
            ),
            const SizedBox(height: 24),

            // Menu items
            ..._menuItems.map((item) => _MenuItem(item: item)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

const _menuItems = [
  (Icons.person_outline_rounded, 'Editar perfil', false),
  (Icons.location_on_outlined, 'Mis direcciones', false),
  (Icons.notifications_outlined, 'Notificaciones', false),
  (Icons.payment_outlined, 'Métodos de pago', false),
  (Icons.help_outline_rounded, 'Ayuda y soporte', false),
  (Icons.logout_rounded, 'Cerrar sesión', true),
];

class _MenuItem extends StatelessWidget {
  final (IconData, String, bool) item;

  const _MenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final (icon, label, isDanger) = item;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDanger ? AppColors.error : AppColors.textSecondary, size: 22),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDanger ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        trailing: isDanger
            ? null
            : const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
        onTap: () {
          if (isDanger) Navigator.pushReplacementNamed(context, AppRoutes.login);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Inicio', index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.list_alt_rounded, label: 'Solicitudes', index: 1, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.person_rounded, label: 'Perfil', index: 2, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppColors.primary : AppColors.textHint, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
