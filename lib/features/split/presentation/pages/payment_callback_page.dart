import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/config/theme.dart';
import '../../data/models/callback_result.dart';
import '../providers/split_provider.dart';
import 'package:lottie/lottie.dart';

class PaymentCallbackPage extends ConsumerStatefulWidget {
  final String interactRef;
  final String nonce;

  const PaymentCallbackPage({
    super.key,
    required this.interactRef,
    required this.nonce,
  });

  @override
  ConsumerState<PaymentCallbackPage> createState() => _PaymentCallbackPageState();
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

      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Resultado del Pago'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/client'),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.lightGray,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
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
        SizedBox(
          width: 200,
          height: 200,
          child: Lottie.asset(
            'assets/animations/payment_processing.json', // Deberás agregar esta animación a tus assets
            repeat: true,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Procesando tu pago...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Estamos verificando tu transacción, por favor espera un momento.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.darkGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.error.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error_outline,
            color: AppTheme.error,
            size: 64,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Error en el pago',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
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
          child: ElevatedButton.icon(
            onPressed: () => context.go('/client'),
            icon: const Icon(Icons.home),
            label: const Text('Volver al inicio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: _processCallback,
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.darkGray,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: isSuccess
                ? AppTheme.success.withOpacity(0.1)
                : AppTheme.pending.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSuccess ? Icons.check_circle_outline : Icons.pending_actions,
            color: isSuccess ? AppTheme.success : AppTheme.pending,
            size: 64,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          isSuccess ? '¡Pago Exitoso!' : 'Pago Pendiente',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isSuccess
              ? 'Tu pago ha sido procesado correctamente'
              : 'Tu pago está siendo procesado, no te preocupes, ¡lo confirmaremos pronto!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 32),

        // Detalles del pago
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.mediumGray,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _DetailRow(
                label: 'Estado',
                value: result.status,
                valueColor: isSuccess ? AppTheme.success : AppTheme.pending,
                valueIcon: isSuccess
                    ? Icons.check_circle
                    : Icons.schedule,
              ),
              if (result.payer != null) ...[
                const Divider(height: 24),
                _DetailRow(
                  label: 'Pagador',
                  value: result.payer!,
                  valueIcon: Icons.person,
                ),
              ],
              const Divider(height: 24),
              _DetailRow(
                label: 'Pagos procesados',
                value: '${result.outgoingPayments.length}',
                valueIcon: Icons.receipt_long,
              ),
              
              // Podríamos agregar más detalles como fecha y hora, ID de transacción, etc.
             
            ],
          ),
        ),
        
        const SizedBox(height: 32),

        // Botones de acción
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/client'),
            icon: const Icon(Icons.home),
            label: const Text('Volver al Inicio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => context.go('/history'),
          icon: const Icon(Icons.history),
          label: const Text('Ver Historial'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.darkGray,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? valueIcon;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueIcon,
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
        Row(
          children: [
            if (valueIcon != null) ...[
              Icon(
                valueIcon,
                size: 16,
                color: valueColor ?? AppTheme.darkGray,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}