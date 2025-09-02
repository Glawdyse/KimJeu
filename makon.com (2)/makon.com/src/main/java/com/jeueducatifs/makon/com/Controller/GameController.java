package com.jeueducatifs.makon.com.Controller;

import com.jeueducatifs.makon.com.Model.Game;
import com.jeueducatifs.makon.com.Model.PlayRecord;
import com.jeueducatifs.makon.com.Service.GameService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/games")
@CrossOrigin
public class GameController {

    private final GameService gameService;

    public GameController(GameService gameService) {
        this.gameService = gameService;
    }

    // Ajouter un PlayRecord (joueur + score + réponses)
    @PostMapping("/{gameId}/plays")
    public ResponseEntity<PlayRecord> addPlay(
            @PathVariable String gameId,
            @RequestBody PlayRecord play) {

        PlayRecord saved = gameService.addPlay(gameId, play);
        return ResponseEntity.ok(saved);
    }

    // Récupérer tous les PlayRecords pour un jeu
    @GetMapping("/{gameId}/plays")
    public ResponseEntity<List<PlayRecord>> getPlaysByGame(@PathVariable String gameId) {
        List<PlayRecord> plays = gameService.getPlaysByGame(gameId);
        return ResponseEntity.ok(plays);
    }

    // Autres endpoints existants
    @GetMapping
    public List<Game> getAllGames() {
        return gameService.getAllGames();
    }


    @GetMapping("/{id}")
    public ResponseEntity<Game> getGameById(@PathVariable String id) {
        return gameService.getGameById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Game createGame(@RequestBody Game game) {
        return gameService.saveGame(game);
    }

    @DeleteMapping("/{id}")
    public void deleteGame(@PathVariable String id) {
        gameService.deleteGame(id);
    }
}
