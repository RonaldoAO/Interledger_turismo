import 'package:flutter/material.dart';
import '../../../../app/config/theme.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String _selectedCategory = 'Todos';
  String _selectedSort = 'Distancia';

  final List<String> _categories = [
    'Todos',
    'Restaurantes',
    'Tours',
    'Bares',
    'Souvenirs',
  ];

  final List<Map<String, dynamic>> _places = [
    {
      'name': 'La Cocina del Puerto',
      'category': 'Restaurante',
      'rating': 4.8,
      'reviews': 342,
      'distance': 0.5,
      'price': 250,
      'image': '🍽️',
      'color': Color(0xFFFF6B6B),
    },
    {
      'name': 'Tour Centro Histórico',
      'category': 'Tour',
      'rating': 4.9,
      'reviews': 189,
      'distance': 1.2,
      'price': 400,
      'image': '🏛️',
      'color': Color(0xFF4ECDC4),
    },
    {
      'name': 'Artesanías Mexicanas',
      'category': 'Souvenirs',
      'rating': 4.6,
      'reviews': 156,
      'distance': 0.8,
      'price': 150,
      'image': '🎨',
      'color': Color(0xFF95E1D3),
    },
    {
      'name': 'Bar La Terraza',
      'category': 'Bar',
      'rating': 4.7,
      'reviews': 273,
      'distance': 1.5,
      'price': 180,
      'image': '🍹',
      'color': Color(0xFFFFBE0B),
    },
  ];

  List<Map<String, dynamic>> get _filteredPlaces {
    var filtered = _places;
    
    if (_selectedCategory != 'Todos') {
      filtered = filtered
          .where((place) => place['category'] == _selectedCategory)
          .toList();
    }

    if (_selectedSort == 'Distancia') {
      filtered.sort((a, b) => a['distance'].compareTo(b['distance']));
    } else if (_selectedSort == 'Rating') {
      filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
    } else if (_selectedSort == 'Precio') {
      filtered.sort((a, b) => a['price'].compareTo(b['price']));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar lugares, restaurantes, tours...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppTheme.lightGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: _showFilterSheet,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.map_outlined),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Categorías horizontales
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: AppTheme.lightGray,
                    selectedColor: AppTheme.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Lista de lugares
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = _filteredPlaces[index];
                return _PlaceCard(place: place);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ordenar por',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<String>(
                    title: const Text('Distancia'),
                    value: 'Distancia',
                    groupValue: _selectedSort,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (value) {
                      setModalState(() => _selectedSort = value!);
                      setState(() => _selectedSort = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Rating'),
                    value: 'Rating',
                    groupValue: _selectedSort,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (value) {
                      setModalState(() => _selectedSort = value!);
                      setState(() => _selectedSort = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Precio'),
                    value: 'Precio',
                    groupValue: _selectedSort,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (value) {
                      setModalState(() => _selectedSort = value!);
                      setState(() => _selectedSort = value!);
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Map<String, dynamic> place;

  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navegar a detalles
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Imagen
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: place['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    place['image'],
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: AppTheme.pending,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${place['rating']} (${place['reviews']})',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppTheme.darkGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${place['distance']} km',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Precio y botón
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${place['price']} MXN',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Ver detalles'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}