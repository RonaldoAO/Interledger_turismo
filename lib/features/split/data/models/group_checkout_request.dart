class GroupCheckoutRequest {
  final String merchantAddress;
  final int totalAmountMinor;
  final List<String> payers;

  GroupCheckoutRequest({
    required this.merchantAddress,
    required this.totalAmountMinor,
    required this.payers,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantAddress': merchantAddress,
      'totalAmountMinor': totalAmountMinor,
      'payers': payers,
    };
  }
}

class GroupCheckoutResponse {
  final String merchant;
  final int totalMinor;
  final int count;
  final List<PayerResult> results;

  GroupCheckoutResponse({
    required this.merchant,
    required this.totalMinor,
    required this.count,
    required this.results,
  });

  factory GroupCheckoutResponse.fromJson(Map<String, dynamic> json) {
    return GroupCheckoutResponse(
      merchant: json['merchant'],
      totalMinor: json['totalMinor'],
      count: json['count'],
      results: (json['results'] as List)
          .map((e) => PayerResult.fromJson(e))
          .toList(),
    );
  }
}

class PayerResult {
  final String payer;
  final int shareMinor;
  final String redirectUrl;
  final String nonce;

  PayerResult({
    required this.payer,
    required this.shareMinor,
    required this.redirectUrl,
    required this.nonce,
  });

  factory PayerResult.fromJson(Map<String, dynamic> json) {
    return PayerResult(
      payer: json['payer'],
      shareMinor: json['shareMinor'],
      redirectUrl: json['redirectUrl'],
      nonce: json['nonce'],
    );
  }
}