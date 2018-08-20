package lv.ctco.javaschool.game.entity;

import lombok.Data;
import lv.ctco.javaschool.auth.entity.domain.User;

import javax.persistence.*;

@Data
@Entity
public class HighScore {
    @Id
    @GeneratedValue
    private Long id;

    @OneToOne
    private User user;

    private int bestScore;

    @Enumerated(EnumType.STRING)
    private GameStatus status;
}
