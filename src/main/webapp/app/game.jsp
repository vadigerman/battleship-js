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

        .hide-inpt .radio-btn {
            visibility: hidden;
        }

        td.SHIP {
            background-color: green;
        }
        td.MISS {
            background-color: cornflowerblue;
        }
        td.HIT {
            background-color: red;
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
                            <td id="t${col}${row}" class="w3-border"><input class="radio-btn" type="radio" name="target" id="${col}${row}"/></td>
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
                        <td id="m${col}${row}" class="w3-border" id="${col}${row}"></td>
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
                visibleInput("radio-btn", "w3-hide");
            } else if (game.status === "STARTED" && !game.playerActive) {
                document.getElementById("wait-another").classList.remove("w3-hide");
                document.getElementById("select-fire").classList.add("w3-hide");
                document.getElementById("button-fire").classList.add("w3-hide");
                hideInput("radio-btn", "w3-hide");
                window.setTimeout(function () {
                    checkStatus();
                }, 1000);
            } else if (game.status === "FINISHED") {
                location.href = "<c:url value='/app/result.jsp'/>";
                console.log(JSON.stringify(game));
                return;
            } else {
                return;
            }
            drawShips();
        });
    }
    function fire() {
        console.log("firing");
        var checked = document.querySelector('input[name=target]:checked');
        var checkedAddr = checked.id;
        console.log("firing addr " + checkedAddr);
        fetch("/api/game/fire/" + checkedAddr, {
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

    function drawShips() {
        fetch("<c:url value='/api/game/cells'/>", {
            "method": "GET",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (cells) {
            cells.forEach(function (c) {
                var id = (c.targetArea ? "t" : "m") + c.address;
                var tblCell = document.getElementById(id);
                tblCell.className = c.state;
            });
            hideInput("HIT", "hide-inpt");
            hideInput("MISS", "hide-inpt");
        });
    }

    function hideInput(findClass, addClass) {
        var inputs = document.getElementsByClassName(findClass);
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].classList.add(addClass);
        }
    }

    function visibleInput(findClass, removeClass) {
        var inputs = document.getElementsByClassName(findClass);
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].classList.remove(removeClass);
        }
    }
</script>
</body>
</html>
