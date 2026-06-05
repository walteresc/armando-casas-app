import 'package:flutter/material.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';

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
          expandedHeight: 100, floating: true, snap: true,
          backgroundColor: const Color(0xFF1E6FD9),
          flexibleSpace: FlexibleSpaceBar(
            background: SafeArea(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                const Text('Hola, Maria', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const Text('Que necesitas hoy?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              ]),
            )),
          ),
          actions: [CircleAvatar(backgroundColor: Colors.white24, radius: 18, child: const Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))), const SizedBox(width: 12)],
        ),
        SliverToBoxAdapter(child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(16,12,16,8), child: Container(
            height: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: const TextField(decoration: InputDecoration(hintText: 'Buscar servicio...', hintStyle: TextStyle(fontSize: 14), prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12))),
          )),
          Padding(padding: const EdgeInsets.fromLTRB(16,0,16,12), child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Primera visita gratis!', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                const Text('Diagnostico sin costo en tu primer servicio', style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 8),
                GestureDetector(onTap: () {}, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Ver mas', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)))),
              ])),
              const Icon(Icons.home_repair_service, color: Colors.white30, size: 48),
            ]),
          )),
          Padding(padding: const EdgeInsets.fromLTRB(16,0,16,6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Categorias', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            TextButton(onPressed: () {}, child: const Text('Ver todas', style: TextStyle(fontSize: 12))),
          ])),
          Padding(padding: const EdgeInsets.fromLTRB(16,0,16,16), child: GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, childAspectRatio: 0.85, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: _cats.length,
            itemBuilder: (ctx, i) => _CategoryCard(cat: _cats[i]),
          )),
          const SizedBox(height: 80),
        ])),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.nuevaSolicitud),
        backgroundColor: const Color(0xFFF97316), elevation: 2,
        icon: const Icon(Icons.add, size: 20), label: const Text('Nueva solicitud', style: TextStyle(fontSize: 13)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, selectedItemColor: const Color(0xFF1E6FD9),
        selectedFontSize: 11, unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 22), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt, size: 22), label: 'Solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 22), label: 'Perfil'),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0,2))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(cat.icon, style: const TextStyle(fontSize: 18)))),
          const SizedBox(height: 4),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(cat.label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
        ]),
      ),
    );
  }
}