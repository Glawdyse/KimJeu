package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Inheritance(strategy = InheritanceType.JOINED )
@Setter
@Getter
public class Scores {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_score;

    @Column(nullable = false)
    private Integer nombres_points;

    @ManyToOne
    @JoinColumn(name = "jeu",referencedColumnName = "id_jeu",nullable = false,unique = true)
    private Jeu jeu;

}
