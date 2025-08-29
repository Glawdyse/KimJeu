package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
public class PlayRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    private String playerId; // identifiant du joueur

    private int score;

    private LocalDateTime playedAt;

    // ✅ Relation avec PlayAnswer
    @OneToMany(mappedBy = "playRecord", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PlayAnswer> answers = new ArrayList<>();

    // ✅ Lien avec le jeu
    @ManyToOne
    @JoinColumn(name = "game_id")
    private Game game;
}
