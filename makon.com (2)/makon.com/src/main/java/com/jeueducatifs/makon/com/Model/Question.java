package com.jeueducatifs.makon.com.Model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Entity
@Data
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @JsonProperty("question")
    private String text;

    @JsonProperty("answerIndex")
    private String correctAnswer;

    private int difficulty;

    @ElementCollection
    @CollectionTable(name = "question_choices", joinColumns = @JoinColumn(name = "question_id"))
    @Column(name = "choice")
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private List<String> choices;

    @ManyToOne
    @JsonBackReference
    @JoinColumn(name = "game_id")
    private Game game;
}

