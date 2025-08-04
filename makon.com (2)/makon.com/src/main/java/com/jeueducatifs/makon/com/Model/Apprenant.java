package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Inheritance(strategy = InheritanceType.JOINED )
@Setter
@Getter

public class Apprenant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private Integer niveau;

    @Column(nullable = false)
    private Integer scores;
    @Column(nullable = false)
    private Integer age;

    @Column(nullable = false)
    private String quartier;

    @Column(nullable = false)
    private String divertissements;


    @OneToOne
    @JoinColumn(name = "id_user",referencedColumnName = "id",nullable = false,unique = true)
    private User user;
@ManyToOne
    @JoinColumn (name = "classe" , referencedColumnName = "id_classe", nullable = false, unique = true)
    private Classe classe;




}
