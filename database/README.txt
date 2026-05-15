Pasta database — MySQL
======================

Arquivos
--------
- **init.sql** — cria o banco `qbonita`, tabelas (`categorias`, `produtos`, `usuarios_admin`) e dados iniciais (12 categorias, 5 produtos, usuário admin).  
  Apaga dados antigos das tabelas (`DROP TABLE`) antes de recriar (ideal para ambiente de estudo).

- **docker-compose.yml** — MySQL 8 na porta **3306** (usuário **root**, senha **root**).

Senha do admin no SQL
---------------------
O script grava a senha como **`{noop}admin`**. O Spring Boot está configurado com
`DelegatingPasswordEncoder`, que aceita esse formato em desenvolvimento (texto com prefixo).
Login no app: usuário **admin**, senha **admin**.

Ordem recomendada
-----------------
1. `docker compose up -d` (nesta pasta `database`)

2. Aplicar o script:
   ```
   mysql -h 127.0.0.1 -P 3306 -u root -proot < init.sql
   ```
   Ou no PowerShell:
   ```
   Get-Content .\init.sql | mysql -h 127.0.0.1 -P 3306 -u root -proot
   ```

3. Subir o backend (`../backend`) com `mvn spring-boot:run`  
   O Hibernate está em `ddl-auto=none`: o schema vem só do SQL.

4. Subir o Flutter (`../frontend`).
