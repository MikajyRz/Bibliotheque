<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Prêter un exemplaire</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        h2 {
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: inline-block;
            width: 150px;
            font-weight: bold;
        }
        select {
            padding: 5px;
            width: 300px;
        }
        button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .success-message {
            background-color: #dff0d8;
            color: #3c763d;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #3c763d;
            border-radius: 4px;
        }
        .error-message {
            background-color: #f2dede;
            color: #a94442;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #a94442;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<h2>Prêter un exemplaire</h2>

<!-- Afficher le message de succès -->
<c:if test="${not empty successMessage}">
    <div class="success-message">${successMessage}</div>
</c:if>

<!-- Afficher le message d'erreur -->
<c:if test="${not empty errorMessage}">
    <div class="error-message">${errorMessage}</div>
</c:if>

<form action="${pageContext.request.contextPath}/prets/nouveau" method="post">
    <div class="form-group">
        <label for="idAdherent">Adhérent :</label>
        <select name="idAdherent" id="idAdherent" required>
            <option value="">Sélectionner un adhérent</option>
            <c:forEach items="${adherents}" var="adherent">
                <option value="${adherent.id_adherent}">${adherent.nom} (${adherent.email})</option>
            </c:forEach>
        </select>
    </div>

    <div class="form-group">
        <label for="idExemplaire">Exemplaire :</label>
        <select name="idExemplaire" id="idExemplaire" required>
            <option value="">Sélectionner un exemplaire</option>
            <c:forEach items="${exemplaires}" var="exemplaire">
                <option value="${exemplaire.id_exemplaire}">
                    #${exemplaire.id_exemplaire} (${exemplaire.livre.titre})
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="form-group">
        <label for="idTypePret">Type de prêt :</label>
        <select name="idTypePret" id="idTypePret" required>
            <option value="">Sélectionner un type de prêt</option>
            <c:forEach items="${typesPret}" var="typePret">
                <option value="${typePret.id_type_pret}">${typePret.libelle}</option>
            </c:forEach>
        </select>
    </div>

    <button type="submit">Valider le prêt</button>
</form>
</body>
</html>