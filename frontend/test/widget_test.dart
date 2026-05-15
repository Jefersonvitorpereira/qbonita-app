import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qbonita_app/core/app_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Inicializa dependências (prefs mock)', () async {
    SharedPreferences.setMockInitialValues({});
    await AppDependencies.init();
    expect(AppDependencies.catalog, isNotNull);
    expect(AppDependencies.auth, isNotNull);
  });
}
