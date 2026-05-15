Flutter — QBonita App
=====================

Na primeira vez, gere as pastas de plataforma (android, ios, …) a partir desta pasta:

  flutter create . --project-name qbonita_app

Depois:

  flutter pub get
  flutter run

A URL da API está em `lib/core/app_config.dart` (emulador Android usa 10.0.2.2:8080 por padrão).
