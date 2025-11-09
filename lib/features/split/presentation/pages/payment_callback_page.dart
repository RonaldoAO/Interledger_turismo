import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/config/theme.dart';
import '../../data/models/callback_result.dart';
import '../providers/split_provider.dart';

class PaymentCallbackPage extends ConsumerStatefulWidget {
  final String interactRef;
  final String nonce;

  const PaymentCallbackPage({
    super.key,
    required this.interactRef,
    required this.nonce,
  });

  @override
  ConsumerState<PaymentCallbackPage> createState() =>
      _PaymentCallbackPageState();
}

class _PaymentCallbackPageState extends ConsumerState<PaymentCallbackPage> {
  bool _isLoading = true;
  CallbackResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  Future<void> _processCallback() async {
    try {
      final repository = ref.read(splitRepositoryProvider);
      final result = await repository.handleCallback(
        widget.interactRef,
        widget.nonce,
      );

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado del Pago'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/client'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isLoading
              ? _buildLoading()
              : _error != null
                  ? _buildError()
                  : _buildSuccess(),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: AppTheme.primaryBlue,
          strokeWidth: 3,
        ),
        const SizedBox(height: 24),
        Text(
          'Procesando tu pago...',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.darkGray,
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Error en el pago',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _error!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => context.go('/client'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Volver al Inicio'),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    final result = _result!;
    final isSuccess = result.status.toLowerCase() == 'completed' ||
        result.status.toLowerCase() == 'success';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isSuccess
                ? AppTheme.success.withOpacity(0.1)
                : AppTheme.pending.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSuccess ? Icons.check_circle_outline : Icons.schedule,
            color: isSuccess ? AppTheme.success : AppTheme.pending,
            size: 60,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isSuccess ? '¡Pago Exitoso!' : 'Pago Pendiente',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isSuccess
              ? 'Tu pago ha sido procesado correctamente'
              : 'Tu pago está siendo procesado',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 32),

        // Detalles del pago
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _DetailRow(
                  label: 'Estado',
                  value: result.status,
                  valueColor: isSuccess ? AppTheme.success : AppTheme.pending,
                ),
                if (result.payer != null) ...[
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Pagador',
                    value: result.payer!,
                  ),
                ],
                const Divider(height: 24),
                _DetailRow(
                  label: 'Pagos procesados',
                  value: '${result.outgoingPayments.length}',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/client'),
            icon: const Icon(Icons.home),
            label: const Text('Volver al Inicio'),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/history'),
          child: const Text('Ver Historial'),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.darkGray,
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
}