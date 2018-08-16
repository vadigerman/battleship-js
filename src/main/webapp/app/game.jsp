<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Game</title>
    <style>
        .w3-border {
            border-collapse: collapse;
            text-align: center;
            vertical-align: middle;
        }

        td {
            width: 30px;
            height: 30px;
        }

        #placement-field {
            margin: 0 10px;
            display: inline-block;
        }

        .form-field {
            margin-bottom: 0;
        }

        #placement-another {
            display: inline-block;
            vertical-align: top;
        }

        #button-fire {
            margin-top: 10px;
        }
    </style>
</head>
<body onload="checkStatus()">
<div id="wait-another" class="w3-hide">
    <h1>Please wait another player</h1>
</div>
<div id="select-fire" class="w3-hide">
    <h1>Please check where to fire</h1>
</div>
<div class="">
    <div id="placement-field">
        <form class="form-field" action="">
            <table class="w3-border">
                <tr>
                    <td class="w3-border">&nbsp;</td>
                    <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                        <td class="w3-border"><c:out value="${col}"/></td>
                    </c:forTokens>
                </tr>
                <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
                    <tr>
                        <td class="w3-border"><c:out value="${row}"/></td>
                        <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                            <td class="w3-border"><input class="radio-btn" type="radio" name="target" id="${col}${row}"/></td>
                        </c:forTokens>
                    </tr>
                </c:forTokens>
            </table>
            <button id="button-fire" class="w3-hide" type="button" onclick="fire()">Fire!</button>
        </form>
    </div>
    <div id="placement-another">
        <table class="w3-border">
            <tr>
                <td class="w3-border">&nbsp;</td>
                <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                    <td class="w3-border"><c:out value="${col}"/></td>
                </c:forTokens>
            </tr>
            <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
                <tr>
                    <td class="w3-border"><c:out value="${row}"/></td>
                    <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                        <td class="w3-border" id="${col}${row}"></td>
                    </c:forTokens>
                </tr>
            </c:forTokens>
        </table>
    </div>
</div>
<script>
    function checkStatus() {
        console.log("checking status");
        fetch("<c:url value='/api/game/status'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (game) {
            console.log(JSON.stringify(game));
            if (game.status === "STARTED" && game.playerActive) {
                document.getElementById("wait-another").classList.add("w3-hide");
                document.getElementById("select-fire").classList.remove("w3-hide");
                document.getElementById("button-fire").classList.remove("w3-hide");
                var radioBtns = document.getElementsByClassName("radio-btn");
                for (var i = 0; i < radioBtns.length; i++) {
                    radioBtns[i].classList.remove("w3-hide");
                }
            } else if (game.status === "STARTED" && !game.playerActive) {
                document.getElementById("wait-another").classList.remove("w3-hide");
                document.getElementById("select-fire").classList.add("w3-hide");
                document.getElementById("button-fire").classList.add("w3-hide");
                var radioBtns = document.getElementsByClassName("radio-btn");
                for (var i = 0; i < radioBtns.length; i++) {
                    radioBtns[i].classList.add("w3-hide");
                }
                window.setTimeout(function () {
                    checkStatus();
                }, 1000);
            }
        });
    }
    function fire() {
        console.log("checking status");
        fetch("<c:url value='/api/game/fire'/>", {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            console.log("DONE");
            checkStatus();
        });
    }
</script>
</body>
</html>
