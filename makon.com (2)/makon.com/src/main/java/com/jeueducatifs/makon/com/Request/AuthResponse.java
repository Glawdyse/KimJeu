package com.jeueducatifs.makon.com.Request;

import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthResponse {

    public String token ;
     public String role;


    public String nomPrenom;

    public String email ;


}
