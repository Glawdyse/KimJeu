package com.jeueducatifs.makon.com.Request;

import com.jeueducatifs.makon.com.Model.PlayRecord;
import com.jeueducatifs.makon.com.Model.Question;
import jakarta.persistence.Column;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data
public class JeuRequest {
    @Column(nullable = false,unique = true)
    private String id;

    public String name ;

    @Column(nullable = false,unique = true)
    public Integer  numQuestions;

    @Column(nullable = false,unique = true)
    public LocalDateTime createdAt ;


    @Column(nullable = false,unique = true)
    private List<Question> questions;

    @Column(nullable = false,unique = true)
    private Map<String, String> source;


    private List<PlayRecord> plays;




    }

