enum ServiceCategory {
  plomeria,
  electricidad,
  carpinteria,
  pintura,
  albanileria,
  jardineria,
  limpieza,
  cerrajeria,
  aires,
  mudanza,
}

extension ServiceCategoryExt on ServiceCategory {
  String get label {
    const labels = {
      ServiceCategory.plomeria: 'Plomería',
      ServiceCategory.electricidad: 'Electricidad',
      ServiceCategory.carpinteria: 'Carpintería',
      ServiceCategory.pintura: 'Pintura',
      ServiceCategory.albanileria: 'Albañilería',
      ServiceCategory.jardineria: 'Jardinería',
      ServiceCategory.limpieza: 'Limpieza',
      ServiceCategory.cerrajeria: 'Cerrajería',
      ServiceCategory.aires: 'Aire A/C',
      ServiceCategory.mudanza: 'Mudanza',
    };
    return labels[this]!;
  }

  String get icon {
    const icons = {
      ServiceCategory.plomeria: '🔧',
      ServiceCategory.electricidad: '⚡',
      ServiceCategory.carpinteria: '🪵',
      ServiceCategory.pintura: '🎨',
      ServiceCategory.albanileria: '🧱',
      ServiceCategory.jardineria: '🌿',
      ServiceCategory.limpieza: '🧹',
      ServiceCategory.cerrajeria: '🔑',
      ServiceCategory.aires: '❄️',
      ServiceCategory.mudanza: '📦',
    };
    return icons[this]!;
  }

  String get description {
    const desc = {
      ServiceCategory.plomeria: 'Tuberías, filtraciones y más',
      ServiceCategory.electricidad: 'Instalaciones y reparaciones',
      ServiceCategory.carpinteria: 'Muebles, puertas y ventanas',
      ServiceCategory.pintura: 'Interior y exterior',
      ServiceCategory.albanileria: 'Construcción y remodelación',
      ServiceCategory.jardineria: 'Mantenimiento de jardines',
      ServiceCategory.limpieza: 'Hogar y oficinas',
      ServiceCategory.cerrajeria: 'Cerraduras y llaves',
      ServiceCategory.aires: 'Instalación y mantenimiento',
      ServiceCategory.mudanza: 'Traslados y embalaje',
    };
    return desc[this]!;
  }
}

enum SolicitudStatus {
  recibida,
  asignada,
  enCamino,
  enTrabajo,
  completada,
  cancelada,
}

extension SolicitudStatusExt on SolicitudStatus {
  String get label {
    const labels = {
      SolicitudStatus.recibida: 'Recibida',
      SolicitudStatus.asignada: 'Asignada',
      SolicitudStatus.enCamino: 'En camino',
      SolicitudStatus.enTrabajo: 'En trabajo',
      SolicitudStatus.completada: 'Completada',
      SolicitudStatus.cancelada: 'Cancelada',
    };
    return labels[this]!;
  }

  String get description {
    const desc = {
      SolicitudStatus.recibida: 'Tu solicitud fue recibida y está siendo procesada.',
      SolicitudStatus.asignada: 'Se asignó un técnico a tu solicitud.',
      SolicitudStatus.enCamino: 'El técnico está en camino a tu domicilio.',
      SolicitudStatus.enTrabajo: 'El técnico está realizando el trabajo.',
      SolicitudStatus.completada: 'El servicio fue completado exitosamente.',
      SolicitudStatus.cancelada: 'La solicitud fue cancelada.',
    };
    return desc[this]!;
  }
}

class Tecnico {
  final String id;
  final String nombre;
  final String apellido;
  final String avatarUrl;
  final double calificacion;
  final int trabajosCompletados;
  final String especialidad;

  const Tecnico({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.avatarUrl,
    required this.calificacion,
    required this.trabajosCompletados,
    required this.especialidad,
  });

  String get nombreCompleto => '$nombre $apellido';
}

class TimelineEvent {
  final SolicitudStatus status;
  final DateTime timestamp;
  final bool isCompleted;
  final bool isActive;

  const TimelineEvent({
    required this.status,
    required this.timestamp,
    required this.isCompleted,
    required this.isActive,
  });
}

class Solicitud {
  final String id;
  final ServiceCategory categoria;
  final String titulo;
  final String descripcion;
  final String direccion;
  final DateTime fechaSolicitada;
  final SolicitudStatus status;
  final Tecnico? tecnico;
  final double? calificacion;
  final String? comentario;

  const Solicitud({
    required this.id,
    required this.categoria,
    required this.titulo,
    required this.descripcion,
    required this.direccion,
    required this.fechaSolicitada,
    required this.status,
    this.tecnico,
    this.calificacion,
    this.comentario,
  });

  List<TimelineEvent> get timeline {
    final allStatuses = [
      SolicitudStatus.recibida,
      SolicitudStatus.asignada,
      SolicitudStatus.enCamino,
      SolicitudStatus.enTrabajo,
      SolicitudStatus.completada,
    ];
    final currentIndex = allStatuses.indexOf(status);
    return List.generate(allStatuses.length, (i) {
      return TimelineEvent(
        status: allStatuses[i],
        timestamp: fechaSolicitada.add(Duration(hours: i * 2)),
        isCompleted: i < currentIndex,
        isActive: i == currentIndex,
      );
    });
  }
}

// Demo data
final Tecnico tecnicoDemo = Tecnico(
  id: 't1',
  nombre: 'Carlos',
  apellido: 'Mendoza',
  avatarUrl: 'https://i.pravatar.cc/150?img=12',
  calificacion: 4.8,
  trabajosCompletados: 247,
  especialidad: 'Plomería y Electricidad',
);

final List<Solicitud> solicitudesDemo = [
  Solicitud(
    id: 'S-001',
    categoria: ServiceCategory.plomeria,
    titulo: 'Reparación de tubería',
    descripcion: 'Hay una fuga en la tubería del baño principal.',
    direccion: 'Av. Reforma 123, Col. Centro',
    fechaSolicitada: DateTime.now().subtract(const Duration(hours: 4)),
    status: SolicitudStatus.enCamino,
    tecnico: tecnicoDemo,
  ),
  Solicitud(
    id: 'S-002',
    categoria: ServiceCategory.electricidad,
    titulo: 'Instalación de contactos',
    descripcion: 'Necesito instalar 4 contactos nuevos en la sala.',
    direccion: 'Calle Morelos 45, Col. Juárez',
    fechaSolicitada: DateTime.now().subtract(const Duration(days: 2)),
    status: SolicitudStatus.completada,
    tecnico: tecnicoDemo,
    calificacion: 5,
    comentario: 'Excelente trabajo, muy puntual.',
  ),
];
