package com.jeueducatifs.makon.com.Request;


import jakarta.persistence.Column;
import lombok.Data;



import jakarta.persistence.Column;



@Data
public class AuthRequest {
    @Column(nullable = false,unique = true)
    public String email ;

    @Column(nullable = false,unique = true)
    public String motdepasse ;

    public String getmotdepasse() {
        return motdepasse;
    }

    public void setmotdepasse(String motdepasse) {
        this.motdepasse = motdepasse;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
