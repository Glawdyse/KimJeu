package com.jeueducatifs.makon.com.Request;

import com.jeueducatifs.makon.com.Model.PlayRecord;
import com.jeueducatifs.makon.com.Model.Question;
import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Data

@AllArgsConstructor
public class JeuResponse {


    public String name ;


    public Integer  numQuestions;


    public LocalDateTime createdAt ;


    public List<Question> questions;


    public Map<String, String> source;


    public List<PlayRecord> plays;
}




