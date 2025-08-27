package com.jeueducatifs.makon.com.Service;

import com.jeueducatifs.makon.com.Model.Game;
import com.jeueducatifs.makon.com.Model.PlayRecord;
import com.jeueducatifs.makon.com.Model.Question;
import com.jeueducatifs.makon.com.Repository.GameRepository;
import com.jeueducatifs.makon.com.Request.JeuResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class GameService {

    private final GameRepository gameRepository;


    public GameService(GameRepository gameRepository) {
        this.gameRepository = gameRepository;

    }

    public List<Game> getAllGames() {
        return gameRepository.findAll();
    }

    public Optional<Game> getGameById(String id) {
        return gameRepository.findById(id);
    }

    public Game saveGame(Game game) {


        if (game.getQuestions() != null) {
            for (Question question : game.getQuestions()) {
                question.setId(null); // ✅ Hibernate générera un nouvel UUID
            }
        }

        if (game.getPlays() != null) {
            for (PlayRecord play : game.getPlays()) {
                play.setId(null); // facultatif, si tu veux aussi régénérer les PlayRecord
            }
        }

        return gameRepository.save(game);
    }


    public void deleteGame(String id) {
        gameRepository.deleteById(id);
    }

    public JeuResponse enregistrer( String name , Integer  numQuestions, LocalDateTime createdAt , List<Question> questions, Map<String, String> source, List<PlayRecord> plays) {
        Game game  = (Game) GameRepository.findByName(name)
                .orElseThrow(() -> new RuntimeException("jeu introuvable"));



        assert game.getName() != null;
        return new JeuResponse(

                game.getName(),
                game.getNumQuestions(),
                game.getCreatedAt() ,
                game.getQuestions(),
                game.getSource(),
                game.getPlays()

        );
    }
}
