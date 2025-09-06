package com.jeueducatifs.makon.com.Service;

import com.jeueducatifs.makon.com.Model.Game;
import com.jeueducatifs.makon.com.Model.PlayRecord;
import com.jeueducatifs.makon.com.Model.PlayAnswer;
import com.jeueducatifs.makon.com.Model.Notifications;
import com.jeueducatifs.makon.com.Model.User;
import com.jeueducatifs.makon.com.Repository.GameRepository;
import com.jeueducatifs.makon.com.Repository.PlayRecordRepository;
import com.jeueducatifs.makon.com.Repository.NotificationsRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class GameService {

    private final GameRepository gameRepository;
    private final PlayRecordRepository playRecordRepository;
    private final NotificationsRepository notificationsRepository;

    public GameService(GameRepository gameRepository,
                       PlayRecordRepository playRecordRepository,
                       NotificationsRepository notificationsRepository) {
        this.gameRepository = gameRepository;
        this.playRecordRepository = playRecordRepository;
        this.notificationsRepository = notificationsRepository;
    }

    // Ajouter un PlayRecord pour un jeu
    public PlayRecord addPlay(String gameId, PlayRecord play) {
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new RuntimeException("Game not found"));

        play.setGame(game);
        play.setPlayedAt(LocalDateTime.now());

        if (play.getAnswers() != null) {
            for (PlayAnswer answer : play.getAnswers()) {
                answer.setPlayRecord(play);
            }
        }

        PlayRecord saved = playRecordRepository.save(play);
        game.getPlays().add(saved);
        gameRepository.save(game);

        return saved;
    }

    public List<Game> getTopGames(int count) {
        Pageable pageable = PageRequest.of(0, count);
        return gameRepository.findTopGames(pageable).getContent();
    }

    public List<PlayRecord> getPlaysByGame(String gameId) {
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new RuntimeException("Game not found"));
        return game.getPlays();
    }

    public Optional<Game> getGameById(String id) {
        return gameRepository.findById(id);
    }

    public Game saveGame(Game game) {
        if (game.getQuestions() != null) {
            game.getQuestions().forEach(q -> q.setId(null));
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

        Notifications notif = new Notifications();
        notif.setUser(user);
        notif.setTypeNotif("NEW_GAME");
        notif.setMessage("Un nouveau jeu a été créé : " + game.getName());
        notificationsRepository.save(notif);

        return saved;
    }
}
