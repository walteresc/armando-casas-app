import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/app_widgets.dart';
import '../routes/app_routes.dart';

class NuevaSolicitudScreen extends StatefulWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  State<NuevaSolicitudScreen> createState() => _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState extends State<NuevaSolicitudScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  ServiceCategory? _selectedCategory;
  String _titulo = '';
  String _descripcion = '';
  String _direccion = '';
  DateTime _fechaDeseada = DateTime.now().add(const Duration(days: 1));
  String _prioridad = 'Normal';
  bool _isSubmitting = false;

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      setState(() => _isSubmitting = false);
      final newSolicitud = Solicitud(
        id: 'S-${DateTime.now().millisecondsSinceEpoch % 1000}',
        categoria: _selectedCategory ?? ServiceCategory.plomeria,
        titulo: _titulo.isEmpty ? _selectedCategory?.label ?? 'Servicio' : _titulo,
        descripcion: _descripcion,
        direccion: _direccion.isEmpty ? 'Av. Principal 100' : _direccion,
        fechaSolicitada: DateTime.now(),
        status: SolicitudStatus.recibida,
      );
      Navigator.pushReplacementNamed(context, AppRoutes.seguimiento, arguments: newSolicitud);
    }
  }

  bool get _canNext {
    if (_currentStep == 0) return _selectedCategory != null;
    if (_currentStep == 1) return _descripcion.length >= 10 && _direccion.isNotEmpty;
    return true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: _prevStep,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Text('Nueva solicitud'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Paso ${_currentStep + 1} de 3',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: List.generate(3, (i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= _currentStep ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Step labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepLabel('Servicio', 0, _currentStep),
                _StepLabel('Detalles', 1, _currentStep),
                _StepLabel('Confirmar', 2, _currentStep),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step1(
                  selected: _selectedCategory,
                  onSelect: (c) => setState(() => _selectedCategory = c),
                ),
                _Step2(
                  titulo: _titulo,
                  descripcion: _descripcion,
                  direccion: _direccion,
                  fechaDeseada: _fechaDeseada,
                  prioridad: _prioridad,
                  onTituloChanged: (v) => setState(() => _titulo = v),
                  onDescripcionChanged: (v) => setState(() => _descripcion = v),
                  onDireccionChanged: (v) => setState(() => _direccion = v),
                  onFechaChanged: (d) => setState(() => _fechaDeseada = d),
                  onPrioridadChanged: (p) => setState(() => _prioridad = p),
                ),
                _Step3(
                  category: _selectedCategory,
                  titulo: _titulo,
                  descripcion: _descripcion,
                  direccion: _direccion,
                  fecha: _fechaDeseada,
                  prioridad: _prioridad,
                ),
              ],
            ),
          ),

          // Bottom button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: PrimaryButton(
              label: _currentStep == 2
                  ? 'Enviar solicitud'
                  : 'Continuar',
              onPressed: _canNext ? _nextStep : null,
              isLoading: _isSubmitting,
              icon: _currentStep == 2 ? Icons.send_rounded : null,
              color: _currentStep == 2 ? AppColors.orange : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String label;
  final int index;
  final int current;

  const _StepLabel(this.label, this.index, this.current);

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    final isDone = index < current;
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isDone ? AppColors.success : isActive ? AppColors.primary : AppColors.textHint,
      ),
    );
  }
}

// Step 1: Select category
class _Step1 extends StatelessWidget {
  final ServiceCategory? selected;
  final ValueChanged<ServiceCategory> onSelect;

  const _Step1({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Qué servicio\nnecesitas?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selecciona la categoría del servicio',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ...ServiceCategory.values.map((cat) => _CategoryRow(
                category: cat,
                isSelected: selected == cat,
                onTap: () => onSelect(cat),
              )),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final ServiceCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryRow({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(category.icon, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    category.description,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// Step 2: Details
class _Step2 extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String direccion;
  final DateTime fechaDeseada;
  final String prioridad;
  final ValueChanged<String> onTituloChanged;
  final ValueChanged<String> onDescripcionChanged;
  final ValueChanged<String> onDireccionChanged;
  final ValueChanged<DateTime> onFechaChanged;
  final ValueChanged<String> onPrioridadChanged;

  const _Step2({
    required this.titulo,
    required this.descripcion,
    required this.direccion,
    required this.fechaDeseada,
    required this.prioridad,
    required this.onTituloChanged,
    required this.onDescripcionChanged,
    required this.onDireccionChanged,
    required this.onFechaChanged,
    required this.onPrioridadChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cuéntanos más\ndetalle',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Mientras más detalles, mejor atención',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),

          AppTextField(
            label: 'Título breve',
            hint: 'Ej: Fuga en el baño',
            prefixIcon: Icons.title_rounded,
            initialValue: titulo,
            validator: null,
          ),
          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'Descripción del problema',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextFormField(
                initialValue: descripcion,
                onChanged: onDescripcionChanged,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Describe el problema con el mayor detalle posible...',
                  hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
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
          const SizedBox(height: 16),

          AppTextField(
            label: 'Dirección del servicio',
            hint: 'Calle, número, colonia',
            prefixIcon: Icons.location_on_outlined,
            initialValue: direccion,
            validator: null,
          ),
          const SizedBox(height: 16),

          // Fecha
          const Text(
            'Fecha deseada',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: fechaDeseada,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(primary: AppColors.primary),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) onFechaChanged(picked);
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.textHint, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    '${fechaDeseada.day}/${fechaDeseada.month}/${fechaDeseada.year}',
                    style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Priority
          const Text(
            'Prioridad',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['Baja', 'Normal', 'Urgente'].map((p) {
              final isSelected = prioridad == p;
              final color = p == 'Urgente'
                  ? AppColors.error
                  : p == 'Normal'
                      ? AppColors.primary
                      : AppColors.success;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onPrioridadChanged(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        p,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? color : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Adjuntar fotos
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, style: BorderStyle.solid),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, color: AppColors.textHint, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'Adjuntar fotos (opcional)',
                      style: TextStyle(color: AppColors.textHint, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Step 3: Confirm
class _Step3 extends StatelessWidget {
  final ServiceCategory? category;
  final String titulo;
  final String descripcion;
  final String direccion;
  final DateTime fecha;
  final String prioridad;

  const _Step3({
    required this.category,
    required this.titulo,
    required this.descripcion,
    required this.direccion,
    required this.fecha,
    required this.prioridad,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirma tu\nsolicitud',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Revisa los detalles antes de enviar',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // Category header
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          category?.icon ?? '🔧',
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category?.label ?? 'Sin categoría',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          titulo.isEmpty ? 'Sin título' : titulo,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                _DetailRow(
                  icon: Icons.description_outlined,
                  label: 'Descripción',
                  value: descripcion.isEmpty ? 'Sin descripción' : descripcion,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Dirección',
                  value: direccion.isEmpty ? 'Sin dirección' : direccion,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Fecha deseada',
                  value: '${fecha.day}/${fecha.month}/${fecha.year}',
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.priority_high_rounded,
                  label: 'Prioridad',
                  value: prioridad,
                  valueColor: prioridad == 'Urgente'
                      ? AppColors.error
                      : prioridad == 'Normal'
                          ? AppColors.primary
                          : AppColors.success,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Price estimate
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimado de costo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'El técnico te dará una cotización exacta en sitio',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '\$350-800',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textHint, size: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.textHint, fontSize: 11),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 240,
              child: Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
