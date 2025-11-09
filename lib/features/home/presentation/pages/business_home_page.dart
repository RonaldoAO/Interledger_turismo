import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/config/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BusinessHomePage extends StatefulWidget {
  const BusinessHomePage({super.key});

  @override
  State<BusinessHomePage> createState() => _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  final currencyFormat = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
  final List<double> weeklyData = [850, 1200, 1550, 1100, 1750, 2100, 1450];
  String selectedPeriod = 'Hoy';
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 768;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con nombre del negocio
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.success.withOpacity(0.1),
                    child: Text(
                      'MT',
                      style: TextStyle(
                        color: AppTheme.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Buenos días!',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const Text(
                        'Mi Tienda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
            
            // Periodo selector
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _PeriodChip(
                    label: 'Hoy',
                    isSelected: selectedPeriod == 'Hoy',
                    onTap: () {
                      setState(() {
                        selectedPeriod = 'Hoy';
                      });
                    },
                  ),
                  _PeriodChip(
                    label: 'Semana',
                    isSelected: selectedPeriod == 'Semana',
                    onTap: () {
                      setState(() {
                        selectedPeriod = 'Semana';
                      });
                    },
                  ),
                  _PeriodChip(
                    label: 'Mes',
                    isSelected: selectedPeriod == 'Mes',
                    onTap: () {
                      setState(() {
                        selectedPeriod = 'Mes';
                      });
                    },
                  ),
                  _PeriodChip(
                    label: 'Año',
                    isSelected: selectedPeriod == 'Año',
                    onTap: () {
                      setState(() {
                        selectedPeriod = 'Año';
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            
            // Resumen de ventas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue,
                    AppTheme.darkBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ventas totales',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '+12.5%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '\$12,450 MXN',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '≈ \$645 USD',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Mini gráfico
                  SizedBox(
                    height: 60,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData:  FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: weeklyData.asMap().entries.map((e) {
                              return FlSpot(e.key.toDouble(), e.value);
                            }).toList(),
                            isCurved: true,
                            color: Colors.white,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData:  FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ],
                        minY: 0,
                        lineTouchData:  LineTouchData(enabled: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Estadísticas rápidas
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Transacciones',
                    value: '45',
                    trend: '+8%',
                    trendPositive: true,
                    icon: Icons.receipt,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Ticket promedio',
                    value: '\$276.67',
                    trend: '+5.2%',
                    trendPositive: true,
                    icon: Icons.point_of_sale,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Acciones rápidas
            Text(
              'Acciones rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _ActionButton(
                  label: 'Split de Pago',
                  icon: Icons.call_split,
                  color: AppTheme.primaryBlue,
                  onTap: () => context.go('/split'),
                ),
                _ActionButton(
                  label: 'Pago Grupal',
                  icon: Icons.group_add,
                  color: AppTheme.darkBlue,
                  onTap: () => context.go('/group'),
                ),
                _ActionButton(
                  label: 'Conversor',
                  icon: Icons.currency_exchange,
                  color: const Color(0xFF7269EF),
                  onTap: () => context.go('/conversor'),
                ),
                _ActionButton(
                  label: 'Historial',
                  icon: Icons.history,
                  color: const Color(0xFF00A86B),
                  onTap: () => context.go('/history'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Transacciones recientes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transacciones recientes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/history'),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Ver todas'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _TransactionItem(
              customerName: 'Carlos Méndez',
              amount: 210,
              status: 'Completado',
              time: 'Hace 15 min',
              statusColor: AppTheme.success,
            ),
            _TransactionItem(
              customerName: 'María Gómez',
              amount: 345,
              status: 'Completado',
              time: 'Hace 1 hora',
              statusColor: AppTheme.success,
            ),
            _TransactionItem(
              customerName: 'Juan Pérez',
              amount: 520,
              status: 'Pendiente',
              time: 'Hace 2 horas',
              statusColor: AppTheme.pending,
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppTheme.darkGray,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final bool trendPositive;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.trendPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.darkGray,
              size: 24,
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      trendPositive
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 12,
                      color: trendPositive
                          ? AppTheme.success
                          : AppTheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: trendPositive
                            ? AppTheme.success
                            : AppTheme.error,
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
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
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
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String customerName;
  final int amount;
  final String status;
  final String time;
  final Color statusColor;

  const _TransactionItem({
    required this.customerName,
    required this.amount,
    required this.status,
    required this.time,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final initial = customerName.isNotEmpty ? customerName[0] : '';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.lightBlue,
            child: Text(
              initial,
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${amount.toString()} MXN',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}