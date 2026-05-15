import '../data/catalog_api_repository.dart';
import '../services/api_client.dart';
import '../services/auth_api_service.dart';

/// Ponto único de dependências (API, auth, catálogo).
class AppDependencies {
  AppDependencies._();

  static late final ApiClient api;
  static late final AuthApiService auth;
  static late final CatalogApiRepository catalog;

  static Future<void> init() async {
    api = ApiClient.instance;
    await api.init();
    auth = AuthApiService(api);
    await auth.restoreSession();
    catalog = CatalogApiRepository(api);
  }
}
