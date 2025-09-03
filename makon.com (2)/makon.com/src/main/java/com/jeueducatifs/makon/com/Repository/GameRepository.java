package com.jeueducatifs.makon.com.Repository;

import com.jeueducatifs.makon.com.Model.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface GameRepository extends JpaRepository<Game, String> {

    static Optional<Object> findByName(String name) {
        return null;
    }

    @Query(value = "SELECT g.id, g.name, g.num_questions, g.created_at FROM game g", nativeQuery = true)
    List<Object[]> findGameSummaries();
}


