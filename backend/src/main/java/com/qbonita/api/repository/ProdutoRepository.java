package com.qbonita.api.repository;

import com.qbonita.api.entity.Produto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {

    List<Produto> findByAtivoTrueOrderByNomeAsc();

    List<Produto> findByCategoriaIdAndAtivoTrueOrderByNomeAsc(Long categoriaId);

    List<Produto> findByNomeContainingIgnoreCaseAndAtivoTrueOrderByNomeAsc(String nome);

    List<Produto> findByDestaqueTrueAndAtivoTrueOrderByNomeAsc();

    List<Produto> findByCategoriaIdOrderByNomeAsc(Long categoriaId);
}
