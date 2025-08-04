package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Inheritance(strategy = InheritanceType.JOINED )
@Setter
@Getter
public class Jeu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_jeu;

    @Column(nullable = false)
    private Integer niveau_jeu;

    @Column(nullable = false)
    private String theme;

    @Column(nullable = false,unique = true)
    private LocalDate date_creation;

    @Column(nullable = false,unique = true)
    private LocalDate listes_joueurs;

    @ManyToOne
    @JoinColumn(name = "user" , referencedColumnName = "id", nullable = false, unique = true)
    private User user;
}


