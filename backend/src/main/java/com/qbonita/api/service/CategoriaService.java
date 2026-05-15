package com.qbonita.api.service;

import com.qbonita.api.dto.CategoriaRequest;
import com.qbonita.api.dto.CategoriaResponse;
import com.qbonita.api.entity.Categoria;
import com.qbonita.api.exception.NotFoundException;
import com.qbonita.api.mapper.DtoMapper;
import com.qbonita.api.repository.CategoriaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CategoriaService {

    private final CategoriaRepository repository;

    public CategoriaService(CategoriaRepository repository) {
        this.repository = repository;
    }

    public List<CategoriaResponse> listarAtivas() {
        return repository.findByAtivoTrueOrderByNomeAsc().stream()
                .map(DtoMapper::toResponse)
                .toList();
    }

    public List<CategoriaResponse> listarTodasAdmin() {
        return repository.findAll().stream()
                .map(DtoMapper::toResponse)
                .toList();
    }

    public CategoriaResponse buscar(Long id) {
        Categoria c = repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));
        return DtoMapper.toResponse(c);
    }

    @Transactional
    public CategoriaResponse criar(CategoriaRequest req) {
        Categoria c = new Categoria();
        c.setNome(req.nome().trim());
        c.setAtivo(req.ativo() == null || req.ativo());
        return DtoMapper.toResponse(repository.save(c));
    }

    @Transactional
    public CategoriaResponse atualizar(Long id, CategoriaRequest req) {
        Categoria c = repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));
        c.setNome(req.nome().trim());
        if (req.ativo() != null) {
            c.setAtivo(req.ativo());
        }
        return DtoMapper.toResponse(repository.save(c));
    }

    @Transactional
    public void excluir(Long id) {
        if (!repository.existsById(id)) {
            throw new NotFoundException("Categoria não encontrada");
        }
        repository.deleteById(id);
    }

    public Categoria entidadePorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Categoria não encontrada"));
    }
}
