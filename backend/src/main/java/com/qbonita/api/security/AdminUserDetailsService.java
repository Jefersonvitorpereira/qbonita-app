package com.qbonita.api.security;

import com.qbonita.api.entity.UsuarioAdmin;
import com.qbonita.api.repository.UsuarioAdminRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class AdminUserDetailsService implements UserDetailsService {

    private final UsuarioAdminRepository repository;

    public AdminUserDetailsService(UsuarioAdminRepository repository) {
        this.repository = repository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UsuarioAdmin u = repository.findByUsuario(username)
                .orElseThrow(() -> new UsernameNotFoundException(username));
        return new AdminUserDetails(u);
    }
}
