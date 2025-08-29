package com.jeueducatifs.makon.com.Model;


import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class PlayAnswer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // clé primaire simple
    private Long id;

    private Integer answer; // la réponse choisie (ex: 1,2,3,4)

    // ✅ Chaque réponse appartient à un PlayRecord
    @ManyToOne
    @JoinColumn(name = "play_id")
    private PlayRecord playRecord;
}

