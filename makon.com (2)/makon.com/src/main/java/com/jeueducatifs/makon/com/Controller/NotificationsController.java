package com.jeueducatifs.makon.com.Controller;

import com.jeueducatifs.makon.com.Model.Notifications;
import com.jeueducatifs.makon.com.Model.User;
import com.jeueducatifs.makon.com.Package.NewGameNotificationRequest;
import com.jeueducatifs.makon.com.Repository.NotificationsRepository;
import com.jeueducatifs.makon.com.Service.NotificationsService;
import com.jeueducatifs.makon.com.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/notifications")
public class NotificationsController {

    @Autowired
    private NotificationsService notificationsService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NotificationsRepository notificationsRepository;

    // 1️⃣ Récupérer toutes les notifications
    @GetMapping
    public List<Notifications> getAllNotifications() {
        return notificationsRepository.findAllByOrderByDateNotifDesc();
    }


    // 2️⃣ Récupérer les notifications d’un utilisateur
    @GetMapping("/user/{userId}")
    public List<Notifications> getNotificationsForUser(@PathVariable Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
        return notificationsService.getAllForUser(user);
    }

    // 3️⃣ Marquer une notification comme lue
    @PostMapping("/{id}/read")
    public Notifications markAsRead(@PathVariable Integer id) {
        return notificationsService.markAsRead(id);
    }

    // 4️⃣ Créer une notification manuelle pour un utilisateur
    @PostMapping("/manual/{userId}")
    public Notifications createManualNotification(
            @PathVariable Integer userId,
            @RequestParam String title,
            @RequestParam String message
    ) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
        return notificationsService.saveManual(title, message, user);
    }

    // Méthode pour recevoir la notification d'un nouveau jeu
    @PostMapping("/newGame")
    public ResponseEntity<String> notifyNewGame(@RequestBody NewGameNotificationRequest request) {

        // Création de la notification
        Notifications notif = new Notifications();
        User user = userRepository.findById(request.getUserId()).get();


        notif.setUser(user);// à ajouter dans ton entity Notifications
        ///notif.setGameId(request.getGameId()); // idem
        notif.setTitle(request.getTitle());
        notif.setMessage(request.getMessage());
        notif.setDateNotif(LocalDateTime.now());

        notificationsService.saveNotification(notif);

        return ResponseEntity.ok("Notification envoyée avec succès !");
    }

    // Classe interne pour mapper le JSON reçu depuis Flutter

}
