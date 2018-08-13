package lv.ctco.javaschool.auth.entity.dto;

import lombok.Data;

@Data
public class UserLoginDto {
    private String username;
    private String password;
}
