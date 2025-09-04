package com.jeueducatifs.makon.com.Package;

import jakarta.persistence.Entity;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Data
public class NewGameNotificationRequest {

    // getters et setters
    private Integer userId;
    private String gameId;
    private String title;
    private String message;


}
