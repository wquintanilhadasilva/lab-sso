package br.com.wqs.lab.gateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityWebFilterChain springSecurityFilterChain (ServerHttpSecurity http) {
//        http.authorizeRequests()
//                .anyRequest().authenticated()
//                .and()
//                .oauth2Login();
//        return http.build();

        http
            .oauth2Client()
            .and()
            .oauth2Login()
            .tokenEndpoint()
            .and()
            .userInfoEndpoint();

        http
            .sessionManagement()
            .sessionCreationPolicy(SessionCreationPolicy.ALWAYS);

        http
            .authorizeHttpRequests()
            .requestMatchers("/unauthenticated", "/oauth2/**", "/login/**").permitAll()
            .anyRequest()
            .fullyAuthenticated()
            .and()
            .logout()
            .logoutSuccessUrl("http://localhost:8080/realms/external/protocol/openid-connect/logout?redirect_uri=http://localhost:8081/");

        return http.build();
    }
}
