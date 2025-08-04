package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Inheritance(strategy = InheritanceType.JOINED )
@Setter
@Getter
public class Notifications {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_notif;

    @Column(nullable = false)
    private LocalDate date_notif;

    @Column(nullable = false)
    private String type_notif;

    @OneToOne
    @JoinColumn(name = "id_user",referencedColumnName = "id",nullable = false,unique = true)
    private User user;

}
