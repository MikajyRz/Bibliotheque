<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Prêt réussi</title>
</head>
<body>
<h2>Prêt effectué</h2>
<div style="color:green">
    ${success}
</div>
<a href="${pageContext.request.contextPath}/bibliothecaires/accueil">Retour à l'accueil</a>
</body>
</html>