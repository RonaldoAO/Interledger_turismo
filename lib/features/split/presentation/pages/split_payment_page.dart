import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/config/theme.dart';
import '../../data/models/split_checkout_request.dart';
import '../providers/split_provider.dart';

class SplitPaymentPage extends ConsumerStatefulWidget {
  const SplitPaymentPage({super.key});

  @override
  ConsumerState<SplitPaymentPage> createState() => _SplitPaymentPageState();
}

class _SplitPaymentPageState extends ConsumerState<SplitPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerAddressController = TextEditingController();
  final _merchantAddressController = TextEditingController();
  final _amountController = TextEditingController();
  int _merchantPct = 95;
  int _platformPct = 5;
  bool _isLoading = false;

  @override
  void dispose() {
    _customerAddressController.dispose();
    _merchantAddressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final amountMinor = (amount * 100).toInt();

      final request = SplitCheckoutRequest(
        customerAddress: _customerAddressController.text.trim(),
        merchantAddress: _merchantAddressController.text.trim(),
        amountMinor: amountMinor,
        split: SplitConfig(
          merchantPct: _merchantPct,
          platformPct: _platformPct,
        ),
      );

      final repository = ref.read(splitRepositoryProvider);
      final response = await repository.createSplitCheckout(request);

      // Abrir URL de redirección
      final uri = Uri.parse(response.redirectUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Procesando su pago...'),
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
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 768;

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
                      Icons.call_split_rounded,
                      size: 24,
                      color: AppTheme.primaryBlue,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Split de Pago',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Configura cómo dividir el pago entre el comerciante y la plataforma',
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
                        'Detalles del Pago',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Campos de formulario con layouts responsivos
                      if (isTablet) ...[
                        // Layout para tablets y desktop (2 columnas)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildCustomerAddressField(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMerchantAddressField(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildAmountField(),
                      ] else ...[
                        // Layout para móvil (1 columna)
                        _buildCustomerAddressField(),
                        const SizedBox(height: 16),
                        _buildMerchantAddressField(),
                        const SizedBox(height: 16),
                        _buildAmountField(),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Configuración de Split
                      Text(
                        'Distribución del pago',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Visualización de la distribución
                      Container(
                        height: 20,
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: _merchantPct,
                              child: Container(
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            Expanded(
                              flex: _platformPct,
                              child: Container(
                                color: AppTheme.darkBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Porcentaje Comerciante
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Comerciante',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$_merchantPct%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _merchantPct.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        activeColor: AppTheme.primaryBlue,
                        inactiveColor: AppTheme.mediumGray,
                        onChanged: (value) {
                          setState(() {
                            _merchantPct = value.toInt();
                            _platformPct = 100 - _merchantPct;
                          });
                        },
                      ),

                      // Porcentaje Plataforma
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppTheme.darkBlue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Plataforma',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$_platformPct%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkBlue,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _platformPct.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        activeColor: AppTheme.darkBlue,
                        inactiveColor: AppTheme.mediumGray,
                        onChanged: (value) {
                          setState(() {
                            _platformPct = value.toInt();
                            _merchantPct = 100 - _platformPct;
                          });
                        },
                      ),
                      
                      // Resumen de montos
                      if (_amountController.text.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildSplitRow(
                                label: 'Monto total',
                                amount: _getAmount(),
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                amountStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Divider(height: 20),
                              _buildSplitRow(
                                label: 'Comerciante',
                                amount: _getMerchantAmount(),
                                textStyle: const TextStyle(fontSize: 14),
                                amountStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildSplitRow(
                                label: 'Plataforma',
                                amount: _getPlatformAmount(),
                                textStyle: const TextStyle(fontSize: 14),
                                amountStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.darkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
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
                                  'Procesar Pago',
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
  
  Widget _buildCustomerAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dirección del Cliente',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _customerAddressController,
          decoration: InputDecoration(
            hintText: 'Ej: \$wallet.cliente.ejemplo',
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
              return 'Ingresa la dirección del cliente';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildMerchantAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
  
  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monto (MXN)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
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
          onChanged: (_) {
            // Actualizar la UI cuando cambia el valor
            setState(() {});
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa el monto';
            }
            if (double.tryParse(value) == null) {
              return 'Ingresa un monto válido';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  double _getAmount() {
    if (_amountController.text.isEmpty) {
      return 0;
    }
    try {
      return double.parse(_amountController.text);
    } catch (_) {
      return 0;
    }
  }
  
  double _getMerchantAmount() {
    final total = _getAmount();
    return total * _merchantPct / 100;
  }
  
  double _getPlatformAmount() {
    final total = _getAmount();
    return total * _platformPct / 100;
  }
  
  Widget _buildSplitRow({
    required String label,
    required double amount,
    required TextStyle textStyle,
    required TextStyle amountStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyle,
        ),
        Text(
          '\$${amount.toStringAsFixed(2)} MXN',
          style: amountStyle,
        ),
      ],
    );
  }
}