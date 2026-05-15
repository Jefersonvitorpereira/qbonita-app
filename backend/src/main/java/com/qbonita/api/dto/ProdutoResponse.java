package com.qbonita.api.dto;

import java.math.BigDecimal;
import java.time.Instant;

public record ProdutoResponse(
        Long id,
        String nome,
        String descricao,
        BigDecimal valor,
        CategoriaResponse categoria,
        String imagemPrincipal,
        String imagemSecundaria,
        boolean ativo,
        boolean destaque,
        Instant dataCriacao,
        Instant dataAtualizacao
) {
}
