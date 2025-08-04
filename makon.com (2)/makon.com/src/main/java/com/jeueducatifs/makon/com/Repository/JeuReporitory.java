package com.jeueducatifs.makon.com.repository;

import com.jeueducatifs.makon.com.Model.Administrateur;
import com.jeueducatifs.makon.com.Model.Jeu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JeuReporitory extends JpaRepository<Jeu, Integer> {
}
