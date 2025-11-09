import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../app/config/theme.dart';

class DirectPaymentPage extends StatefulWidget {
  const DirectPaymentPage({Key? key}) : super(key: key);

  @override
  State<DirectPaymentPage> createState() => _DirectPaymentPageState();
}

class _DirectPaymentPageState extends State<DirectPaymentPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  
  String _selectedCurrency = 'USD';
  String _selectedPaymentMethod = 'QR';
  bool _isProcessing = false;
  bool _isPaymentComplete = false;
  
  // Lista de monedas disponibles
  final List<String> _currencies = ['USD', 'MXN', 'EUR', 'GBP'];
  
  // Lista de wallets
  final List<Map<String, dynamic>> _wallets = [
    {
      'id': 'wallet_1',
      'name': 'Mi Wallet Principal',
      'balance': 1250.75,
      'currency': 'USD',
      'cardNumber': '****4532',
      'icon': 'https://images.unsplash.com/photo-1640060498439-dbe775da4252?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80',
    },
    {
      'id': 'wallet_2',
      'name': 'Cuenta MXN',
      'balance': 15250.50,
      'currency': 'MXN',
      'cardNumber': '****7891',
      'icon': 'https://images.unsplash.com/photo-1595535873420-a599195b3f4a?ixlib=rb-1.2.1&auto=format&fit=crop&w=200&q=80',
    },
  ];
  
  Map<String, dynamic> _selectedWallet = {};

  @override
  void initState() {
    super.initState();
    // Seleccionar el primer wallet por defecto
    if (_wallets.isNotEmpty) {
      _selectedWallet = _wallets[0];
      _walletController.text = _selectedWallet['name'];
      _selectedCurrency = _selectedWallet['currency'];
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _walletController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  void _showWalletPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selecciona una cuenta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[600],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _wallets.length,
                  itemBuilder: (context, index) {
                    final wallet = _wallets[index];
                    final isSelected = wallet['id'] == _selectedWallet['id'];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[50] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedWallet = wallet;
                            _walletController.text = wallet['name'];
                            _selectedCurrency = wallet['currency'];
                          });
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: wallet['icon'],
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.grey[600],
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      wallet['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      wallet['cardNumber'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${wallet['balance'].toStringAsFixed(2)} ${wallet['currency']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Disponible',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _processPayment() {
    // Validar los campos
    if (_amountController.text.isEmpty || _selectedWallet.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
          backgroundColor: Colors.red[600],
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simular el procesamiento del pago
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
        _isPaymentComplete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pago Directo',
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[900],
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isPaymentComplete ? _buildPaymentSuccessful() : _buildPaymentForm(),
    );
  }

  Widget _buildPaymentForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de wallet
          _buildSectionTitle('Selecciona tu cuenta'),
          const SizedBox(height: 12),
          _buildWalletSelector(),
          const SizedBox(height: 24),

          // Sección de destinatario
          _buildSectionTitle('Destinatario'),
          const SizedBox(height: 12),
          _buildInputField(
            controller: _recipientController,
            hintText: 'Nombre o ID del destinatario',
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 24),

          // Sección de monto
          _buildSectionTitle('Monto a pagar'),
          const SizedBox(height: 12),
          _buildAmountInput(),
          const SizedBox(height: 24),

          // Sección de descripción
          _buildSectionTitle('Descripción (Opcional)'),
          const SizedBox(height: 12),
          _buildInputField(
            controller: _descriptionController,
            hintText: 'Ej. Pago de comida, Servicio, etc.',
            prefixIcon: Icons.description,
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Sección de método de pago
          _buildSectionTitle('Método de pago'),
          const SizedBox(height: 12),
          _buildPaymentMethodSelector(),
          const SizedBox(height: 32),

          // Botón de pagar
          _buildPayButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[900],
      ),
    );
  }

  Widget _buildWalletSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: _showWalletPicker,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_selectedWallet.isNotEmpty && _selectedWallet.containsKey('icon'))
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: _selectedWallet['icon'],
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
                  ),
                ),
              if (_selectedWallet.isEmpty)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedWallet.isNotEmpty
                          ? _selectedWallet['name']
                          : 'Seleccionar cuenta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    if (_selectedWallet.isNotEmpty)
                      const SizedBox(height: 4),
                    if (_selectedWallet.isNotEmpty)
                      Text(
                        'Saldo: ${_selectedWallet['balance'].toStringAsFixed(2)} ${_selectedWallet['currency']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey[500],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Icon(
              Icons.attach_money,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButton<String>(
              value: _selectedCurrency,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                }
              },
              underline: const SizedBox(),
              items: _currencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPaymentMethod = 'QR';
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedPaymentMethod == 'QR'
                    ? Colors.blue[600]
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: _selectedPaymentMethod == 'QR'
                      ? Colors.blue[600]!
                      : Colors.grey[300]!,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 32,
                    color: _selectedPaymentMethod == 'QR'
                        ? Colors.white
                        : Colors.grey[900],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Código QR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _selectedPaymentMethod == 'QR'
                          ? Colors.white
                          : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Generar código',
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedPaymentMethod == 'QR'
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPaymentMethod = 'NFC';
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedPaymentMethod == 'NFC'
                    ? Colors.blue[600]
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: _selectedPaymentMethod == 'NFC'
                      ? Colors.blue[600]!
                      : Colors.grey[300]!,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.contactless,
                    size: 32,
                    color: _selectedPaymentMethod == 'NFC'
                        ? Colors.white
                        : Colors.grey[900],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NFC',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _selectedPaymentMethod == 'NFC'
                          ? Colors.white
                          : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Acercar dispositivos',
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedPaymentMethod == 'NFC'
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isProcessing
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Continuar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // Aquí solamente actualizo el método _buildPaymentSuccessful() que tiene el problema de overflow

