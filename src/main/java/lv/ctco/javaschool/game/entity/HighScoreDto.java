package lv.ctco.javaschool.game.entity;

import lombok.Data;

@Data
public class HighScoreDto {
    private boolean playerActive;
    private int bestScore;
    private GameStatus status;
}
