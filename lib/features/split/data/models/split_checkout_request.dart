class SplitCheckoutRequest {
  final String customerAddress;
  final String merchantAddress;
  final int amountMinor;
  final SplitConfig split;

  SplitCheckoutRequest({
    required this.customerAddress,
    required this.merchantAddress,
    required this.amountMinor,
    required this.split,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerAddress': customerAddress,
      'merchantAddress': merchantAddress,
      'amountMinor': amountMinor,
      'split': split.toJson(),
    };
  }
}

class SplitConfig {
  final int merchantPct;
  final int platformPct;

  SplitConfig({
    required this.merchantPct,
    required this.platformPct,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantPct': merchantPct,
      'platformPct': platformPct,
    };
  }
}

class SplitCheckoutResponse {
  final String redirectUrl;
  final String nonce;

  SplitCheckoutResponse({
    required this.redirectUrl,
    required this.nonce,
  });

  factory SplitCheckoutResponse.fromJson(Map<String, dynamic> json) {
    return SplitCheckoutResponse(
      redirectUrl: json['redirectUrl'],
      nonce: json['nonce'],
    );
  }
}