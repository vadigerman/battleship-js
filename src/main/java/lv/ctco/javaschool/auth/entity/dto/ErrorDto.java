package lv.ctco.javaschool.auth.entity.dto;

import lombok.Data;

import javax.json.bind.annotation.JsonbProperty;

@Data
public class ErrorDto {
    @JsonbProperty
    private String errorCode;
    @JsonbProperty(nillable = true)
    private String message;
}
