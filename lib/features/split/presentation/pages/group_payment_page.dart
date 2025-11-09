import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/config/theme.dart';
import '../../data/models/group_checkout_request.dart';
import '../providers/split_provider.dart';

class GroupPaymentPage extends ConsumerStatefulWidget {
  const GroupPaymentPage({super.key});

  @override
  ConsumerState<GroupPaymentPage> createState() => _GroupPaymentPageState();
}

class _GroupPaymentPageState extends ConsumerState<GroupPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _merchantAddressController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final List<TextEditingController> _payerControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  bool _isLoading = false;
  GroupCheckoutResponse? _groupResponse;

  @override
  void dispose() {
    _merchantAddressController.dispose();
    _totalAmountController.dispose();
    for (var controller in _payerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPayer() {
    setState(() {
      _payerControllers.add(TextEditingController());
    });
  }

  void _removePayer(int index) {
    if (_payerControllers.length > 2) {
      setState(() {
        _payerControllers[index].dispose();
        _payerControllers.removeAt(index);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final totalAmount = double.parse(_totalAmountController.text);
      final totalAmountMinor = (totalAmount * 100).toInt();

      final payers = _payerControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (payers.isEmpty) {
        throw Exception('Debes agregar al menos un pagador');
      }

      final request = GroupCheckoutRequest(
        merchantAddress: _merchantAddressController.text.trim(),
        totalAmountMinor: totalAmountMinor,
        payers: payers,
      );

      final repository = ref.read(splitRepositoryProvider);
      final response = await repository.createGroupCheckout(request);

      setState(() {
        _groupResponse = response;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Grupo de pago creado exitosamente'),
                ),
              ],
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Error: $e'),
                ),
              ],
            ),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _launchPaymentUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 768;
    
    if (_groupResponse != null) {
      return _buildGroupResults(isTablet);
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                const Row(
                  children: [
                    Icon(
                      Icons.group_rounded,
                      size: 24,
                      color: AppTheme.primaryBlue,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Pago en Grupo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Divide gastos con amigos o colegas fácilmente',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Contenido principal
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        'Detalles del Pago Grupal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Dirección del comerciante
                      Text(
                        'Dirección del Comerciante',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _merchantAddressController,
                        decoration: InputDecoration(
                          hintText: 'Ej: \$wallet.negocio.ejemplo',
                          prefixIcon: Icon(
                            Icons.store_outlined,
                            color: AppTheme.darkGray,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppTheme.mediumGray),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa la dirección del comerciante';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Monto total
                      Text(
                        'Monto Total (MXN)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _totalAmountController,
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: AppTheme.darkGray,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppTheme.mediumGray),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el monto total';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Ingresa un monto válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      // Lista de pagadores
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Miembros del grupo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _addPayer,
                            icon: const Icon(Icons.add_circle_outline, size: 16),
                            label: const Text('Agregar'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Lista de miembros con layout responsivo
                      if (isTablet) ...[
                        // Layout para tablet (grid)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _payerControllers.length,
                          itemBuilder: (context, index) {
                            return _buildPayerField(index);
                          },
                        ),
                      ] else ...[
                        // Layout para móvil (columna)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _payerControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildPayerField(index),
                            );
                          },
                        ),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Resumen del reparto
                      if (_totalAmountController.text.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Monto total',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '\$${_totalAmountController.text} MXN',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Por persona (${_payerControllers.length})',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.darkGray,
                                    ),
                                  ),
                                  Text(
                                    '\$${_getAmountPerPerson()} MXN',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Botón de envío
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Crear Grupo de Pago',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPayerField(int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _payerControllers[index],
            decoration: InputDecoration(
              labelText: 'Pagador ${index + 1}',
              hintText: 'Ej: \$wallet.usuario${index + 1}.ejemplo',
              prefixIcon: Icon(
                Icons.person_outline,
                color: AppTheme.darkGray,
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.mediumGray),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa la dirección del pagador';
              }
              return null;
            },
          ),
        ),
        if (_payerControllers.length > 2)
          IconButton(
            onPressed: () => _removePayer(index),
            icon: const Icon(Icons.remove_circle_outline),
            color: Colors.red,
            tooltip: 'Eliminar pagador',
          ),
      ],
    );
  }
  
  String _getAmountPerPerson() {
    if (_totalAmountController.text.isEmpty || _payerControllers.isEmpty) {
      return '0.00';
    }
    try {
      final totalAmount = double.parse(_totalAmountController.text);
      final amountPerPerson = totalAmount / _payerControllers.length;
      return amountPerPerson.toStringAsFixed(2);
    } catch (_) {
      return '0.00';
    }
  }

  Widget _buildGroupResults(bool isTablet) {
    final response = _groupResponse!;
    final totalAmount = response.totalMinor / 100;
    final sharePerPerson = totalAmount / response.count;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _groupResponse = null;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.lightGray,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Grupo Creado',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Ilustración de éxito
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: AppTheme.success,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '¡Pago grupal creado con éxito!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.success,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Cada miembro debe completar su parte del pago',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Resumen
              Container(
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total a dividir',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        Text(
                          '${totalAmount.toStringAsFixed(2)} MXN',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Por persona',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${sharePerPerson.toStringAsFixed(2)} MXN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Miembros del grupo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 16),

              // Grid o lista de miembros según el tamaño de pantalla
              if (isTablet) ...[
                // Grid para tablet
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: response.results.length,
                  itemBuilder: (context, index) {
                    final result = response.results[index];
                    return _buildMemberCard(result);
                  },
                ),
              ] else ...[
                // Lista para móvil
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: response.results.length,
                  itemBuilder: (context, index) {
                    final result = response.results[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMemberCard(result),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMemberCard(result) {
    final share = result.shareMinor / 100;
    final initial = result.payer.isNotEmpty ? result.payer[0].toUpperCase() : '';
    
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
          CircleAvatar(
            backgroundColor: AppTheme.lightBlue,
            radius: 20,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  result.payer,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${share.toStringAsFixed(2)} MXN',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _launchPaymentUrl(result.redirectUrl),
            icon: const Icon(Icons.payments_outlined, size: 16),
            label: const Text('Pagar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              minimumSize: const Size(80, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}