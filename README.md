# turex

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Instalación

- Requisitos: tener instalado `Flutter` y `Dart` en tu máquina.
- Instalar dependencias: `flutter pub get`
- Ejecutar la app: `flutter run`
- Ejecutar tests (opcional): `flutter test`
- Paquete de estado: `flutter_riverpod` (ya incluido en `pubspec.yaml`).

---

## Estructura de carpetas (propuesta)

La siguiente estructura prioriza un desarrollo modular por features y una clara separación por capas (data/domain/presentation), facilitando la colaboración entre equipos y el escalado del proyecto.

```text
lib/
  main.dart
  app/
    config/
      env.dart           # Variables/constantes de entorno
      routes.dart        # Definición de rutas
      theme.dart         # Temas y estilos
    di/
      injector.dart      # Inyección de dependencias (opcional)
  core/
    constants/           # Constantes reutilizables
    errors/              # Excepciones y manejo de errores
    network/             # Cliente HTTP, interceptores, etc.
    utils/               # Helpers y extensiones
    widgets/             # Widgets compartidos
  features/
    auth/
      data/
        datasources/     # Acceso a APIs, DB, cache
        models/          # Modelos serializables (DTOs)
        repositories/    # Implementaciones concretas
      domain/
        entities/        # Entidades de negocio puras
        repositories/    # Contratos/abstract de repos
        usecases/        # Casos de uso (lógica de negocio)
      presentation/
        controllers/     # Controladores/estado (Riverpod StateNotifier/Bloc/etc.)
        pages/           # Pantallas
        widgets/         # Widgets específicos del feature
    transfer/            # Ejemplo de otro feature
      ...
  l10n/                  # Internacionalización (si aplica)

test/
  features/
    auth/                # Tests por feature espejando lib/
      ...
```

### Convenciones rápidas

- Un feature = carpeta en `lib/features/<feature>` con `data`, `domain`, `presentation`.
- En `domain` no hay dependencias de Flutter; solo Dart puro.
- `data` implementa contratos de `domain` y orquesta `datasources`/`models`.
- `presentation` consume casos de uso y expone estado a la UI (en este repo: Riverpod con StateNotifier).
- `core` almacena utilidades y piezas transversales a múltiples features.

---

## Ejemplo mínimo (feature: auth)

Este ejemplo ilustra la interacción entre capas usando Riverpod (StateNotifier) para el estado y un flujo de login sencillo.

```dart
// lib/features/auth/domain/entities/user.dart
class User {
  final String id;
  final String email;
  const User({required this.id, required this.email});
}
```

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
}
```

```dart
// lib/features/auth/domain/usecases/login_use_case.dart
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<User> call(String email, String password) {
    return _repo.login(email, password);
  }
}
```

```dart
// lib/features/auth/data/datasources/auth_api.dart
import 'dart:async';
import '../../domain/entities/user.dart';

class AuthApi {
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (password == '123456') {
      return User(id: 'u_1', email: email);
    }
    throw Exception('Credenciales inválidas');
  }
}
```

```dart
// lib/features/auth/data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'] as String, email: json['email'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
```

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  AuthRepositoryImpl(this.api);

  @override
  Future<User> login(String email, String password) {
    return api.login(email, password);
  }
}
```

```dart
// lib/features/auth/presentation/controllers/auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthState {
  final bool loading;
  final User? user;
  final String? error;
  const AuthState({this.loading = false, this.user, this.error});

  AuthState copyWith({bool? loading, User? user, String? error}) => AuthState(
        loading: loading ?? this.loading,
        user: user ?? this.user,
        error: error,
      );
}

final authApiProvider = Provider<AuthApi>((ref) => AuthApi());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(authApiProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  AuthController(this.loginUseCase) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await loginUseCase(email, password);
      state = AuthState(user: user);
    } catch (e) {
      state = AuthState(error: e.toString());
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final login = ref.read(loginUseCaseProvider);
  return AuthController(login);
});
```

```dart
// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(authControllerProvider);
    final auth = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            if (s.loading) const CircularProgressIndicator(),
            if (s.error != null)
              Text(s.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: s.loading
                  ? null
                  : () => auth.login(_email.text, _password.text),
              child: const Text('Entrar'),
            ),
            if (s.user != null) Text('Hola, ' + (s.user!.email)),
          ],
        ),
      ),
    );
  }
}
```

```dart
// lib/app/config/routes.dart
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginPage());
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text('404'))),
      );
  }
}
```

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/config/routes.dart' as app_routes;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'turex',
      onGenerateRoute: (settings) => app_routes.onGenerateRoute(settings),
    );
  }
}
```

---

### Siguientes pasos sugeridos

- Crear las carpetas según el árbol anterior y mover/ajustar tus archivos.
- Elegir un gestor de estado (ChangeNotifier/Bloc/Riverpod) y unificar en `presentation/controllers`.
- Configurar `app/di/injector.dart` si prefieres DI centralizada.
- Añadir tests espejo en `test/features/...` para cada caso de uso y repo.

---

## Build para Android e iOS

Antes de compilar releases, ajusta versión, identificadores y firmas.

### Versión de la app

- Edita `pubspec.yaml:1` → `version: 1.0.0+1`
  - `1.0.0` = `versionName` (Android) / `CFBundleShortVersionString` (iOS)
  - `+1` = `versionCode` (Android) / `CFBundleVersion` (iOS)

### Android (APK/AAB)

- Requisitos: Android Studio + SDK, Java 17.
- Identificador del paquete: ajusta `applicationId` en `android/app/build.gradle.kts:1`.
- Firma de release:
  1) Genera keystore:
     - `keytool -genkey -v -keystore ~/turex.keystore -alias turex -keyalg RSA -keysize 2048 -validity 10000`
  2) Crea `android/key.properties`:
     - `storePassword=...`
     - `keyPassword=...`
     - `keyAlias=turex`
     - `storeFile=../turex.keystore` (o ruta absoluta)
  3) En `android/app/build.gradle.kts:1`, lee `key.properties` y configura `signingConfigs` y `buildTypes.release`.
- Compilar:
  - APK: `flutter build apk --release`
  - AAB (Play Store): `flutter build appbundle --release`
- Artefactos:
  - APK: `build/app/outputs/flutter-apk/app-release.apk`
  - AAB: `build/app/outputs/bundle/release/app-release.aab`

### iOS (IPA/TestFlight)

- Requisitos: macOS + Xcode + CocoaPods.
- Bundle Identifier y firma:
  - Abre `ios/Runner.xcworkspace` en Xcode.
  - Selecciona target Runner → Signing & Capabilities → Team y Bundle Identifier.
  - Asegura el Deployment Target acorde al `ios/Podfile` (por ejemplo, `platform :ios, '12.0'`).
- Compilar desde CLI (dispositivo o ad-hoc):
  - `flutter build ios --release`
- Publicación/TestFlight (recomendado):
  - En Xcode: Product → Archive → Distribute → App Store Connect.
- IPA (si es necesario para MDM/Ad-hoc):
  - Exporta desde Xcode Organizer tras el Archive.

### Notas útiles

- Ejecuta `flutter clean && flutter pub get` si cambias dependencias o configuración nativa.
- Revisa permisos en `android/app/src/main/AndroidManifest.xml:1` e `ios/Runner/Info.plist:1` si agregas funcionalidades (cámara, ubicación, etc.).
- Asegura que los íconos/splash estén configurados antes de publicar.
