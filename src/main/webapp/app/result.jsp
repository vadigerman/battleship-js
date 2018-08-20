<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <title>Result</title>
</head>
<body onload="resultStatus()">
    <div id="win-div" class="w3-hide">
        <h1>Game win!</h1>
    </div>
    <div id="lose-div" class="w3-hide">
        <h1>Game lose!</h1>
    </div>
    <button type="button" onclick="startGame()">Start</button>
    <button type="button" onclick="returnToStart()">Return</button>
<script>
    function startGame() {
        fetch("<c:url value='/api/game'/>", {"method": "POST"})
            .then(function (response) {
                location.href = "/app/placement.jsp";
            });
    }

    function resultStatus() {
        console.log("checking status");
        fetch("<c:url value='/api/game/result'/>", {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        }).then(function (response) {
            return response.json();
        }).then(function (game) {
            console.log(JSON.stringify(game));
            if (game.status === "FINISHED" && game.playerActive) {
                document.getElementById("win-div").classList.remove("w3-hide");
            } else if ((game.status === "FINISHED" && !game.playerActive)) {
                document.getElementById("lose-div").classList.remove("w3-hide");
            }
        });
    }

    function returnToStart() {
        location.href = "<c:url value="start.jsp"/>"
    }
</script>
</body>
</html>
