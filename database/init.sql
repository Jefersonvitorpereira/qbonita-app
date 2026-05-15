-- =============================================================================
-- QBonita — script MySQL (desenvolvimento / testes)
-- Execute no MySQL (Workbench, CLI ou Docker) ANTES de subir a API.
--
-- mysql -h 127.0.0.1 -P 3306 -u root -proot < init.sql
--
-- Após rodar: inicie o backend com spring.jpa.hibernate.ddl-auto=none
-- (já configurado em application.properties).
--
-- Admin do app: usuário admin / senha admin
-- A senha no banco usa o prefixo {noop} (texto plano) aceito pelo Spring
-- DelegatingPasswordEncoder — adequado só para estudo; em produção use BCrypt.
-- =============================================================================

CREATE DATABASE IF NOT EXISTS qbonita
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE qbonita;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS usuarios_admin;

-- ---------------------------------------------------------------------------
-- Tabelas (nomes alinhados ao Spring Data JPA / Hibernate — snake_case)
-- ---------------------------------------------------------------------------

CREATE TABLE categorias (
  id BIGINT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(120) NOT NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  data_criacao DATETIME(6) NOT NULL,
  data_atualizacao DATETIME(6) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE usuarios_admin (
  id BIGINT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(120) NOT NULL,
  usuario VARCHAR(80) NOT NULL,
  senha_hash VARCHAR(200) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_usuario (usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE produtos (
  id BIGINT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(200) NOT NULL,
  descricao VARCHAR(2000) NOT NULL,
  valor DECIMAL(12,2) NOT NULL,
  categoria_id BIGINT NOT NULL,
  imagem_principal VARCHAR(2000) NOT NULL,
  imagem_secundaria VARCHAR(2000) NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  destaque TINYINT(1) NOT NULL DEFAULT 0,
  data_criacao DATETIME(6) NOT NULL,
  data_atualizacao DATETIME(6) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_produtos_categoria (categoria_id),
  CONSTRAINT fk_produtos_categoria
    FOREIGN KEY (categoria_id) REFERENCES categorias (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Dados iniciais
-- ---------------------------------------------------------------------------

INSERT INTO usuarios_admin (id, nome, usuario, senha_hash) VALUES
(1, 'Administrador', 'admin', '{noop}admin');

INSERT INTO categorias (id, nome, ativo, data_criacao, data_atualizacao) VALUES
(1,  'Papelaria',                      1, NOW(6), NOW(6)),
(2,  'Escola',                         1, NOW(6), NOW(6)),
(3,  'Roupas Masculinas',              1, NOW(6), NOW(6)),
(4,  'Roupas Femininas',               1, NOW(6), NOW(6)),
(5,  'Roupas Infantis',                1, NOW(6), NOW(6)),
(6,  'Mochila, Lancheira e Estojo',    1, NOW(6), NOW(6)),
(7,  'Canecas',                        1, NOW(6), NOW(6)),
(8,  'Brinquedos e Jogos',             1, NOW(6), NOW(6)),
(9,  'Garrafas',                       1, NOW(6), NOW(6)),
(10, 'Presentes',                      1, NOW(6), NOW(6)),
(11, 'Viagem',                         1, NOW(6), NOW(6)),
(12, 'Acessórios',                     1, NOW(6), NOW(6));

INSERT INTO produtos (
  id, nome, descricao, valor, categoria_id,
  imagem_principal, imagem_secundaria, ativo, destaque,
  data_criacao, data_atualizacao
) VALUES
(1, 'Kit de Canetas Coloridas',
 'Canetas gel com cores vivas. Ótimo para planner e estudos.',
 24.90, 1,
 'https://picsum.photos/seed/qbonita_p1a/600/600',
 'https://picsum.photos/seed/qbonita_p1b/600/600',
 1, 1, NOW(6), NOW(6)),
(2, 'Caderno Universitário 10 matérias',
 'Capa dura, folhas pautadas, espiral reforçado.',
 42.00, 2,
 'https://picsum.photos/seed/qbonita_p2/600/600',
 NULL,
 1, 1, NOW(6), NOW(6)),
(3, 'Caneca Cerâmica QBonita',
 '325 ml, micro-ondas e lava-louças.',
 34.90, 7,
 'https://picsum.photos/seed/qbonita_p7/600/600',
 NULL,
 1, 1, NOW(6), NOW(6)),
(4, 'Mochila Escolar com Rodinhas',
 'Compartimento para notebook, alças acolchoadas.',
 189.00, 6,
 'https://picsum.photos/seed/qbonita_p6/600/600',
 'https://picsum.photos/seed/qbonita_p6b/600/600',
 1, 1, NOW(6), NOW(6)),
(5, 'Garrafa Térmica Inox 500ml',
 'Ideal para academia e passeios.',
 72.00, 9,
 'https://picsum.photos/seed/qbonita_p10/600/600',
 NULL,
 1, 0, NOW(6), NOW(6));

-- Reseta sequências AUTO_INCREMENT (MySQL 8+)
ALTER TABLE usuarios_admin AUTO_INCREMENT = 2;
ALTER TABLE categorias AUTO_INCREMENT = 13;
ALTER TABLE produtos AUTO_INCREMENT = 6;
