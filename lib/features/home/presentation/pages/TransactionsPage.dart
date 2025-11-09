import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/config/theme.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = 'Todo';
  String selectedStatus = 'Todos';
  
  // Datos simulados
  final List<Map<String, dynamic>> transactions = [
    {
      'id': 'TX-9384756',
      'type': 'split',
      'title': 'Split Cena Restaurante El Jardín',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
      'amount': 245.50,
      'currency': 'MXN',
      'status': 'completed',
      'participants': [
        {'name': 'Carlos Méndez', 'amount': 98.20, 'status': 'completed', 'avatar': 'CM'},
        {'name': 'María Gómez', 'amount': 73.65, 'status': 'completed', 'avatar': 'MG'},
        {'name': 'Tú', 'amount': 73.65, 'status': 'completed', 'avatar': 'TU'},
      ],
      'merchant': {'name': 'Restaurante El Jardín', 'logo': 'RJ'}
    },
    {
      'id': 'TX-7651234',
      'type': 'group',
      'title': 'Pago Grupal Tour Teotihuacán',
      'date': DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      'amount': 1250.00,
      'currency': 'USD',
      'status': 'completed',
      'participants': [
        {'name': 'Laura Torres', 'amount': 312.50, 'status': 'completed', 'avatar': 'LT'},
        {'name': 'Roberto Díaz', 'amount': 312.50, 'status': 'completed', 'avatar': 'RD'},
        {'name': 'Ana Vargas', 'amount': 312.50, 'status': 'pending', 'avatar': 'AV'},
        {'name': 'Tú', 'amount': 312.50, 'status': 'completed', 'avatar': 'TU'},
      ],
      'merchant': {'name': 'Aventuras México', 'logo': 'AM'}
    },
    {
      'id': 'TX-6543217',
      'type': 'standard',
      'title': 'Artesanías Oaxaqueñas',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'amount': 1850.75,
      'currency': 'MXN',
      'status': 'completed',
      'merchant': {'name': 'Tienda Oaxaca', 'logo': 'TO'}
    },
    {
      'id': 'TX-5431287',
      'type': 'split',
      'title': 'Split Alojamiento Casa Maya',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'amount': 4500.00,
      'currency': 'MXN',
      'status': 'pending',
      'participants': [
        {'name': 'Juan Pérez', 'amount': 1500.00, 'status': 'completed', 'avatar': 'JP'},
        {'name': 'Sofía Ruiz', 'amount': 1500.00, 'status': 'pending', 'avatar': 'SR'},
        {'name': 'Tú', 'amount': 1500.00, 'status': 'completed', 'avatar': 'TU'},
      ],
      'merchant': {'name': 'Casa Maya', 'logo': 'CM'}
    },
    {
      'id': 'TX-4328765',
      'type': 'standard',
      'title': 'Clase de Cocina Mexicana',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'amount': 85.00,
      'currency': 'EUR',
      'status': 'completed',
      'merchant': {'name': 'Sabores de México', 'logo': 'SM'}
    },
    {
      'id': 'TX-3217659',
      'type': 'group',
      'title': 'Pago Grupal Museo Frida Kahlo',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'amount': 1200.00,
      'currency': 'MXN',
      'status': 'pending',
      'participants': [
        {'name': 'Eduardo Vega', 'amount': 240.00, 'status': 'completed', 'avatar': 'EV'},
        {'name': 'Patricia López', 'amount': 240.00, 'status': 'completed', 'avatar': 'PL'},
        {'name': 'Daniel Moreno', 'amount': 240.00, 'status': 'pending', 'avatar': 'DM'},
        {'name': 'Gabriela Soto', 'amount': 240.00, 'status': 'pending', 'avatar': 'GS'},
        {'name': 'Tú', 'amount': 240.00, 'status': 'completed', 'avatar': 'TU'},
      ],
      'merchant': {'name': 'Museo Frida Kahlo', 'logo': 'FK'}
    },
    {
      'id': 'TX-2196543',
      'type': 'split',
      'title': 'Split Taxi Aeropuerto-Hotel',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'amount': 350.00,
      'currency': 'MXN',
      'status': 'completed',
      'participants': [
        {'name': 'Miguel Torres', 'amount': 175.00, 'status': 'completed', 'avatar': 'MT'},
        {'name': 'Tú', 'amount': 175.00, 'status': 'completed', 'avatar': 'TU'},
      ],
      'merchant': {'name': 'Taxi Ejecutivo CDMX', 'logo': 'TX'}
    },
    {
      'id': 'TX-1765432',
      'type': 'standard',
      'title': 'Souvenirs Plaza Mayor',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'amount': 562.50,
      'currency': 'ARS',
      'status': 'completed',
      'merchant': {'name': 'Tienda Recuerdos', 'logo': 'TR'}
    },
  ];

  // Estadísticas
  final Map<String, dynamic> statistics = {
    'totalSpent': 8550.75,
    'totalTransactions': 8,
    'pendingAmount': 1740.00,
    'monthlySpending': [2100.50, 1450.75, 3200.25, 1800.25, 4200.50, 3800.75, 8550.75],
    'paymentMethods': [
      {'name': 'Split', 'percentage': 45},
      {'name': 'Grupo', 'percentage': 30},
      {'name': 'Estándar', 'percentage': 25},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount, String currency) {
    switch (currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)} USD';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)} EUR';
      case 'MXN':
        return '\$${amount.toStringAsFixed(2)} MXN';
      case 'ARS':
        return '\$${amount.toStringAsFixed(2)} ARS';
      default:
        return '${amount.toStringAsFixed(2)} $currency';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes} minutos';
      }
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppTheme.success;
      case 'pending':
        return AppTheme.pending;
      case 'failed':
        return AppTheme.error;
      default:
        return AppTheme.darkGray;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completado';
      case 'pending':
        return 'Pendiente';
      case 'failed':
        return 'Fallido';
      default:
        return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

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
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 24,
                            color: AppTheme.primaryBlue,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Historial de Transacciones',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 36),
                        child: Text(
                          'Visualiza y gestiona todos tus pagos',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Botón de exportar
                  if (isTablet)
                    OutlinedButton.icon(
                      onPressed: () {
                        // Acción para exportar
                      },
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Exportar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textDark,
                        side: BorderSide(color: AppTheme.mediumGray),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                ],
              ),
            ),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: AppTheme.mediumGray, width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryBlue,
                unselectedLabelColor: AppTheme.darkGray,
                indicatorColor: AppTheme.primaryBlue,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Todas'),
                  Tab(text: 'Enviadas'),
                  Tab(text: 'Recibidas'),
                ],
              ),
            ),

            // Contenido principal (scrollable)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Todas las transacciones
                  _buildAllTransactionsTab(isTablet),
                  
                  // Tab 2: Transacciones enviadas
                  _buildTransactionsList(transactions.where((t) => 
                    t['type'] == 'standard' || 
                    (t['type'] == 'split' && t['participants'][t['participants'].length - 1]['name'] == 'Tú') ||
                    (t['type'] == 'group' && t['participants'][t['participants'].length - 1]['name'] == 'Tú')
                  ).toList()),
                  
                  // Tab 3: Transacciones recibidas
                  _buildTransactionsList(transactions.where((t) => 
                    t['type'] == 'split' || t['type'] == 'group'
                  ).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllTransactionsTab(bool isTablet) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtros y estadísticas (para tablets y desktop)
          if (isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard de estadísticas
                Expanded(
                  flex: 2,
                  child: _buildStatisticsDashboard(),
                ),
                const SizedBox(width: 20),
                // Filtros
                Expanded(
                  child: _buildFiltersPanel(),
                ),
              ],
            )
          else
            Column(
              children: [
                // Dashboard de estadísticas móvil
                _buildStatisticsDashboard(),
                const SizedBox(height: 20),
                // Filtros móvil
                _buildFiltersPanel(),
              ],
            ),
          
          const SizedBox(height: 24),
          
          // Lista de transacciones
          _buildTransactionsList(transactions),
        ],
      ),
    );
  }

  Widget _buildStatisticsDashboard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Resumen de Gastos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 20),
          
          // Métricas principales
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Total Gastado',
                  value: _formatCurrency(statistics['totalSpent'], 'MXN'),
                  iconColor: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.receipt,
                  title: 'Transacciones',
                  value: statistics['totalTransactions'].toString(),
                  iconColor: AppTheme.darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.schedule,
                  title: 'Pagos Pendientes',
                  value: _formatCurrency(statistics['pendingAmount'], 'MXN'),
                  iconColor: AppTheme.pending,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.verified,
                  title: 'Tasa de Completado',
                  value: '87%',
                  iconColor: AppTheme.success,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Gráfico de gastos
          Container(
            height: 200,
            padding: const EdgeInsets.only(top: 20),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            labels[value.toInt()],
                            style: TextStyle(
                              color: AppTheme.darkGray,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: statistics['monthlySpending'].asMap().entries.map<BarChartGroupData>((entry) {
                  final value = entry.value;
                  final color = entry.key == statistics['monthlySpending'].length - 1 
                    ? AppTheme.primaryBlue 
                    : AppTheme.lightBlue;
                  
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: value / 1000, // Normalizar para visualización
                        color: color,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Gráfico circular de métodos de pago
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Gráfico simplificado
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  value: statistics['paymentMethods'][0]['percentage'] / 100,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: 34,
                                height: 34,
                                child: CircularProgressIndicator(
                                  value: statistics['paymentMethods'][1]['percentage'] / 100,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.darkBlue),
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  value: statistics['paymentMethods'][2]['percentage'] / 100,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.success),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Leyenda
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Métodos de pago',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildLegendItem(
                              color: AppTheme.primaryBlue,
                              label: 'Split',
                              value: '${statistics['paymentMethods'][0]['percentage']}%',
                            ),
                            const SizedBox(height: 4),
                            _buildLegendItem(
                              color: AppTheme.darkBlue,
                              label: 'Grupo',
                              value: '${statistics['paymentMethods'][1]['percentage']}%',
                            ),
                            const SizedBox(height: 4),
                            _buildLegendItem(
                              color: AppTheme.success,
                              label: 'Estándar',
                              value: '${statistics['paymentMethods'][2]['percentage']}%',
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
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.darkGray,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
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
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Filtros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          
          // Filtro por período
          Text(
            'Período',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Todo', 'Hoy', 'Semana', 'Mes', 'Año'].map((period) {
              final isSelected = period == selectedPeriod;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPeriod = period;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
                    ),
                  ),
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.white : AppTheme.darkGray,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Filtro por estado
          Text(
            'Estado',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Todos', 'Completados', 'Pendientes'].map((status) {
              final isSelected = status == selectedStatus;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStatus = status;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.white : AppTheme.darkGray,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Búsqueda
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar transacción',
              prefixIcon: Icon(
                Icons.search,
                color: AppTheme.darkGray,
              ),
              filled: true,
              fillColor: AppTheme.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Exportar (solo para móvil)
          if (MediaQuery.of(context).size.width <= 768)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Acción para exportar
                },
                icon: const Icon(Icons.download_outlined),
                label: const Text('Exportar Transacciones'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textDark,
                  side: BorderSide(color: AppTheme.mediumGray),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: AppTheme.mediumGray,
              ),
              const SizedBox(height: 16),
              Text(
                'No hay transacciones disponibles',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Intenta cambiar los filtros o realizar un pago',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.darkGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final transaction = items[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    // Determinar el tipo de transacción e icono
    IconData transactionIcon;
    Color iconBgColor;
    
    switch (transaction['type']) {
      case 'split':
        transactionIcon = Icons.call_split;
        iconBgColor = AppTheme.primaryBlue;
        break;
      case 'group':
        transactionIcon = Icons.group;
        iconBgColor = AppTheme.darkBlue;
        break;
      case 'standard':
        transactionIcon = Icons.payments_outlined;
        iconBgColor = AppTheme.success;
        break;
      default:
        transactionIcon = Icons.receipt;
        iconBgColor = AppTheme.darkGray;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBgColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            transactionIcon,
            color: iconBgColor,
            size: 24,
          ),
        ),
        title: Text(
          transaction['title'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(transaction['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _getStatusText(transaction['status']),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(transaction['status']),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatDate(transaction['date']),
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.darkGray,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatCurrency(transaction['amount'], transaction['currency']),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              transaction['id'],
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.darkGray,
              ),
            ),
          ],
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.topLeft,
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          const Divider(),
          const SizedBox(height: 8),
          
          // Si es split o grupo, mostrar participantes
          if (transaction['type'] == 'split' || transaction['type'] == 'group')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Participantes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transaction['participants'].length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final participant = transaction['participants'][index];
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: participant['name'] == 'Tú'
                            ? AppTheme.lightBlue
                            : AppTheme.lightGray,
                          child: Text(
                            participant['avatar'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: participant['name'] == 'Tú'
                                ? AppTheme.primaryBlue
                                : AppTheme.darkGray,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            participant['name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: participant['name'] == 'Tú'
                                ? FontWeight.w600
                                : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          _formatCurrency(participant['amount'], transaction['currency']),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(participant['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _getStatusText(participant['status']),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(participant['status']),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          
          // Información del comerciante
          Row(
            children: [
              Text(
                'Comerciante:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 12,
                backgroundColor: AppTheme.lightGray,
                child: Text(
                  transaction['merchant']['logo'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                transaction['merchant']['name'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Botones de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Acción para ver detalles
                },
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('Ver Detalles'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textDark,
                  side: BorderSide(color: AppTheme.mediumGray),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(0, 36),
                ),
              ),
              const SizedBox(width: 12),
              if (transaction['status'] == 'pending')
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción para pagar
                  },
                  icon: const Icon(Icons.payment, size: 16),
                  label: const Text('Pagar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(0, 36),
                  ),
                ),
              if (transaction['status'] == 'completed')
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción para descargar recibo
                  },
                  icon: const Icon(Icons.receipt_long, size: 16),
                  label: const Text('Recibo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(0, 36),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}