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
          const SnackBar(
            content: Text('Redirigiendo al proveedor de pagos...'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
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
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Split de Pago',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Divide el pago entre comerciante y plataforma',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: 32),

              // Dirección del cliente
              TextFormField(
                controller: _customerAddressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección del Cliente',
                  hintText: 'Ej: \$wallet.cliente.ejemplo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la dirección del cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dirección del comerciante
              TextFormField(
                controller: _merchantAddressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección del Comerciante',
                  hintText: 'Ej: \$wallet.negocio.ejemplo',
                  prefixIcon: Icon(Icons.store_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la dirección del comerciante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Monto
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Monto (MXN)',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              const SizedBox(height: 32),

              // Configuración de Split
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Distribución del pago',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Porcentaje Comerciante
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Comerciante',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$_merchantPct%',
                            style: const TextStyle(
                              fontSize: 20,
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
                        onChanged: (value) {
                          setState(() {
                            _merchantPct = value.toInt();
                            _platformPct = 100 - _merchantPct;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Porcentaje Plataforma
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Plataforma',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$_platformPct%',
                            style: const TextStyle(
                              fontSize: 20,
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
                        onChanged: (value) {
                          setState(() {
                            _platformPct = value.toInt();
                            _merchantPct = 100 - _platformPct;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón de envío
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
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
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}