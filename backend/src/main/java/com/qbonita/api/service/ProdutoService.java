package com.qbonita.api.service;

import com.qbonita.api.dto.ProdutoRequest;
import com.qbonita.api.dto.ProdutoResponse;
import com.qbonita.api.entity.Categoria;
import com.qbonita.api.entity.Produto;
import com.qbonita.api.exception.NotFoundException;
import com.qbonita.api.mapper.DtoMapper;
import com.qbonita.api.repository.ProdutoRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ProdutoService {

    private final ProdutoRepository produtoRepository;
    private final CategoriaService categoriaService;

    public ProdutoService(ProdutoRepository produtoRepository, CategoriaService categoriaService) {
        this.produtoRepository = produtoRepository;
        this.categoriaService = categoriaService;
    }

    public List<ProdutoResponse> listar(Authentication auth) {
        if (isAdmin(auth)) {
            return produtoRepository.findAll().stream().map(DtoMapper::toResponse).toList();
        }
        return produtoRepository.findByAtivoTrueOrderByNomeAsc().stream()
                .map(DtoMapper::toResponse)
                .toList();
    }

    public List<ProdutoResponse> destaques() {
        return produtoRepository.findByDestaqueTrueAndAtivoTrueOrderByNomeAsc().stream()
                .map(DtoMapper::toResponse)
                .toList();
    }

    public ProdutoResponse buscar(Long id, Authentication auth) {
        Produto p = produtoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Produto não encontrado"));
        if (!p.isAtivo() && !isAdmin(auth)) {
            throw new NotFoundException("Produto não encontrado");
        }
        return DtoMapper.toResponse(p);
    }

    public List<ProdutoResponse> porCategoria(Long categoriaId, Authentication auth) {
        if (isAdmin(auth)) {
            return produtoRepository.findByCategoriaIdOrderByNomeAsc(categoriaId).stream()
                    .map(DtoMapper::toResponse)
                    .toList();
        }
        return produtoRepository.findByCategoriaIdAndAtivoTrueOrderByNomeAsc(categoriaId).stream()
                .map(DtoMapper::toResponse)
                .toList();
    }

    public List<ProdutoResponse> buscarPorNome(String nome, Authentication auth) {
        String n = nome == null ? "" : nome.trim();
        if (n.isEmpty()) {
            return List.of();
        }
        if (isAdmin(auth)) {
            return produtoRepository.findAll().stream()
                    .filter(p -> p.getNome().toLowerCase().contains(n.toLowerCase()))
                    .map(DtoMapper::toResponse)
                    .toList();
        }
        return produtoRepository.findByNomeContainingIgnoreCaseAndAtivoTrueOrderByNomeAsc(n).stream()
                .map(DtoMapper::toResponse)
                .toList();
    }

    @Transactional
    public ProdutoResponse criar(ProdutoRequest req) {
        Categoria cat = categoriaService.entidadePorId(req.categoriaId());
        Produto p = new Produto();
        aplicar(p, req, cat);
        return DtoMapper.toResponse(produtoRepository.save(p));
    }

    @Transactional
    public ProdutoResponse atualizar(Long id, ProdutoRequest req) {
        Produto p = produtoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Produto não encontrado"));
        Categoria cat = categoriaService.entidadePorId(req.categoriaId());
        aplicar(p, req, cat);
        return DtoMapper.toResponse(produtoRepository.save(p));
    }

    @Transactional
    public void excluir(Long id) {
        if (!produtoRepository.existsById(id)) {
            throw new NotFoundException("Produto não encontrado");
        }
        produtoRepository.deleteById(id);
    }

    private void aplicar(Produto p, ProdutoRequest req, Categoria cat) {
        p.setNome(req.nome().trim());
        p.setDescricao(req.descricao().trim());
        p.setValor(req.valor());
        p.setCategoria(cat);
        p.setImagemPrincipal(req.imagemPrincipal().trim());
        p.setImagemSecundaria(
                req.imagemSecundaria() == null || req.imagemSecundaria().isBlank()
                        ? null
                        : req.imagemSecundaria().trim()
        );
        p.setAtivo(req.ativo());
        p.setDestaque(req.destaque() != null && req.destaque());
    }

    private boolean isAdmin(Authentication auth) {
        return auth != null
                && auth.isAuthenticated()
                && auth.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"));
    }
}
