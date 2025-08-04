package com.jeueducatifs.makon.com.Controller;

import com.jeueducatifs.makon.com.Model.User;
import com.jeueducatifs.makon.com.Repository.UserRepository;
import com.jeueducatifs.makon.com.Request.AuthRequest;
import com.jeueducatifs.makon.com.Request.AuthResponse;
import com.jeueducatifs.makon.com.Service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;


@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor

public class AuthController {
    private final AuthService authService;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder; //injection ici

    @PostMapping("/register")
    public ResponseEntity<Map<String, String>> register(@RequestBody User user){
        user.setmotdepasse(passwordEncoder.encode(user.getmotdepasse()));
        userRepository.save(user);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(Map.of("message", "Inscription reussie"));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthRequest request) {
        try {
            AuthResponse token = authService.login(request.getEmail(), request.getmotdepasse());
            return ResponseEntity.ok(token);

        }
        catch (RuntimeException e) {
            // Renvoie une reponse   json avec un message d'erreur
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", e.getMessage()));
        }
    }

}
