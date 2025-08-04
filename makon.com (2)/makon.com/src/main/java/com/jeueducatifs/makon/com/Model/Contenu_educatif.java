package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.autoconfigure.domain.EntityScan;

import java.time.LocalDate;

@Entity
@Inheritance(strategy = InheritanceType.JOINED )
@Setter
@Getter
public class Contenu_educatif {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_contenu;

    @Column(nullable = false)
    private String nom_contenu;

    @Column(nullable = false)
    private String type_contenu;

    @Column(nullable = false)
    private LocalDate date_saisie;
}
