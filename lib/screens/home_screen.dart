import 'package:flutter/material.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';

// Paleta de colores local por categoria
const _catColors = {
  ServiceCategory.plomeria:     Color(0xFF2196F3),
  ServiceCategory.electricidad: Color(0xFFFF9800),
  ServiceCategory.carpinteria:  Color(0xFF9C27B0),
  ServiceCategory.pintura:      Color(0xFF4CAF50),
  ServiceCategory.albanileria:  Color(0xFFF44336),
  ServiceCategory.jardineria:   Color(0xFF00BCD4),
  ServiceCategory.limpieza:     Color(0xFF673AB7),
  ServiceCategory.cerrajeria:   Color(0xFFFF5722),
  ServiceCategory.aires:        Color(0xFF0097A7),
  ServiceCategory.mudanza:      Color(0xFF795548),
};

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _cats = ServiceCategory.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 110, floating: true, snap: true,
          backgroundColor: const Color(0xFF1E6FD9),
          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                const Text('Hola, Maria', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const Text('Que necesitas hoy?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              ]),
            )),
          ),
          actions: [
            CircleAvatar(backgroundColor: Colors.white24, child: const Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            const SizedBox(width: 12),
          ],
        ),
        SliverToBoxAdapter(child: Column(children: [
          Padding(padding: const EdgeInsets.all(16), child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: const TextField(decoration: InputDecoration(
              hintText: 'Buscar servicio...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
              border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14))),
          )),
          Padding(padding: const EdgeInsets.fromLTRB(16,0,16,16), child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Primera visita gratis!', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Diagnostico sin costo en tu primer servicio', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                  onPressed: () {}, child: const Text('Ver mas')),
              ])),
              const Icon(Icons.home_repair_service, color: Colors.white30, size: 52),
            ]),
          )),
          Padding(padding: const EdgeInsets.fromLTRB(16,0,16,8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Categorias de servicios', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            TextButton(onPressed: () {}, child: const Text('Ver todas')),
          ])),
          Padding(padding: const EdgeInsets.fromLTRB(16,0,16,16), child: GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.0, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: _cats.length,
            itemBuilder: (ctx, i) => _CategoryCard(cat: _cats[i]),
          )),
          const SizedBox(height: 80),
        ])),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.nuevaSolicitud),
        backgroundColor: const Color(0xFFF97316),
        icon: const Icon(Icons.add), label: const Text('Nueva solicitud'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, selectedItemColor: const Color(0xFF1E6FD9),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ServiceCategory cat;
  const _CategoryCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    final color = _catColors[cat] ?? const Color(0xFF607D8B);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.nuevaSolicitud),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 6, offset: const Offset(0,2))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.13), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(cat.icon, style: const TextStyle(fontSize: 22)))),
          const SizedBox(height: 6),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(cat.label,
              textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
        ]),
      ),
    );
  }
}