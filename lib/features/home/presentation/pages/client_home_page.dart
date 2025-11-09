import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../../../app/config/theme.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final ll.LatLng _center = ll.LatLng(19.4326, -99.1332); // CDMX
  final List<ll.LatLng> _points = [
    ll.LatLng(19.4326, -99.1332),
    ll.LatLng(19.4420, -99.1430),
    ll.LatLng(19.4250, -99.1200),
    ll.LatLng(19.4385, -99.1300),
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mapa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 300,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _center,
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                        subdomains: ['a', 'b', 'c', 'd'],
                        userAgentPackageName: 'com.example.turex',
                      ),
                      MarkerLayer(
                        markers: _points
                            .map(
                              (p) => Marker(
                                point: p,
                                width: 28,
                                height: 36,
                                child: const _SharedLogoMarker(),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sección de acciones rápidas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paga y comparte',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: 'Split',
                        subtitle: 'Divide gastos fácilmente',
                        icon: Icons.call_split,
                        color: AppTheme.primaryBlue,
                        onTap: () => context.go('/split'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: 'Pago en Grupo',
                        subtitle: 'Crea un grupo de pago',
                        icon: Icons.group,
                        color: AppTheme.darkBlue,
                        onTap: () => context.go('/group'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _CategoryGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Restaurantes', 'image': '🍽️', 'color': Color(0xFFFF6B6B)},
    {'name': 'Tours', 'image': '🏛️', 'color': Color(0xFF4ECDC4)},
    {'name': 'Bares', 'image': '🍹', 'color': Color(0xFFFFBE0B)},
    {'name': 'Souvenirs', 'image': '🎨', 'color': Color(0xFF95E1D3)},
  ];

  _CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () => context.go('/discover'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: category['color'],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category['image'],
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SharedLogoMarker extends StatelessWidget {
  const _SharedLogoMarker();

  @override
  Widget build(BuildContext context) {
    // Pin estilo maps con color #03413C, con imagen en la cabeza
    return SizedBox(
      width: 28,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CustomPaint(
            painter: _PinPainter(Color(0xFF03413C)),
            size: Size(28, 36),
          ),
          // Imagen recortada en círculo, posicionada sobre la cabeza del pin
          Align(
            alignment: const Alignment(0, -0.35),
            child: ClipOval(
              child: Image.asset(
                'web/icons/interledger.jpg',
                width: 18,
                height: 18,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  final Color color;
  const _PinPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final r = w / 2; // radio de la cabeza
    final cx = w / 2;
    final cy = r + 2; // desplazar levemente hacia abajo

    // Cabeza (círculo)
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Cola (triángulo hacia abajo)
    final tail = ui.Path()
      ..moveTo(cx, h)
      ..lineTo(cx - r * 0.75, cy + r * 0.45)
      ..lineTo(cx + r * 0.75, cy + r * 0.45)
      ..close();
    canvas.drawPath(tail, paint);

    // Punto interno blanco para contraste
    final inner = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r * 0.45, inner);
  }

  @override
  bool shouldRepaint(covariant _PinPainter oldDelegate) => false;
}
