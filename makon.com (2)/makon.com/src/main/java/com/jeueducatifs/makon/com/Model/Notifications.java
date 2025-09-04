package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Setter
@Getter
public class Notifications {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_notif") // <-- ici le vrai nom de la colonne
    private Integer id;

    @Column(nullable = false)
    private LocalDateTime dateNotif = LocalDateTime.now();

    @Column(nullable = true)
    private String typeNotif;

    @Column(nullable = false)
    private String title;


    @Column(nullable = false, length = 500)
    private String message;

    @Column(nullable = false)
    private boolean isRead = false; // ✅ Nouvelle colonne : par défaut non lue

    @ManyToOne
    @JoinColumn(name = "id_user", nullable = false)
    private User user;

    public void setIsRead(boolean b) {
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
