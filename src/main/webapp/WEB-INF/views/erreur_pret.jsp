<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Erreur de prêt</title>
</head>
<body>
<h2>Erreur lors du prêt</h2>
<div style="color:red">
    ${error}
</div>
<a href="${pageContext.request.contextPath}/prets/nouveau">Revenir au formulaire</a>
</body>
</html>