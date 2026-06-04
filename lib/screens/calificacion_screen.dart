import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/app_widgets.dart';
import '../routes/app_routes.dart';

class CalificacionScreen extends StatefulWidget {
  final Solicitud solicitud;

  const CalificacionScreen({super.key, required this.solicitud});

  @override
  State<CalificacionScreen> createState() => _CalificacionScreenState();
}

class _CalificacionScreenState extends State<CalificacionScreen> {
  double _rating = 0;
  final Set<String> _selectedTags = {};
  final _comentarioController = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted = false;

  static const _positiveTags = [
    'Puntual', 'Limpio', 'Profesional', 'Rápido',
    'Amable', 'Buen trabajo', 'Resolvió el problema',
  ];

  static const _negativeTags = [
    'Tardanza', 'Precio alto', 'No resolvió', 'Grosero',
  ];

  bool get _isPositive => _rating >= 4;

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una calificación')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _submitted
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
              title: const Text('Calificar servicio'),
            ),
      body: _submitted ? _SuccessView(rating: _rating) : _RatingForm(),
    );
  }

  Widget _RatingForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Technician info
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.solicitud.tecnico?.nombre[0] ?? 'T',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.solicitud.tecnico?.nombreCompleto ?? 'Técnico',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.solicitud.titulo,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Rating stars
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    '¿Cómo fue el servicio?',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    itemCount: 5,
                    itemSize: 48,
                    glow: true,
                    glowColor: AppColors.orange.withOpacity(0.3),
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: AppColors.orange,
                    ),
                    unratedColor: AppColors.border,
                    onRatingUpdate: (r) => setState(() => _rating = r),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _ratingLabel,
                      key: ValueKey(_rating),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _rating == 0
                            ? AppColors.textHint
                            : _rating >= 4
                                ? AppColors.success
                                : _rating >= 3
                                    ? AppColors.warning
                                    : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Quick tags
          if (_rating > 0) ...[
            FadeIn(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _isPositive ? '¿Qué destacarías?' : '¿Qué salió mal?',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeIn(
              duration: const Duration(milliseconds: 400),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (_isPositive ? _positiveTags : _negativeTags)
                    .map((tag) => _TagChip(
                          label: tag,
                          isSelected: _selectedTags.contains(tag),
                          isPositive: _isPositive,
                          onTap: () {
                            setState(() {
                              if (_selectedTags.contains(tag)) {
                                _selectedTags.remove(tag);
                              } else {
                                _selectedTags.add(tag);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Comment
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comentario (opcional)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _comentarioController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cuéntanos más sobre tu experiencia...',
                    hintStyle: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: PrimaryButton(
              label: 'Enviar calificación',
              onPressed: _rating > 0 ? _submit : null,
              isLoading: _isSubmitting,
              icon: Icons.send_rounded,
              color: AppColors.orange,
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: TextButton(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text(
                'Omitir por ahora',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _ratingLabel {
    if (_rating == 0) return 'Toca para calificar';
    if (_rating == 1) return 'Muy malo 😞';
    if (_rating == 2) return 'Malo 😐';
    if (_rating == 3) return 'Regular 🙂';
    if (_rating == 4) return 'Bueno 😊';
    return 'Excelente! 🌟';
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isPositive;
  final VoidCallback onTap;

  const _TagChip({
    required this.label,
    required this.isSelected,
    required this.isPositive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isPositive ? AppColors.success : AppColors.error;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? activeColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final double rating;

  const _SuccessView({required this.rating});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BounceInDown(
              duration: const Duration(milliseconds: 800),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const Text(
                '¡Gracias por tu calificación!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: const Text(
                'Tu opinión nos ayuda a mejorar\ny a reconocer el trabajo de nuestros técnicos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeIn(
              delay: const Duration(milliseconds: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return Icon(
                    Icons.star_rounded,
                    color: i < rating ? AppColors.orange : AppColors.border,
                    size: 36,
                  );
                }),
              ),
            ),
            const SizedBox(height: 40),
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: PrimaryButton(
                label: 'Volver al inicio',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                ),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.nuevaSolicitud,
                  (route) => false,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Solicitar otro servicio',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
