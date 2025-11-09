import '../../../../core/network/api_client.dart';
import '../models/split_checkout_request.dart';
import '../models/group_checkout_request.dart';
import '../models/callback_result.dart';

class SplitRepository {
  final ApiClient _apiClient;

  SplitRepository(this._apiClient);

  Future<SplitCheckoutResponse> createSplitCheckout(
    SplitCheckoutRequest request,
  ) async {
    final response = await _apiClient.post(
      '/api/split/checkout',
      body: request.toJson(),
    );
    return SplitCheckoutResponse.fromJson(response);
  }

  Future<GroupCheckoutResponse> createGroupCheckout(
    GroupCheckoutRequest request,
  ) async {
    final response = await _apiClient.post(
      '/api/split/group-checkout',
      body: request.toJson(),
    );
    return GroupCheckoutResponse.fromJson(response);
  }

  Future<CallbackResult> handleCallback(
    String interactRef,
    String nonce,
  ) async {
    final response = await _apiClient.get(
      '/api/op/callback',
      queryParameters: {
        'interact_ref': interactRef,
        'nonce': nonce,
      },
    );
    return CallbackResult.fromJson(response);
  }
}