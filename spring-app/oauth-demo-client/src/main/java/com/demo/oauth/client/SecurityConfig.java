package com.demo.oauth.client;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity // Ao invés de herdar, usar essa anotação
public class SecurityConfig {

    //Filtros
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .authorizeHttpRequests(
                        // Ajusta as rotas que precisam de autenticação
                        // Ajusta as rotas que são de acesso público (primeiro)
                        authorizeConfig -> {
                            authorizeConfig.requestMatchers("/public").permitAll();
                            authorizeConfig.requestMatchers("/logout").permitAll();
                            authorizeConfig.anyRequest().authenticated();
                        }
                )
                .oauth2Login(Customizer.withDefaults())
                .oauth2ResourceServer(config -> {   //Ajusta para utilizar o jwt para autenticar os serviços
                    config.jwt(Customizer.withDefaults());
                })
                .build();
    }
}
