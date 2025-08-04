package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;


 @Entity
@Inheritance(strategy = InheritanceType.JOINED )
@Setter
@Getter
public class Administrateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_admin;


    @Column(nullable = false)
    private String password;
    @OneToOne
    @JoinColumn(name = "id_user",referencedColumnName = "id",nullable = false,unique = true)
    private User user;


}
