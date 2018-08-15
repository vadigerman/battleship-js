<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Ship Placement</title>
</head>
<body>
<table>
    <tr>
        <td>&nbsp;</td>
        <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
            <td><c:out value="${col}"/></td>
        </c:forTokens>
    </tr>
    <c:forTokens items="1,2,3,4,5,6,7,8,9,10" delims="," var="row">
        <tr>
            <td><c:out value="${row}"/></td>
            <c:forTokens items="A,B,C,D,E,F,G,H,I,J" delims="," var="col">
                <td><input type="checkbox" id="${col}${row}" onchange="cellClicked('${col}${row}')"/></td>
            </c:forTokens>
        </tr>
    </c:forTokens>
</table>
<button type="button" onclick="ready()">Ready!</button>
<script>
    var data = {};

    function cellClicked(id) {
        var checkbox = document.getElementById(id);
        console.log(id + " " + checkbox.checked);
        data[id] = checkbox.checked ? "SHIP" : "EMPTY";
    }

    function ready() {
        console.log(JSON.stringify(data));
        fetch("<c:url value='/api/game/cells'/>", {
            "method": "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        }).then(function (response) {
            console.log("DONE");
        });
    }
</script>
</body>
</html>
