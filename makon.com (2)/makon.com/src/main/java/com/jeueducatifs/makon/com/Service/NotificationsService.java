package com.jeueducatifs.makon.com.Service;

import com.jeueducatifs.makon.com.Model.Game;
import com.jeueducatifs.makon.com.Model.Notifications;
import com.jeueducatifs.makon.com.Model.User;
import com.jeueducatifs.makon.com.Repository.NotificationsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class NotificationsService {

    @Autowired
    private NotificationsRepository repository;

    // ⚡ Nouvelle méthode générique pour créer une notification
    public Notifications createNotification(User user, String title, String message, String type) {
        Notifications n = new Notifications();
        n.setUser(user);
        n.setTitle(title);
        n.setMessage(message);
        n.setTypeNotif(type);   // par ex. "NEW_GAME" ou "manual"
        n.setDateNotif(LocalDateTime.now());
        n.setIsRead(false);
        return repository.save(n);
    }

    // Notification spécifique pour un nouveau jeu (optionnel)
    public Notifications saveNewGame(Game game, User user) {
        Notifications n = new Notifications();
        n.setTypeNotif("NEW_GAME");
        n.setTitle("Nouveau jeu");
        n.setMessage(game.getName() + " — " + game.getNumQuestions() + " questions");
        n.setDateNotif(LocalDateTime.now());
        n.setUser(user);
        n.setIsRead(false);
        return repository.save(n);
    }

    // Notification manuelle
    public Notifications saveManual(String title, String message, User user) {
        Notifications n = new Notifications();
        n.setTypeNotif("NEW_GAME");
        n.setTitle(title);
        n.setMessage(message);
        n.setDateNotif(LocalDateTime.now());
        n.setUser(user);
        n.setIsRead(false);
        return repository.save(n);
    }

    // Récupérer toutes les notifications d'un utilisateur
    public List<Notifications> getAllForUser(User user) {
        return repository.findByUserOrderByDateNotifDesc(user);
    }

    // Marquer une notification comme lue
    public Notifications markAsRead(Integer id) {
        Notifications n = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Notification non trouvée"));
        n.setIsRead(true);
        return repository.save(n);
    }


    public void saveNotification(Notifications notif) {


        repository.save(notif);
    }

}