Widget _buildPaymentSuccessful() {
  final paymentAmount = double.tryParse(_amountController.text) ?? 0.0;
  final qrData = 'PAY|${_recipientController.text}|$paymentAmount|$_selectedCurrency|${_descriptionController.text}';

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            _selectedPaymentMethod == 'QR' 
                ? 'Código QR generado' 
                : 'Listo para pago NFC',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            _selectedPaymentMethod == 'QR'
                ? 'Muestra este código QR para completar el pago'
                : 'Acerca tu dispositivo al dispositivo receptor para completar el pago',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // QR Code or NFC icon
          _selectedPaymentMethod == 'QR'
              ? Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 180,
                    backgroundColor: Colors.white,
                    errorStateBuilder: (context, error) {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            'Error al generar QR',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[600],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.contactless,
                    size: 50,
                    color: Colors.blue[700],
                  ),
                ),
          
          const SizedBox(height: 24),
          
          // Detalles del pago
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPaymentDetail(
                  'Monto', 
                  '$paymentAmount $_selectedCurrency',
                  isHighlighted: true,
                ),
                const SizedBox(height: 12),
                _buildPaymentDetail(
                  'Destinatario', 
                  _recipientController.text.isNotEmpty
                      ? _recipientController.text
                      : 'No especificado',
                ),
                const SizedBox(height: 12),
                _buildPaymentDetail(
                  'Cuenta origen', 
                  _selectedWallet.isNotEmpty
                      ? _selectedWallet['name']
                      : 'No especificada',
                ),
                if (_descriptionController.text.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildPaymentDetail(
                    'Descripción', 
                    _descriptionController.text,
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isPaymentComplete = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Editar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí podrías guardar el código QR como imagen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _selectedPaymentMethod == 'QR'
                              ? 'Código QR guardado en galería'
                              : 'Configuración NFC guardada',
                        ),
                        backgroundColor: Colors.green[600],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    _selectedPaymentMethod == 'QR' ? 'Guardar QR' : 'Compartir',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

  Widget _buildPaymentDetail(String label, String value, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            color: isHighlighted ? Colors.blue[700] : Colors.grey[900],
          ),
        ),
      ],
    );
  }
}