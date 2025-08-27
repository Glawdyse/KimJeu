package com.jeueducatifs.makon.com.Repository;

import com.jeueducatifs.makon.com.Model.Game;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GameRepository extends JpaRepository<Game, String> {

    static Optional<Object> findByName(String name) {
        return null;
    }
}


