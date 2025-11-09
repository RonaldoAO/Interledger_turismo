import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
    if (_payerControllers.length > 1) {
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
          const SnackBar(
            content: Text('Grupo de pago creado exitosamente'),
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

  Future<void> _launchPaymentUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}

  @override
  Widget build(BuildContext context) {
    if (_groupResponse != null) {
      return _buildGroupResults();
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pago en Grupo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Divide gastos con amigos fácilmente',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: 32),

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

              // Monto total
              TextFormField(
                controller: _totalAmountController,
                decoration: const InputDecoration(
                  labelText: 'Monto Total (MXN)',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
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
                  const Text(
                    'Miembros del grupo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addPayer,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Agregar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ..._payerControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Pagador ${index + 1}',
                            hintText: 'Ej: \$wallet.usuario${index + 1}.ejemplo',
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa la dirección del pagador';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_payerControllers.length > 1)
                        IconButton(
                          onPressed: () => _removePayer(index),
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.red,
                        ),
                    ],
                  ),
                );
              }).toList(),

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
                          'Crear Grupo de Pago',
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

  Widget _buildGroupResults() {
    final response = _groupResponse!;
    final totalAmount = response.totalMinor / 100;
    final sharePerPerson = totalAmount / response.count;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _groupResponse = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Expanded(
                  child: Text(
                    'Grupo Creado',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Resumen
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total a dividir',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        Text(
                          '${totalAmount.toStringAsFixed(2)} MXN',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Por persona',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        Text(
                          '${sharePerPerson.toStringAsFixed(2)} MXN',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Miembros del grupo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...response.results.map((result) {
              final share = result.shareMinor / 100;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    child: Text(
                      result.payer[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    result.payer,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${share.toStringAsFixed(2)} MXN'),
                  trailing: ElevatedButton.icon(
                    onPressed: () => _launchPaymentUrl(result.redirectUrl),
                    icon: const Icon(Icons.payment, size: 18),
                    label: const Text('Pagar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}