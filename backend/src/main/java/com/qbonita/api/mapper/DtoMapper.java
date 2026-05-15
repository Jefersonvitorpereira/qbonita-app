package com.qbonita.api.mapper;

import com.qbonita.api.dto.CategoriaResponse;
import com.qbonita.api.dto.ProdutoResponse;
import com.qbonita.api.entity.Categoria;
import com.qbonita.api.entity.Produto;

public final class DtoMapper {

    private DtoMapper() {
    }

    public static CategoriaResponse toResponse(Categoria c) {
        return new CategoriaResponse(c.getId(), c.getNome(), c.isAtivo());
    }

    public static ProdutoResponse toResponse(Produto p) {
        return new ProdutoResponse(
                p.getId(),
                p.getNome(),
                p.getDescricao(),
                p.getValor(),
                toResponse(p.getCategoria()),
                p.getImagemPrincipal(),
                p.getImagemSecundaria(),
                p.isAtivo(),
                p.isDestaque(),
                p.getDataCriacao(),
                p.getDataAtualizacao()
        );
    }
}
