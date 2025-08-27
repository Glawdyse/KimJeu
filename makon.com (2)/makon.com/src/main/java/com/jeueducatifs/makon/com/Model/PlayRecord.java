package com.jeueducatifs.makon.com.Model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

@Entity
@Data
public class PlayRecord {

    @Id
    private String id;

    private String playerId;

    private int score;

    private LocalDateTime playedAt;

    @ElementCollection
    @CollectionTable(name = "play_answers", joinColumns = @JoinColumn(name = "play_id"))
    @MapKeyColumn(name = "question_id")
    @Column(name = "answer")
    private Map<String, String> answers;

    // Getters and setters
}



