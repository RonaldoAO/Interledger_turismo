class CallbackResult {
  final String status;
  final String? payer;
  final List<dynamic> outgoingPayments;

  CallbackResult({
    required this.status,
    this.payer,
    required this.outgoingPayments,
  });

  factory CallbackResult.fromJson(Map<String, dynamic> json) {
    return CallbackResult(
      status: json['status'],
      payer: json['payer'],
      outgoingPayments: json['outgoingPayments'] ?? [],
    );
  }
}