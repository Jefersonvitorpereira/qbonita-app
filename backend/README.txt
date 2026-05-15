QBonita API — Spring Boot
=========================

Pré-requisitos: JDK 17+, Maven 3.9+, MySQL com schema já criado.

1) Crie o banco e as tabelas com o script da pasta irmã:
   ..\database\init.sql
   (veja ..\database\README.txt)

2) Rode a API a partir desta pasta (`backend`):
   mvn spring-boot:run

3) API: http://localhost:8080

Credenciais JDBC padrão (ajuste em src\main\resources\application.properties):
- URL: jdbc:mysql://localhost:3306/qbonita
- usuário: root
- senha: root

Endpoints principais
--------------------
- GET  /categorias
- GET  /produtos
- GET  /produtos/destaques
- GET  /produtos/categoria/{id}
- GET  /produtos/buscar?nome=
- GET  /produtos/{id}
- POST /auth/login   JSON: {"usuario":"admin","senha":"admin"}
- POST /produtos, PUT /produtos/{id}, DELETE /produtos/{id} (Bearer JWT)
