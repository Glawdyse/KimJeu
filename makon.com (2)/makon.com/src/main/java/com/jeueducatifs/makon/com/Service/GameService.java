package com.jeueducatifs.makon.com.Service;

import com.jeueducatifs.makon.com.Model.Game;
import com.jeueducatifs.makon.com.Model.PlayAnswer;
import com.jeueducatifs.makon.com.Model.PlayRecord;
import com.jeueducatifs.makon.com.Model.Question;
import com.jeueducatifs.makon.com.Repository.GameRepository;
import com.jeueducatifs.makon.com.Repository.PlayRecordRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class GameService {

    private final GameRepository gameRepository;
    private final PlayRecordRepository playRecordRepository;

    public GameService(GameRepository gameRepository, PlayRecordRepository playRecordRepository) {
        this.gameRepository = gameRepository;
        this.playRecordRepository = playRecordRepository;
    }

    // Ajouter un PlayRecord pour un jeu
    public PlayRecord addPlay(String gameId, PlayRecord play) {
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new RuntimeException("Game not found"));

        // Associer le play au jeu
        play.setGame(game);
        play.setPlayedAt(LocalDateTime.now());

        // Transformer les réponses (integers) en PlayAnswer
        List<PlayAnswer> answers = play.getAnswers();
        if (answers != null) {
            answers.forEach(answer -> answer.setPlayRecord(play));
        }

        // Sauvegarder le PlayRecord et ses réponses (cascade)
        PlayRecord saved = playRecordRepository.save(play);

        // Ajouter le PlayRecord à la liste du jeu pour que getPlays() fonctionne
        game.getPlays().add(saved);
        gameRepository.save(game);

        return saved;
    }

    // Récupérer tous les PlayRecords pour un jeu
    public List<PlayRecord> getPlaysByGame(String gameId) {
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new RuntimeException("Game not found"));
        return game.getPlays();
    }

    // Autres méthodes existantes
    public Optional<Game> getGameById(String id) {
        return gameRepository.findById(id);
    }

    public Game saveGame(Game game) {
        if (game.getQuestions() != null) {
            for (Question question : game.getQuestions()) {
                question.setId(null);
            }
        }
        return gameRepository.save(game);
    }

    public void deleteGame(String id) {
        gameRepository.deleteById(id);
    }

    public List<Game> getAllGames() {
        return gameRepository.findAll();
    }
}
