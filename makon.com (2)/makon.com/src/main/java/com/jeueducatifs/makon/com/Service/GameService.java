package com.jeueducatifs.makon.com.Service;

import com.jeueducatifs.makon.com.Model.*;
import com.jeueducatifs.makon.com.Repository.GameRepository;
import com.jeueducatifs.makon.com.Repository.NotificationsRepository;
import com.jeueducatifs.makon.com.Repository.PlayRecordRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;

@Service
public class GameService {

    private final GameRepository gameRepository;
    private final PlayRecordRepository playRecordRepository;

    private NotificationsRepository notificationsRepository;


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
    public List<Map<String, Object>> getGameSummaries() {
        List<Object[]> results = gameRepository.findGameSummaries();
        return results.stream().map(row -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", row[0]);
            map.put("name", row[1]);
            map.put("numQuestions", row[2]);
            map.put("createdAt", row[3]);
            return map;
        }).toList();
    }
    public Game createGame(Game game, User user) {
        game.setUser(user);
        Game saved = gameRepository.save(game);

        // Créer une notification
        Notifications notif = new Notifications();
        notif.setUser(user);
        notif.setTypeNotif("NEW_GAME");
        notif.setMessage("Un nouveau jeu a été créé : " + game.getName());
        notificationsRepository.save(notif);

        return saved;
    }
}
