package com.jeueducatifs.makon.com.Service;

import com.jeueducatifs.makon.com.Config.JwtUtil;
import com.jeueducatifs.makon.com.Model.User;
import com.jeueducatifs.makon.com.Repository.UserRepository;
import com.jeueducatifs.makon.com.Request.AuthResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor


public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public User register(User user) {



        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
                throw new RuntimeException("Email déjà enregistré");
            }
            // Code pour enregistrer l'utilisateur dans la base de données


        user.setmotdepasse(passwordEncoder.encode( user.getmotdepasse()));
        user.setRole(user.getRole());
        user.setnomPrenom( user.getnomPrenom());
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());


            User saved = userRepository.save(user);
            saved.setmotdepasse(null); // On ne renvoie jamais le mot de passe encodé
            return saved;
        }

        public AuthResponse login(String email, String rawPassword) {
        User user = (User) userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("utilisateur introuvable"));
        if (!passwordEncoder.matches(rawPassword, user.getmotdepasse())) {

        }
        String token = jwtUtil.generateToken(user);
            assert user.getRole() != null;
            return new AuthResponse(
                token,
                user.getRole().toString(),
                user.getnomPrenom(),
                user.getEmail()

        );
    }

}
