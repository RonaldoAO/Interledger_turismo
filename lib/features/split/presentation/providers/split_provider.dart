import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/split_repository_impl.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final splitRepositoryProvider = Provider<SplitRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SplitRepository(apiClient);
});