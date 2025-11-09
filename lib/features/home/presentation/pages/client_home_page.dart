import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../../../app/config/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final ll.LatLng _center = ll.LatLng(19.4326, -99.1332); // CDMX
  final PageController _promoController = PageController();
  
  // Puntos de interés
  final List<_PointOfInterest> _points = [
    _PointOfInterest(
      name: "Museo Nacional de Antropología",
      location: ll.LatLng(19.4260, -99.1862),
      type: "cultural",
      imageUrl: "https://images.unsplash.com/photo-1577128580649-9a5bb70dab55?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
    ),
    _PointOfInterest(
      name: "Palacio de Bellas Artes",
      location: ll.LatLng(19.4352, -99.1413),
      type: "cultural",
      imageUrl: "https://images.unsplash.com/photo-1585464231875-d9ef1f5ad396?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
    ),
    _PointOfInterest(
      name: "Museo Frida Kahlo",
      location: ll.LatLng(19.3545, -99.1626),
      type: "cultural",
      imageUrl: "https://images.unsplash.com/photo-1588953936179-d2a4734c5490?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
    ),
    _PointOfInterest(
      name: "Restaurante Pujol",
      location: ll.LatLng(19.4323, -99.1943),
      type: "restaurant",
      imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
    ),
    _PointOfInterest(
      name: "Mercado de Artesanías",
      location: ll.LatLng(19.4249, -99.1522),
      type: "shopping",
      imageUrl: "https://images.unsplash.com/photo-1513735718075-2e2d37cb7cc1?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
    ),
    _PointOfInterest(
      name: "Zócalo",
      location: ll.LatLng(19.4326, -99.1332),
      type: "landmark",
      imageUrl: "https://images.unsplash.com/photo-1518214598173-1666bc921d66?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
    ),
  ];

  // Ruta entre puntos
  final List<ll.LatLng> _routePoints = [
    ll.LatLng(19.4326, -99.1332), // Zócalo
    ll.LatLng(19.4352, -99.1413), // Bellas Artes
    ll.LatLng(19.4260, -99.1862), // Museo de Antropología
    ll.LatLng(19.4323, -99.1943), // Pujol
  ];

  // Promociones y destacados
  final List<Map<String, dynamic>> _promos = [
    {
      'title': 'Recorrido por el Centro Histórico',
      'subtitle': 'Descuento del 15% en tours culturales',
      'imageUrl': 'https://images.unsplash.com/photo-1518214598173-1666bc921d66?ixlib=rb-1.2.1&auto=format&fit=crop&w=1200&q=80',
      'color': const Color(0xFF4A6CF7),
    },
    {
      'title': 'Experiencia Gastronómica',
      'subtitle': 'Los mejores restaurantes locales',
      'imageUrl': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1200&q=80',
      'color': const Color(0xFF4A6CF7),
    },
    {
      'title': 'Artesanías Típicas',
      'subtitle': 'Compra directa a artesanos locales',
      'imageUrl': 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?ixlib=rb-1.2.1&auto=format&fit=crop&w=1200&q=80',
      'color': const Color(0xFF4A6CF7),
    },
  ];

  // Categorías de servicios
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Restaurantes',
      'imageUrl': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      'color': Colors.blueGrey[800]!,
    },
    {
      'name': 'Tours',
      'imageUrl': 'https://images.unsplash.com/photo-1569369926169-9ee2f4d8b5c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      'color': Colors.blueGrey[800]!,
    },
    {
      'name': 'Bares',
      'imageUrl': 'https://images.unsplash.com/photo-1543007631-283050bb3e8c?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      'color': Colors.blueGrey[800]!,
    },
    {
      'name': 'Artesanías',
      'imageUrl': 'https://images.unsplash.com/photo-1513735718075-2e2d37cb7cc1?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
      'color': Colors.blueGrey[800]!,
    },
  ];

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 768;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con perfil y notificaciones
          _buildHeader(),
          
          // Carrusel de promociones
          _buildPromoCarousel(),
          
          // Opciones de pago
          _buildPaymentOptions(isTablet),
          
          // Mapa con lugares destacados
          _buildMapSection(),
          
          // Categorías de servicios
          _buildCategories(isTablet),
          
          // Recomendaciones personalizadas
          _buildRecommendations(),
          
          // Espacio inferior
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[500],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Bienvenido de vuelta!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Amado José',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      color: Colors.grey[700],
                      onPressed: () {},
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Barra de búsqueda
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Buscar experiencias, restaurantes, tours...',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Icon(
                    Icons.mic,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _promoController,
              itemCount: _promos.length,
              itemBuilder: (context, index) {
                final promo = _promos[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Imagen de fondo
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: promo['imageUrl'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey[500],
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        // Overlay oscuro
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Contenido
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promo['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  promo['subtitle'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SmoothPageIndicator(
              controller: _promoController,
              count: _promos.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.blue[600]!,
                dotColor: Colors.grey[300]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions(bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Opciones de Pago',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                ),
                child: const Row(
                  children: [
                    Text(
                      'Ver todas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isTablet ? 3 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              // Pago Estándar
              _buildPaymentCard(
                title: 'Pago Estándar',
                subtitle: 'Pago directo a comercio',
                imageUrl: 'https://images.unsplash.com/photo-1559589689-577aabd1db4f?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
                onTap: () => context.go('/payment'),
              ),
              
              // Split
              _buildPaymentCard(
                title: 'Split',
                subtitle: 'Divide gastos fácilmente',
                imageUrl: 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
                onTap: () => context.go('/split'),
              ),
              
              // Pago Grupal
              _buildPaymentCard(
                title: 'Pago Grupal',
                subtitle: 'Crea un grupo de pago',
                imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
                onTap: () => context.go('/group'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Imagen de fondo
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                  ),
                ),
              ),
              // Overlay de color
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Contenido
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Explora la Ciudad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              TextButton.icon(
                onPressed: () => context.go('/discover'),
                icon: const Icon(Icons.map_outlined, size: 16),
                label: const Text('Ver más'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Mapa
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: _center,
                      initialZoom: 13.0,
                      backgroundColor: Colors.grey[200]!,
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
                            color: Colors.blue[600]!.withOpacity(0.8),
                            strokeWidth: 3.0,
                            isDotted: true,
                          )
                        ],
                      ),
                      
                      // Puntos de interés
                      MarkerLayer(
                        markers: _points.map((point) {
                          return Marker(
                            point: point.location,
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            child: _MapMarker(
                              type: point.type,
                              imageUrl: point.imageUrl,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  
                  // Controles del mapa
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
    );
  }

  Widget _buildCategories(bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                ),
                child: const Row(
                  children: [
                    Text(
                      'Ver todas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              
              return InkWell(
                onTap: () => context.go('/discover'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        // Imagen de fondo
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: category['imageUrl'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey[200]),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.broken_image, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        
                        // Overlay de color
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                        
                        // Nombre de la categoría
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Text(
                            category['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recomendados para ti',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[600],
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver más',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _points.length,
            itemBuilder: (context, index) {
              final place = _points[index];
              return Container(
                width: 160,
                margin: EdgeInsets.only(
                  right: index < _points.length - 1 ? 10 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: place.imageUrl,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: SizedBox(
                              width: 20, 
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 100,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tipo de lugar
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(place.type).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getTypeColor(place.type).withOpacity(0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              _getTypeText(place.type),
                              style: TextStyle(
                                fontSize: 9,
                                color: _getTypeColor(place.type),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Nombre del lugar
                          Text(
                            place.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey[900],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Rating
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber[700],
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${4.0 + (index * 0.2).clamp(0, 1)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '(${121 + index * 34})',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Color _getTypeColor(String type) {
  switch(type) {
    case 'restaurant':
      return Colors.amber[700]!;
    case 'cultural':
      return Colors.teal[700]!;
    case 'shopping':
      return Colors.purple[700]!;
    case 'landmark':
      return Colors.blue[700]!;
    default:
      return Colors.blue[600]!;
  }
}

String _getTypeText(String type) {
  switch(type) {
    case 'restaurant':
      return 'Restaurante';
    case 'cultural':
      return 'Cultural';
    case 'shopping':
      return 'Compras';
    case 'landmark':
      return 'Monumento';
    default:
      return 'Lugar';
  }
}

  Widget _buildTypeTag(String type) {
    Color tagColor;
    String tagText;
    
    switch(type) {
      case 'restaurant':
        tagColor = Colors.amber[700]!;
        tagText = 'Restaurante';
        break;
      case 'cultural':
        tagColor = Colors.teal[700]!;
        tagText = 'Cultural';
        break;
      case 'shopping':
        tagColor = Colors.purple[700]!;
        tagText = 'Compras';
        break;
      case 'landmark':
        tagColor = Colors.blue[700]!;
        tagText = 'Monumento';
        break;
      default:
        tagColor = Colors.blue[600]!;
        tagText = 'Lugar';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: tagColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        tagText,
        style: TextStyle(
          color: tagColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PointOfInterest {
  final String name;
  final ll.LatLng location;
  final String type; // cultural, restaurant, shopping, landmark
  final String imageUrl;

  _PointOfInterest({
    required this.name,
    required this.location,
    required this.type,
    required this.imageUrl,
  });
}

class _MapMarker extends StatelessWidget {
  final String type;
  final String imageUrl;
  
  const _MapMarker({required this.type, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    Color markerColor;
    
    switch(type) {
      case 'restaurant':
        markerColor = Colors.amber[700]!;
        break;
      case 'cultural':
        markerColor = Colors.teal[700]!;
        break;
      case 'shopping':
        markerColor = Colors.purple[700]!;
        break;
      case 'landmark':
        markerColor = Colors.blue[700]!;
        break;
      default:
        markerColor = Colors.blue[600]!;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: markerColor,
            child: const Center(
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: markerColor,
            child: const Icon(
              Icons.place,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
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
        color: Colors.grey[700],
        padding: EdgeInsets.zero,
      ),
    );
  }
}