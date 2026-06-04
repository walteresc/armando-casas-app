import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../widgets/app_widgets.dart';

class SeguimientoScreen extends StatelessWidget {
  final Solicitud solicitud;

  const SeguimientoScreen({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Text('Seguimiento'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, size: 22),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Header card
                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: _HeaderCard(solicitud: solicitud),
                  ),
                ),
                const SizedBox(height: 20),

                // Map placeholder
                if (solicitud.status == SolicitudStatus.enCamino ||
                    solicitud.status == SolicitudStatus.enTrabajo)
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _MapPlaceholder(status: solicitud.status),
                    ),
                  ),

                const SizedBox(height: 20),

                // Technician card
                if (solicitud.tecnico != null)
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _TechnicianCard(tecnico: solicitud.tecnico!),
                    ),
                  ),

                const SizedBox(height: 20),

                // Timeline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Historial de estados',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Timeline events
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final event = solicitud.timeline[i];
                final isFirst = i == 0;
                final isLast = i == solicitud.timeline.length - 1;
                return FadeInLeft(
                  delay: Duration(milliseconds: 100 * i),
                  child: _TimelineItem(
                    event: event,
                    isFirst: isFirst,
                    isLast: isLast,
                  ),
                );
              },
              childCount: solicitud.timeline.length,
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // CTA button
                if (solicitud.status == SolicitudStatus.completada &&
                    solicitud.calificacion == null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: PrimaryButton(
                      label: 'Calificar servicio',
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.calificacion,
                        arguments: solicitud,
                      ),
                      icon: Icons.star_rounded,
                      color: AppColors.orange,
                    ),
                  ),

                if (solicitud.status == SolicitudStatus.enCamino ||
                    solicitud.status == SolicitudStatus.recibida)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        side: const BorderSide(color: AppColors.error),
                        foregroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.cancel_outlined, size: 20),
                      label: const Text(
                        'Cancelar solicitud',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Solicitud solicitud;

  const _HeaderCard({required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final statusColors = <SolicitudStatus, (Color, Color)>{
      SolicitudStatus.recibida: (const Color(0xFF6366F1), const Color(0xFFEEF2FF)),
      SolicitudStatus.asignada: (AppColors.primary, const Color(0xFFEFF6FF)),
      SolicitudStatus.enCamino: (AppColors.orange, const Color(0xFFFFF7ED)),
      SolicitudStatus.enTrabajo: (AppColors.warning, const Color(0xFFFFFBEB)),
      SolicitudStatus.completada: (AppColors.success, const Color(0xFFF0FDF4)),
      SolicitudStatus.cancelada: (AppColors.error, const Color(0xFFFEF2F2)),
    };
    final (color, bg) = statusColors[solicitud.status]!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    solicitud.categoria.icon,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solicitud.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
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
              StatusBadge(
                label: solicitud.status.label,
                color: color,
                bgColor: bg,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 14),
          Row(
            children: [
              _InfoChip(
                icon: Icons.location_on_outlined,
                text: solicitud.direccion,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _InfoChip(
                icon: Icons.access_time_rounded,
                text: _formatDate(solicitud.fechaSolicitada),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inHours < 1) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} horas';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final SolicitudStatus status;

  const _MapPlaceholder({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFE5F0FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          // Grid lines simulation
          CustomPaint(
            size: const Size(double.infinity, 160),
            painter: _MapGridPainter(),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    status == SolicitudStatus.enCamino
                        ? '🚗 Técnico a 10 min de tu domicilio'
                        : '🔧 Técnico trabajando en tu domicilio',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.08)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _TechnicianCard extends StatelessWidget {
  final Tecnico tecnico;

  const _TechnicianCard({required this.tecnico});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              tecnico.nombre[0],
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tecnico.nombreCompleto,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tecnico.especialidad,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 3),
                    Text(
                      '${tecnico.calificacion}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${tecnico.trabajosCompletados} trabajos',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              _ActionBtn(icon: Icons.phone_rounded, color: AppColors.success, onTap: () {}),
              const SizedBox(height: 8),
              _ActionBtn(icon: Icons.chat_bubble_outline_rounded, color: AppColors.primary, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = event.isActive
        ? AppColors.primary
        : event.isCompleted
            ? AppColors.success
            : AppColors.border;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        axis: TimelineAxis.vertical,
        lineXY: 0.0,
        indicatorStyle: IndicatorStyle(
          width: 24,
          height: 24,
          color: color,
          iconStyle: event.isCompleted
              ? IconStyle(
                  iconData: Icons.check_rounded,
                  color: Colors.white,
                  fontSize: 14,
                )
              : event.isActive
                  ? IconStyle(
                      iconData: Icons.radio_button_checked_rounded,
                      color: Colors.white,
                      fontSize: 14,
                    )
                  : IconStyle(
                      iconData: Icons.circle_outlined,
                      color: AppColors.border,
                      fontSize: 14,
                    ),
          padding: EdgeInsets.zero,
        ),
        beforeLineStyle: LineStyle(color: color, thickness: 2),
        afterLineStyle: LineStyle(
          color: event.isCompleted ? AppColors.success : AppColors.border,
          thickness: 2,
        ),
        endChild: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: event.isActive
                  ? AppColors.primary.withOpacity(0.05)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: event.isActive ? AppColors.primary.withOpacity(0.3) : AppColors.border,
                width: event.isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.status.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: event.isActive
                              ? AppColors.primary
                              : event.isCompleted
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        event.status.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: event.isActive
                              ? AppColors.textSecondary
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                if (event.isCompleted || event.isActive)
                  Text(
                    _formatTime(event.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: event.isActive ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
