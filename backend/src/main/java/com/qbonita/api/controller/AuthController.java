package com.qbonita.api.controller;

import com.qbonita.api.dto.LoginRequest;
import com.qbonita.api.dto.LoginResponse;
import com.qbonita.api.security.JwtService;
import jakarta.validation.Valid;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    public AuthController(AuthenticationManager authenticationManager, JwtService jwtService) {
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
    }

    @PostMapping("/login")
    public LoginResponse login(@Valid @RequestBody LoginRequest request) {
        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.usuario(), request.senha())
        );
        String usuario = auth.getName();
        String nome = auth.getPrincipal() instanceof com.qbonita.api.security.AdminUserDetails a
                ? a.getUsuario().getNome()
                : usuario;
        String token = jwtService.generateToken(usuario);
        return new LoginResponse(token, "Bearer", nome);
    }
}
