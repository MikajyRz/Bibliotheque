<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Inscription - Bibliothèque</title>
</head>
<body>
<h2>Créer un compte</h2>
<div>
    <c:if test="${not empty error}">
        <div style="color:red">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div style="color:green">${success}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/register" method="post">
        <div>
            <label for="nom">Nom :</label>
            <input type="text" id="nom" name="nom" required/>
        </div>
        <div>
            <label for="email">Email :</label>
            <input type="email" id="email" name="email" required/>
        </div>
        <div>
            <label for="motDePasse">Mot de passe :</label>
            <input type="password" id="motDePasse" name="motDePasse" required/>
        </div>
        <div>
            <label for="dateNaissance">Date de naissance :</label>
            <input type="date" id="dateNaissance" name="dateNaissance" required
                pattern="\d{4}-\d{2}-\d{2}"
                placeholder="yyyy-mm-dd" />
        </div>
        <div>
            <label for="idTypeAdherent">Type d'adhérent :</label>
            <select id="idTypeAdherent" name="idTypeAdherent" required>
                <c:forEach var="type" items="${typesAdherent}">
                    <option value="${type.id_type_adherent}">${type.libelle}</option>
                </c:forEach>
            </select>
        </div>
        <button type="submit">Créer un compte</button>
    </form>
</div>
</body>
</html>