package com.qbonita.api.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

public record ProdutoRequest(
        @NotBlank @Size(max = 200) String nome,
        @NotBlank @Size(max = 2000) String descricao,
        @NotNull @DecimalMin(value = "0.0", inclusive = true) BigDecimal valor,
        @NotNull Long categoriaId,
        @NotBlank @Size(max = 2000) String imagemPrincipal,
        @Size(max = 2000) String imagemSecundaria,
        @NotNull Boolean ativo,
        Boolean destaque
) {
}
