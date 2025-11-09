import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../../../app/config/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final ll.LatLng _center = ll.LatLng(19.4326, -99.1332); // CDMX
  
  // Puntos de interés
  final List<_PointOfInterest> _points = [
    _PointOfInterest(
      name: "Museo Nacional de Antropología",
      location: ll.LatLng(19.4260, -99.1862),
      type: "cultural",
    ),
    _PointOfInterest(
      name: "Palacio de Bellas Artes",
      location: ll.LatLng(19.4352, -99.1413),
      type: "cultural",
    ),
    _PointOfInterest(
      name: "Frida Kahlo Museum",
      location: ll.LatLng(19.3545, -99.1626),
      type: "cultural",
    ),
    _PointOfInterest(
      name: "Restaurante Pujol",
      location: ll.LatLng(19.4323, -99.1943),
      type: "restaurant",
    ),
    _PointOfInterest(
      name: "Mercado de Artesanías",
      location: ll.LatLng(19.4249, -99.1522),
      type: "shopping",
    ),
    _PointOfInterest(
      name: "Zócalo",
      location: ll.LatLng(19.4326, -99.1332),
      type: "landmark",
    ),
  ];

  // Ruta entre puntos
  final List<ll.LatLng> _routePoints = [
    ll.LatLng(19.4326, -99.1332), // Zócalo
    ll.LatLng(19.4352, -99.1413), // Bellas Artes
    ll.LatLng(19.4260, -99.1862), // Museo de Antropología
    ll.LatLng(19.4323, -99.1943), // Pujol
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 768;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con mensaje de bienvenida
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.lightBlue,
                  child: Text(
                    'CT',
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¡Bienvenido de vuelta!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Amado José',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppTheme.darkGray,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Mapa
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Explora la Ciudad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => context.go('/discover'),
                      icon: const Icon(Icons.map_outlined, size: 16),
                      label: const Text('Ver más'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Mapa
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: _center,
                            initialZoom: 13.0,
                            backgroundColor: const Color(0xFFEBF5FF),
                          ),
                          children: [
                            // Capa de mapa
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                              subdomains: ['a', 'b', 'c', 'd'],
                              userAgentPackageName: 'com.example.turex',
                            ),
                            
                            // Ruta entre puntos
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: _routePoints,
                                  color: AppTheme.primaryBlue.withOpacity(0.8),
                                  strokeWidth: 3.0,
                                )
                              ],
                            ),
                            
                            // Puntos de interés
                            MarkerLayer(
                              markers: _points.map((point) {
                                return Marker(
                                  point: point.location,
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: _MapMarker(type: point.type),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        
                        // Botones de zoom y posición
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Column(
                            children: [
                              _MapButton(
                                icon: Icons.add,
                                onPressed: () {},
                              ),
                              const SizedBox(height: 8),
                              _MapButton(
                                icon: Icons.remove,
                                onPressed: () {},
                              ),
                              const SizedBox(height: 8),
                              _MapButton(
                                icon: Icons.my_location,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sección de acciones rápidas
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paga y comparte',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          title: 'Split',
                          subtitle: 'Divide gastos',
                          icon: Icons.call_split,
                          color: AppTheme.primaryBlue,
                          onTap: () => context.go('/split'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          title: 'Grupo',
                          subtitle: 'Pago colectivo',
                          icon: Icons.group,
                          color: AppTheme.darkBlue,
                          onTap: () => context.go('/group'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Categorías
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final categories = [
                      {
                        'name': 'Restaurantes',
                        'icon': Icons.restaurant,
                        'color': const Color(0xFFFD3C4A),
                      },
                      {
                        'name': 'Tours',
                        'icon': Icons.tour,
                        'color': const Color(0xFF00A86B),
                      },
                      {
                        'name': 'Bares',
                        'icon': Icons.local_bar,
                        'color': const Color(0xFFFCBF49),
                      },
                      {
                        'name': 'Artesanías',
                        'icon': Icons.shopping_bag,
                        'color': const Color(0xFF7269EF),
                      },
                    ];
                    
                    final category = categories[index];
                    
                    return InkWell(
                      onTap: () => context.go('/discover'),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: (category['color'] as Color).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                category['icon'] as IconData,
                                color: category['color'] as Color,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category['name'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointOfInterest {
  final String name;
  final ll.LatLng location;
  final String type; // cultural, restaurant, shopping, landmark

  _PointOfInterest({
    required this.name,
    required this.location,
    required this.type,
  });
}

class _MapMarker extends StatelessWidget {
  final String type;
  
  const _MapMarker({required this.type});

  @override
  Widget build(BuildContext context) {
    Color markerColor;
    IconData markerIcon;
    
    switch(type) {
      case 'restaurant':
        markerColor = const Color(0xFFFD3C4A);
        markerIcon = Icons.restaurant;
        break;
      case 'cultural':
        markerColor = const Color(0xFF00A86B);
        markerIcon = Icons.museum;
        break;
      case 'shopping':
        markerColor = const Color(0xFFFCBF49);
        markerIcon = Icons.shopping_bag;
        break;
      case 'landmark':
        markerColor = const Color(0xFF7269EF);
        markerIcon = Icons.location_city;
        break;
      default:
        markerColor = AppTheme.primaryBlue;
        markerIcon = Icons.place;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        markerIcon,
        color: markerColor,
        size: 20,
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  
  const _MapButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        color: AppTheme.darkGray,
        padding: EdgeInsets.zero,
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.darkGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}