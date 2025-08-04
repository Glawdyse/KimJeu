package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Inheritance(strategy = InheritanceType.JOINED )
@Setter
@Getter
public class Educateur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private String specialité;

    @Column(nullable = false)
    private Integer age;

    @Column(nullable = false)
    private String quartier;


    @OneToOne
    @JoinColumn(name = "id_user",referencedColumnName = "id",nullable = false,unique = true)
    private User user;

}
