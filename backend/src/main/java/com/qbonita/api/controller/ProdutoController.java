package com.qbonita.api.controller;

import com.qbonita.api.dto.ProdutoRequest;
import com.qbonita.api.dto.ProdutoResponse;
import com.qbonita.api.service.ProdutoService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/produtos")
public class ProdutoController {

    private final ProdutoService service;

    public ProdutoController(ProdutoService service) {
        this.service = service;
    }

    @GetMapping
    public List<ProdutoResponse> listar(Authentication authentication) {
        return service.listar(authentication);
    }

    @GetMapping("/destaques")
    public List<ProdutoResponse> destaques() {
        return service.destaques();
    }

    @GetMapping("/categoria/{categoriaId}")
    public List<ProdutoResponse> porCategoria(
            @PathVariable Long categoriaId,
            Authentication authentication
    ) {
        return service.porCategoria(categoriaId, authentication);
    }

    @GetMapping("/buscar")
    public List<ProdutoResponse> buscar(
            @RequestParam(name = "nome", required = false) String nome,
            Authentication authentication
    ) {
        return service.buscarPorNome(nome, authentication);
    }

    @GetMapping("/{id}")
    public ProdutoResponse buscar(@PathVariable Long id, Authentication authentication) {
        return service.buscar(id, authentication);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProdutoResponse criar(@Valid @RequestBody ProdutoRequest body) {
        return service.criar(body);
    }

    @PutMapping("/{id}")
    public ProdutoResponse atualizar(@PathVariable Long id, @Valid @RequestBody ProdutoRequest body) {
        return service.atualizar(id, body);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void excluir(@PathVariable Long id) {
        service.excluir(id);
    }
}
