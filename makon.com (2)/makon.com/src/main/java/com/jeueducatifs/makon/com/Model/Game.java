package com.jeueducatifs.makon.com.Model;


import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Entity
@Data
public class Game {

    @Id
    private String id;

    private String name;

    @JsonSerialize(using = LocalDateTimeSerializer.class)
    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    private LocalDateTime createdAt;

    @ElementCollection
    @CollectionTable(name = "game_source", joinColumns = @JoinColumn(name = "game_id"))
    @MapKeyColumn(name = "`key`") // Utilisation des backticks
    @Column(name = "value", columnDefinition = "TEXT")
    @JsonSerialize(using = ToStringSerializer.class)
    private Map<String, String> source;

    private int numQuestions;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "game_id")
    @JsonManagedReference
    private List<Question> questions;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "game_id")
    private List<PlayRecord> plays;

    // Getters and setters
}
