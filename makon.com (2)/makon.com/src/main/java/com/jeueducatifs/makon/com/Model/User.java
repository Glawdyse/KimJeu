package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Data
@Entity
@Setter
@Inheritance(strategy = InheritanceType.JOINED)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private  String motdepasse;

    @Column(nullable = false)
    private  String nomPrenom;

    @Getter
    @Column(nullable = false, unique = true)
    private String email;


    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private  Role role;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public String getmotdepasse() {
        return motdepasse;
    }



    public void setmotdepasse(String motdepasse) {
        this.motdepasse = motdepasse;
    }

    public  String getnomPrenom() {
        return nomPrenom;
    }

    public void setnomPrenom(String nomPrenom) {
        this.nomPrenom = nomPrenom;
    }

    public  Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }


    public enum Role {
        EDUCATEUR,
        ADMIN,
        APPRENANT
    }
}

