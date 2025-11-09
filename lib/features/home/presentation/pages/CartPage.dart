import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/config/theme.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final selectedCurrency = 'USD';
  
  // Datos simulados de productos
  final products = [
    {
      'name': 'Tour Gastronómico Centro Histórico',
      'description': 'Recorrido de 3 horas por los mejores restaurantes locales con degustaciones',
      'image': 'assets/images/tour_gastronomico.jpg',
      'price': 45.00,
      'quantity': 2,
      'currency': 'US\$',
      'total': 90.00,
      'category': 'Tours Gastronómicos',
      'tag': 'Sabores Locales',
      'tagColor': Color(0xFF00C853),
    },
    {
      'name': 'Artesanías Tradicionales',
      'description': 'Conjunto de artesanías hechas a mano por artistas locales, incluye cerámica y textiles',
      'image': 'assets/images/artesanias.jpg',
      'price': 850.00,
      'quantity': 1,
      'currency': 'US\$',
      'total': 850.00,
      'category': 'Artesanías',
      'tag': 'Arte y Tradición',
      'tagColor': Color(0xFF7269EF),
    },
    {
      'name': 'Clase de Cocina Tradicional',
      'description': 'Aprende a preparar platos típicos de la región con chef local, incluye ingredientes',
      'image': 'assets/images/clase_cocina.jpg',
      'price': 2100.00,
      'quantity': 1,
      'currency': 'US\$',
      'total': 2100.00,
      'category': 'Clases',
      'tag': 'Cocina Ancestral',
      'tagColor': Color(0xFF00A86B),
    },
  ];
  
  // Datos de resumen
  final summaryData = {
    'subtotal': 3125.50,
    'discounts': -312.55,
    'tax': 450.07,
    'serviceFee': 84.39,
    'total': 3347.41,
    'productCount': 4,
    'discountCount': 1,
    'processingTime': '2-5 minutos',
  };

  // Monedas disponibles
  final currencies = [
    {'code': 'USD', 'symbol': '\$', 'region': 'US'},
    {'code': 'EUR', 'symbol': '€', 'region': 'EU'},
    {'code': 'MXN', 'symbol': '\$', 'region': 'MX'},
    {'code': 'COP', 'symbol': '\$', 'region': 'CO'},
    {'code': 'ARS', 'symbol': '\$', 'region': 'AR'},
    {'code': 'BRL', 'symbol': 'R\$', 'region': 'BR'},
  ];

  void _decrementQuantity(int index) {
    setState(() {
      final quantity = products[index]['quantity'] as int? ?? 1;
      final price = products[index]['price'] as num? ?? 0;
      if (quantity > 1) {
        products[index]['quantity'] = quantity - 1;
        products[index]['total'] = price * (quantity - 1);
      }
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      final quantity = products[index]['quantity'] as int? ?? 1;
      final price = products[index]['price'] as num? ?? 0;
      products[index]['quantity'] = quantity + 1;
      products[index]['total'] = price * (quantity + 1);
    });
  }

  void _removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 768;

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carrito de Compras',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Revisa tus selecciones y configura las opciones de pago',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkGray,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Botón de vaciar carrito
                      TextButton.icon(
                        onPressed: () {
                          // Vaciar carrito
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red[400],
                          size: 18,
                        ),
                        label: Text(
                          'Vaciar Carrito',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12, 
                            vertical: 8
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Botón de seguir comprando
                      OutlinedButton.icon(
                        onPressed: () {
                          context.go('/client');
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 18,
                        ),
                        label: const Text('Seguir Comprando'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textDark,
                          side: BorderSide(color: AppTheme.mediumGray),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12, 
                            vertical: 8
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Contenido principal (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Layout responsivo
                      if (isTablet)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Columna izquierda (selector de moneda y productos)
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCurrencySelector(),
                                  const SizedBox(height: 20),
                                  _buildProductList(context),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Columna derecha (resumen)
                            Expanded(
                              flex: 2,
                              child: _buildOrderSummary(context),
                            ),
                          ],
                        )
                      else
                        // Layout para móvil (una columna)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCurrencySelector(),
                            const SizedBox(height: 20),
                            _buildProductList(context),
                            const SizedBox(height: 20),
                            _buildOrderSummary(context),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.currency_exchange,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(width: 10),
              Text(
                'Seleccionar Moneda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: currencies.map((currency) {
              final isSelected = currency['code'] == selectedCurrency;
              return InkWell(
                onTap: () {
                  // Cambiar moneda
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12, 
                    horizontal: 10
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.lightBlue : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                        ? AppTheme.primaryBlue 
                        : AppTheme.mediumGray,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? Colors.white
                            : AppTheme.lightGray,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          currency['region']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                              ? AppTheme.primaryBlue
                              : AppTheme.darkGray,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currency['code']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.textDark,
                              ),
                            ),
                            Text(
                              currency['symbol']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.darkGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppTheme.primaryBlue,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'Los precios se convierten automáticamente. Las tasas de cambio se actualizan en tiempo real.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.darkGray,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Productos Seleccionados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, 
                    vertical: 4
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${products.length} productos',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Header de la tabla en desktop
          if (MediaQuery.of(context).size.width > 768)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'PRODUCTO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'PRECIO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'CANTIDAD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 40), // Espacio para botón de acción
                ],
              ),
            ),
          
          // Lista de productos
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.lightGray,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              final screenWidth = MediaQuery.of(context).size.width;
              final isDesktop = screenWidth > 768;
              
              // Layout para desktop
              if (isDesktop) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Producto y descripción
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            // Imagen
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/placeholder.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Información
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    product['description'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.darkGray,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8, 
                                          vertical: 2
                                        ),
                                        decoration: BoxDecoration(
                                          color: (product['tagColor'] as Color)
                                            .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.place,
                                              size: 10,
                                              color: product['tagColor'] as Color,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              product['tag'] as String,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: product['tagColor'] as Color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8, 
                                          vertical: 2
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          product['category'] as String,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.darkGray,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Precio
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${product['price']} US\$',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      // Control de cantidad
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onPressed: () => _decrementQuantity(index),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12, 
                                vertical: 8
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.mediumGray,
                                ),
                              ),
                              child: Text(
                                '${product['quantity']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onPressed: () => _incrementQuantity(index),
                            ),
                          ],
                        ),
                      ),
                      
                      // Total
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${product['total']} US\$',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      // Botón para eliminar
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red[400],
                        onPressed: () => _removeProduct(index),
                      ),
                    ],
                  ),
                );
              } 
              // Layout para móvil
              else {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/placeholder.jpg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Información
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product['description'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.darkGray,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6, 
                                        vertical: 2
                                      ),
                                      decoration: BoxDecoration(
                                        color: (product['tagColor'] as Color)
                                          .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.place,
                                            size: 10,
                                            color: product['tagColor'] as Color,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            product['tag'] as String,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: product['tagColor'] as Color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6, 
                                        vertical: 2
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        product['category'] as String,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppTheme.darkGray,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red[400],
                            onPressed: () => _removeProduct(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Precio
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.darkGray,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product['price']} US\$',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Cantidad
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Cantidad',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.darkGray,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildQuantityButton(
                                    icon: Icons.remove,
                                    onPressed: () => _decrementQuantity(index),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12, 
                                      vertical: 6
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.mediumGray,
                                      ),
                                    ),
                                    child: Text(
                                      '${product['quantity']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  _buildQuantityButton(
                                    icon: Icons.add,
                                    onPressed: () => _incrementQuantity(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Total
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.darkGray,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product['total']} US\$',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.lightGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppTheme.darkGray,
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Row(
            children: [
              Icon(
                Icons.receipt_outlined,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'Resumen del Pedido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Subtotal
          _buildSummaryRow(
            icon: Icons.list_alt_outlined,
            label: 'Subtotal',
            value: '${summaryData['subtotal']} US\$',
            subtitle: '${summaryData['productCount']} productos',
          ),
          const SizedBox(height: 16),
          
          // Descuentos
          _buildSummaryRow(
            icon: Icons.discount_outlined,
            label: 'Descuentos',
            value: '${summaryData['discounts']} US\$',
            valueColor: Colors.green[600],
            subtitle: '${summaryData['discountCount']} aplicados',
          ),
          const SizedBox(height: 16),
          
          // IVA
          _buildSummaryRow(
            icon: Icons.receipt_long_outlined,
            label: 'IVA (16%)',
            value: '${summaryData['tax']} US\$',
            subtitle: 'Impuesto incluido',
          ),
          const SizedBox(height: 16),
          
          // Comisión de servicio
          _buildSummaryRow(
            icon: Icons.approval_outlined,
            label: 'Comisión de servicio (3%)',
            value: '${summaryData['serviceFee']} US\$',
            subtitle: 'Procesamiento',
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          
          // Total
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 24,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(width: 12),
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const Spacer(),
              Text(
                '${summaryData['total']} US\$',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Moneda seleccionada
          Row(
            children: [
              Icon(
                Icons.currency_exchange,
                size: 16,
                color: AppTheme.darkGray,
              ),
              const SizedBox(width: 8),
              Text(
                'Moneda seleccionada',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.darkGray,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, 
                  vertical: 4
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'USD',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Método de pago
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 10),
                Text(
                  'Pago seguro con OpenPayments',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Tiempo de procesamiento
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: AppTheme.darkGray,
              ),
              const SizedBox(width: 8),
              Text(
                'Procesamiento estimado: ${summaryData['processingTime']}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.darkGray,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Botones de opciones de pago
          Text(
            'Opciones de Pago',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          
          // Opción de pago estándar
          _buildPaymentOption(
            icon: Icons.credit_card,
            title: 'Pago Estándar',
            subtitle: 'Pago completo con un solo método de pago',
            isSelected: true,
            actionButton: ElevatedButton(
              onPressed: () {
                // Acción para pagar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Pagar Ahora'),
            ),
            additionalInfo: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppTheme.darkGray,
                ),
                const SizedBox(width: 4),
                Text(
                  'Inmediato',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 4),
                Text(
                  'Seguro',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Opción de pago dividido
          _buildPaymentOption(
            icon: Icons.people,
            title: 'Pago Dividido',
            subtitle: 'Divide el pago entre múltiples personas con porcentajes personalizados',
            isSelected: false,
            actionButton: OutlinedButton(
              onPressed: () {
                // Acción para configurar
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                side: BorderSide(color: AppTheme.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Configurar'),
            ),
            additionalInfo: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppTheme.darkGray,
                ),
                const SizedBox(width: 4),
                Text(
                  '2-5 minutos',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 4),
                Text(
                  'Seguro',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Opción de pago grupal
          _buildPaymentOption(
            icon: Icons.people_outline,
            title: 'Pago Grupal',
            subtitle: 'Múltiples personas pagan a un solo destinatario',
            isSelected: false,
            actionButton: OutlinedButton(
              onPressed: () {
                // Acción para configurar
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                side: BorderSide(color: AppTheme.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Configurar'),
            ),
            additionalInfo: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppTheme.darkGray,
                ),
                const SizedBox(width: 4),
                Text(
                  '5-10 minutos',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 4),
                Text(
                  'Seguro',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Métodos de pago aceptados
          Text(
            'Métodos de Pago Aceptados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPaymentMethodChip(
                icon: Icons.credit_card,
                label: 'Tarjetas',
              ),
              const SizedBox(width: 8),
              _buildPaymentMethodChip(
                icon: Icons.smartphone,
                label: 'Digital',
              ),
              const SizedBox(width: 8),
              _buildPaymentMethodChip(
                icon: Icons.account_balance,
                label: 'Bancario',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textDark,
                ),
              ),
              if (subtitle != null)
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
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required Widget actionButton,
    required Widget additionalInfo,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
            ? AppTheme.primaryBlue 
            : AppTheme.mediumGray,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? AppTheme.lightBlue
                    : AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected
                    ? AppTheme.primaryBlue
                    : AppTheme.darkGray,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
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
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              additionalInfo,
              actionButton,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12, 
        vertical: 8
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.darkGray,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}