package com.jeueducatifs.makon.com.Controller;

import com.jeueducatifs.makon.com.Model.User;
import com.jeueducatifs.makon.com.Repository.UserRepository;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@Data
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserRepository userRepository;

    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @PostMapping
    public User createUser(@RequestBody User user) {
        if (user.getId() == null) user.setId(null);

        // Générer mot de passe par défaut
        if (user.getmotdepasse() == null || user.getmotdepasse().isEmpty()) {
            user.setmotdepasse("changeme123"); // mot de passe par défaut
        }

        // Enregistrer createdAt
        user.setCreatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    @PatchMapping("/{id}/password")
    public User changePassword(@PathVariable Integer id, @RequestBody Map<String, String> body) {
        String newPass = body.get("motdepasse");
        return userRepository.findById(id).map(user -> {
            user.setmotdepasse(newPass);
            return userRepository.save(user);
        }).orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
    }

    @PutMapping("/{id}")
    public User updateUser(@PathVariable Integer id, @RequestBody User updated) {
        return userRepository.findById(id).map(user -> {
            user.setnomPrenom(updated.getnomPrenom());
            user.setEmail(updated.getEmail());
            user.setRole(updated.getRole());
            return userRepository.save(user);
        }).orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Integer id) {
        userRepository.deleteById(id);
    }
}
