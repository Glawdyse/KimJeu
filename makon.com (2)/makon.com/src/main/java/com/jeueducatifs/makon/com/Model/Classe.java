package com.jeueducatifs.makon.com.Model;


import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;


@Entity
@Inheritance(strategy = InheritanceType.JOINED )
@Setter
@Getter
public class Classe {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_classe;

    @Column(nullable = false)
    private Integer nomclasse;
    @ManyToOne
    @JoinColumn (name = "Educateur" , referencedColumnName = "id", nullable = false, unique = true)
    private Educateur educateur;
}


